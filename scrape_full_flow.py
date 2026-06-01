import json
import os
import sys
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
import requests
from bs4 import BeautifulSoup
import urllib3.util.connection as connection
import socket

# Force IPv4 to resolve SSL handshake timeouts on Windows
connection.allowed_gai_families = lambda: (socket.AF_INET,)

# Ensure standard output supports UTF-8 on Windows
if sys.stdout.encoding != 'utf-8':
    try:
        sys.stdout.reconfigure(encoding='utf-8')
    except AttributeError:
        pass

PRODUCTS_FILE = 'assets/data/products.json'
DETAILED_FILE = 'assets/data/products_detailed.json'

def load_env():
    if os.path.exists('.env'):
        with open('.env', 'r', encoding='utf-8') as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith('#') and '=' in line:
                    k, v = line.split('=', 1)
                    os.environ[k.strip()] = v.strip()

load_env()
SUPABASE_URL = os.environ.get("SUPABASE_URL", "https://nmumsfxdgngceclogyuw.supabase.co")
SUPABASE_KEY = os.environ.get("SUPABASE_KEY", "")

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
}

category_mapping = {
    "may-dong-goi": "Đóng Gói",
    "may-chiet-rot": "Chiết Rót",
    "may-che-bien-thuc-pham": "Thực Phẩm",
    "may-nganh-duoc": "Ngành Dược",
    "tu-dong-tu-trung-bay": "Tủ Đông - Tủ Mát",
    "noi-thanh-trung-tiet-trung": "Thanh Trùng - Tiệt Trùng",
    "day-chuyen-san-xuat": "Dây Chuyền",
    "cac-loai-may-khac": "Khác",
}

def get_main_category(classes):
    cats = []
    for c in classes:
        if c.startswith("product_cat-"):
            cat_slug = c.replace("product_cat-", "")
            cats.append(cat_slug)
            
    if not cats:
        return "Khác"
        
    for cat_slug in cats:
        for key, val in category_mapping.items():
            if cat_slug == key:
                return val
                
    for cat_slug in cats:
        for key, val in category_mapping.items():
            if key in cat_slug:
                return val
                
    fallback = cats[0].replace("-", " ").title()
    if "thit" in fallback or "rau" in fallback or "thuc pham" in fallback.lower():
        return "Thực Phẩm"
    if "chiet rot" in fallback.lower():
        return "Chiết Rót"
    if "dong goi" in fallback.lower():
        return "Đóng Gói"
    if "duoc" in fallback.lower() or "vien" in fallback.lower():
        return "Ngành Dược"
    if "day chuyen" in fallback.lower():
        return "Dây Chuyền"
    return "Khác"

def scrape_main_list():
    all_products = []
    page = 1
    max_pages = 50
    
    print("Step 1: Scraping all product summaries from congnghemaythienphu.com/san-pham/ ...")
    while page <= max_pages:
        url = f"https://congnghemaythienphu.com/san-pham/page/{page}/" if page > 1 else "https://congnghemaythienphu.com/san-pham/"
        print(f"Scraping Page {page}: {url} ...")
        
        try:
            response = requests.get(url, headers=headers, timeout=15)
            if response.status_code == 404:
                print(f"Reached end of products (404 on page {page})")
                break
                
            if response.status_code != 200:
                print(f"Failed to fetch page {page}. Status: {response.status_code}")
                time.sleep(2)
                response = requests.get(url, headers=headers, timeout=15)
                if response.status_code != 200:
                    print(f"Failed again on page {page}, stopping.")
                    break
                    
            soup = BeautifulSoup(response.content, "html.parser")
            product_divs = soup.find_all("div", class_="product")
            
            if not product_divs:
                print(f"No products found on page {page}, stopping.")
                break
                
            page_products_count = 0
            for div in product_divs:
                col_inner = div.find(class_="col-inner")
                if not col_inner:
                    continue
                    
                link_el = col_inner.find("a", class_="woocommerce-LoopProduct-link")
                if not link_el:
                    title_wrapper = col_inner.find(class_="product-title")
                    if title_wrapper:
                        link_el = title_wrapper.find("a")
                        
                if not link_el:
                    continue
                    
                name = link_el.get_text(strip=True)
                link_href = link_el.get("href")
                
                img_el = col_inner.find("img")
                img_src = ""
                if img_el:
                    img_src = img_el.get("data-src") or img_el.get("src") or img_el.get("data-lazy-src") or ""
                    if img_src.startswith("/"):
                        img_src = "https://congnghemaythienphu.com" + img_src
                
                price_el = col_inner.find(class_="price")
                price = ""
                if price_el:
                    price = price_el.get_text(strip=True)
                    
                classes = div.get("class", [])
                category = get_main_category(classes)
                
                desc = f"Thiết bị {name} chính hãng chất lượng cao, cung cấp bởi Công nghệ máy Thiên Phú. Vận hành bền bỉ, bảo hành dài hạn."
                
                product_data = {
                    "name": name,
                    "image": img_src,
                    "url": link_href,
                    "price": price if price else "Liên hệ",
                    "category": category,
                    "desc": desc
                }
                
                all_products.append(product_data)
                page_products_count += 1
                
            print(f"Successfully scraped {page_products_count} products from page {page}")
            page += 1
            time.sleep(0.3)
            
        except Exception as e:
            print(f"Error scraping page {page}: {e}")
            break
            
    print(f"Summary Scraping Complete! Total products: {len(all_products)}")
    return all_products

