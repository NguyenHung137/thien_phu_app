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

def load_products():
    with open(PRODUCTS_FILE, 'r', encoding='utf-8') as f:
        return json.load(f)

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

def scrape_product(item):
    url = item['url']
    time.sleep(0.2) # Prevent overloading the server
    print(f"Scraping: {item['name']} - {url}")
    try:
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
        }
        r = requests.get(url, headers=headers, timeout=15)
        if r.status_code != 200:
            print(f"Error {r.status_code} for {url}")
            return item
        
        soup = BeautifulSoup(r.content, 'html.parser')
        
        # Look for the description container
        tab_desc = soup.find(id='tab-description')
        if not tab_desc:
            tab_desc = soup.find(class_='woocommerce-Tabs-panel--description')
        if not tab_desc:
            tab_desc = soup.find(class_='entry-content')
            
        if tab_desc:
            # Clean up image URLs inside the soup before extracting
            make_absolute_urls(tab_desc)

            # 1. Parse Specs Table
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
                            
            # 2. Extract detail images
            detail_images = []
            for img in tab_desc.find_all('img'):
                src = img.get('src')
                if src and src.startswith('http'):
                    # Avoid duplicate of main image
                    if src != item.get('image'):
                        detail_images.append(src)
            detail_images = list(dict.fromkeys(detail_images))
            
            # 3. Clean up the description HTML
            toc = tab_desc.find(id='ez-toc-container')
            if toc:
                toc.decompose()
            for t in tab_desc.find_all('table'):
                t.decompose()
            for f in tab_desc.find_all('form'):
                f.decompose()
            for cf in tab_desc.find_all(class_='wpcf7'):
                cf.decompose()
            for cta in tab_desc.find_all(class_='custom-product-cta'):
                cta.decompose()
                
            # Get the remaining HTML inside tab-description
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
        print(f"Error scraping {url}: {e}")
        return item

def main():
    products = load_products()
    detailed_map = load_detailed()
    
    # Filter products that need to be scraped
    to_scrape = []
    for item in products:
        url = item['url']
        # If already scraped and has full details, keep it
        if url in detailed_map and 'html_desc' in detailed_map[url] and detailed_map[url]['html_desc']:
            continue
        to_scrape.append(item)
        
    print(f"Total products: {len(products)}")
    print(f"Already scraped: {len(products) - len(to_scrape)}")
    print(f"To scrape: {len(to_scrape)}")
    
    if not to_scrape:
        print("All products are already scraped!")
        return

    # Use ThreadPoolExecutor to scrape in parallel
    max_workers = 8
    scraped_count = 0
    
    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        futures = {executor.submit(scrape_product, item): item for item in to_scrape}
        
        for future in as_completed(futures):
            scraped_item = future.result()
            detailed_map[scraped_item['url']] = scraped_item
            scraped_count += 1
            
            # Save progress every 20 products
            if scraped_count % 20 == 0:
                print(f"Saved progress ({scraped_count}/{len(to_scrape)})...")
                save_detailed(detailed_map)
                # Overwrite products.json periodically so progress is visible in the app immediately
                with open(PRODUCTS_FILE, 'w', encoding='utf-8') as f:
                    json.dump(list(detailed_map.values()), f, ensure_ascii=False, indent=2)
                
    save_detailed(detailed_map)
    # Final save to products.json
    with open(PRODUCTS_FILE, 'w', encoding='utf-8') as f:
        json.dump(list(detailed_map.values()), f, ensure_ascii=False, indent=2)
    print("Scraping completed and saved successfully!")

if __name__ == '__main__':
    main()
