import requests
import socket
import urllib3.util.connection as connection
from bs4 import BeautifulSoup
import re

connection.allowed_gai_families = lambda: (socket.AF_INET,)

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
}

def search_articles():
    # Let's search Google for articles about Thien Phu Machine
    query = '"chế tạo máy Thiên Phú" OR "máy Thiên Phú" tin tức OR bài báo'
    url = f"https://www.google.com/search?q={query}"
    r = requests.get(url, headers=headers, timeout=15)
    soup = BeautifulSoup(r.content, 'html.parser')
    
    print("Google Search Results:")
    links = []
    for a in soup.find_all('a'):
        href = a.get('href', '')
        # Match any url containing vietnamese news domains or containing 'congnghemaythienphu'
        match = re.search(r'url\?q=(https://[^&]+)', href)
        clean_url = match.group(1) if match else href
        if clean_url.startswith('http') and 'google.com' not in clean_url:
            links.append(clean_url)
                
    # Remove duplicates
    links = list(dict.fromkeys(links))
    for l in links:
        print("-", l)

if __name__ == '__main__':
    search_articles()