def load_detailed():
    if os.path.exists(DETAILED_FILE):
        with open(DETAILED_FILE, 'r', encoding='utf-8') as f:
            try:
                data = json.load(f)
                return {item['url']: item for item in data}
            except Exception:
                return {}
    return {}

def save_detailed(products_map):
    with open(DETAILED_FILE, 'w', encoding='utf-8') as f:
        json.dump(list(products_map.values()), f, ensure_ascii=False, indent=2)

def make_absolute_urls(soup, base_url="https://congnghemaythienphu.com"):
    for img in soup.find_all('img'):
        src = img.get('src')
        if src and src.startswith('/'):
            img['src'] = base_url + src
        dsrc = img.get('data-src')
        if dsrc and dsrc.startswith('/'):
            img['src'] = base_url + dsrc
            del img['data-src']
        elif dsrc:
            img['src'] = dsrc
            del img['data-src']

def scrape_product_details(item):
    url = item['url']
    time.sleep(0.1) # Friendly delay
    print(f"Scraping Details: {item['name']} - {url}")
    try:
        r = requests.get(url, headers=headers, timeout=15)
        if r.status_code != 200:
            print(f"Error {r.status_code} details for {url}")
            return item
        
        soup = BeautifulSoup(r.content, 'html.parser')
        
        tab_desc = soup.find(id='tab-description')
        if not tab_desc:
            tab_desc = soup.find(class_='woocommerce-Tabs-panel--description')
        if not tab_desc:
            tab_desc = soup.find(class_='entry-content')
            
        if tab_desc:
            make_absolute_urls(tab_desc)

            # Specs Table
            specs = {}
            tables = tab_desc.find_all('table')
            for table in tables:
                for tr in table.find_all('tr'):
                    tds = tr.find_all('td')
                    if len(tds) >= 2:
                        key = tds[0].get_text(strip=True)
                        val = tds[1].get_text(strip=True)
                        if key and val:
                            specs[key] = val
                            
            # Detail images
            detail_images = []
            for img in tab_desc.find_all('img'):
                src = img.get('src')
                if src and src.startswith('http'):
                    if src != item.get('image'):
                        detail_images.append(src)
            detail_images = list(dict.fromkeys(detail_images))
            
            # Clean HTML description
            toc = tab_desc.find(id='ez-toc-container')
            if toc:
                toc.decompose()
            for t in tab_desc.find_all('table'):
                # Decompose contact/branch tables, keep specs/model tables
                t_text = t.get_text().lower()
                if 'chi nhánh' in t_text or 'hotline' in t_text or 'bản đồ' in t_text or 'địa chỉ' in t_text:
                    t.decompose()
            for f in tab_desc.find_all('form'):
                f.decompose()
            for cf in tab_desc.find_all(class_='wpcf7'):
                cf.decompose()
            for cta in tab_desc.find_all(class_='custom-product-cta'):
                cta.decompose()
                
            html_desc = "".join([str(child) for child in tab_desc.children]).strip()
        else:
            html_desc = f"<p>{item['desc']}</p>"
            specs = {}
            detail_images = []
            
        new_item = item.copy()
        new_item['html_desc'] = html_desc
        new_item['specs'] = specs
        new_item['detail_images'] = detail_images
        
        return new_item
    except Exception as e:
        print(f"Error scraping details for {url}: {e}")
        return item

