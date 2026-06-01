import json
import os
import requests
import socket
import urllib3.util.connection as connection

# Force IPv4 for Windows networking compatibility
connection.allowed_gai_families = lambda: (socket.AF_INET,)

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
PRODUCTS_FILE = "assets/data/products.json"

headers = {
    "apikey": SUPABASE_KEY,
    "Authorization": f"Bearer {SUPABASE_KEY}",
    "Content-Type": "application/json",
    "Prefer": "resolution=merge-duplicates"  # Upsert based on unique constraint (url)
}

def upload_products():
    if not os.path.exists(PRODUCTS_FILE):
        print(f"Error: {PRODUCTS_FILE} not found!")
        return

    with open(PRODUCTS_FILE, 'r', encoding='utf-8') as f:
        products = json.load(f)

    total_products = len(products)
    print(f"Loaded {total_products} products from {PRODUCTS_FILE}")

    # Prepare data for insertion
    payloads = []
    for item in products:
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

    # Insert in batches of 50 to prevent payload size limits
    batch_size = 50
    inserted_count = 0
    url = f"{SUPABASE_URL}/rest/v1/products?on_conflict=url"

    print("Uploading to Supabase...")
    for i in range(0, len(payloads), batch_size):
        batch = payloads[i:i + batch_size]
        try:
            r = requests.post(url, headers=headers, json=batch, timeout=30)
            if r.status_code in [200, 201]:
                inserted_count += len(batch)
                print(f"Successfully uploaded batch {i//batch_size + 1} ({inserted_count}/{total_products})")
            else:
                print(f"Failed to upload batch starting at index {i}. Status: {r.status_code}")
                print(r.text)
        except Exception as e:
            print(f"Error uploading batch: {e}")

    print(f"Finished! Uploaded {inserted_count} products out of {total_products} to Supabase database.")

if __name__ == '__main__':
    upload_products()
