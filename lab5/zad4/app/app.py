from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def hello_world():
    return f"Serwer działa na porcie {os.environ['PORT']}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.environ['PORT']))