def main():
    # Step 1: Scrape all products (creates/restores base list)
    products = scrape_main_list()
    
    # Step 2: Load already scraped details
    detailed_map = load_detailed()
    
    # Merge existing details into the newly scraped product list
    merged_products = []
    to_scrape = []
    
    for item in products:
        url = item['url']
        if url in detailed_map and 'html_desc' in detailed_map[url] and detailed_map[url]['html_desc']:
            # Already has details, keep it
            merged_products.append(detailed_map[url])
        else:
            # Needs detailed scraping
            to_scrape.append(item)
            merged_products.append(item)
            
    print(f"Currently have detailed info for {len(products) - len(to_scrape)} products.")
    print(f"Need to scrape details for {len(to_scrape)} products.")
    
    # Write initial list containing merged items to products.json
    # Build dictionary map of all products
    full_detailed_map = {item['url']: item for item in merged_products}
    
    # Save the base list to files immediately
    save_detailed(full_detailed_map)
    with open(PRODUCTS_FILE, 'w', encoding='utf-8') as f:
        json.dump(list(full_detailed_map.values()), f, ensure_ascii=False, indent=2)
        
    if not to_scrape:
        print("All products are fully scraped!")
        return

    # Step 3: Scrape details in parallel
    max_workers = 16
    scraped_count = 0
    
    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        futures = {executor.submit(scrape_product_details, item): item for item in to_scrape}
        
        for future in as_completed(futures):
            scraped_item = future.result()
            full_detailed_map[scraped_item['url']] = scraped_item
            scraped_count += 1
            
            # Save progress every 20 products
            if scraped_count % 20 == 0:
                print(f"Saved progress ({scraped_count}/{len(to_scrape)})...")
                save_detailed(full_detailed_map)
                with open(PRODUCTS_FILE, 'w', encoding='utf-8') as f:
                    json.dump(list(full_detailed_map.values()), f, ensure_ascii=False, indent=2)
                    
    # Final saves
    save_detailed(full_detailed_map)
    final_list = list(full_detailed_map.values())
    with open(PRODUCTS_FILE, 'w', encoding='utf-8') as f:
        json.dump(final_list, f, ensure_ascii=False, indent=2)
        
    print("Full scraping and details integration completed successfully!")
    
    # Sync to Supabase
    try:
        sync_to_supabase(final_list)
    except Exception as e:
        print(f"Failed to sync to Supabase: {e}")

def sync_to_supabase(products_list):
    print("Syncing data to Supabase...")
    headers = {
        "apikey": SUPABASE_KEY,
        "Authorization": f"Bearer {SUPABASE_KEY}",
        "Content-Type": "application/json",
        "Prefer": "resolution=merge-duplicates"
    }
    url = f"{SUPABASE_URL}/rest/v1/products?on_conflict=url"
    payloads = []
    for item in products_list:
        payload = {
            "name": item.get("name", ""),
            "image": item.get("image", ""),
            "url": item.get("url", ""),
            "price": item.get("price", "Liên hệ"),
            "category": item.get("category", "Khác"),
            "desc": item.get("desc", ""),
            "html_desc": item.get("html_desc", f"<p>{item.get('desc', '')}</p>"),
            "specs": item.get("specs", {}),
            "detail_images": item.get("detail_images", [])
        }
        payloads.append(payload)
        
    batch_size = 50
    inserted_count = 0
    for i in range(0, len(payloads), batch_size):
        batch = payloads[i:i + batch_size]
        try:
            r = requests.post(url, headers=headers, json=batch, timeout=30)
            if r.status_code in [200, 201]:
                inserted_count += len(batch)
            else:
                print(f"Failed to sync batch starting at {i}. Status: {r.status_code}. Details: {r.text}")
        except Exception as e:
            print(f"Error syncing batch: {e}")
            
    print(f"Synced {inserted_count}/{len(payloads)} products to Supabase!")

if __name__ == '__main__' :
    main()
