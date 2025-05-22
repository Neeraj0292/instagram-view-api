from flask import Flask, request, jsonify
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import re

app = Flask(__name__)

@app.route('/get-views', methods=['POST'])
def get_views():
    data = request.json
    url = data.get("url")
    if not url:
        return jsonify({"error": "Missing URL"}), 400

    chrome_options = Options()
    chrome_options.add_argument("--headless")
    chrome_options.add_argument("--no-sandbox")
    chrome_options.add_argument("--disable-dev-shm-usage")

    driver = webdriver.Chrome(options=chrome_options)

    try:
        driver.get(url)
        html = driver.page_source
        match = re.search(r'([\d,.]+)\s+views', html)
        views = int(match.group(1).replace(",", "")) if match else 0
        return jsonify({"views": views})
    except Exception as e:
        return jsonify({"error": str(e)})
    finally:
        driver.quit()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
