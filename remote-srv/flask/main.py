from flask import Flask, jsonify

app = Flask(__name__)

path_status = "/tmp/status.txt"

def set_status(st):
    with open(path_status, "w", encoding="utf-8") as s:
        s.write(st)

def get_status():
    try:
        with open(path_status, "r", encoding="utf-8") as s:
            ss = s.read()
            return ss
    except:
        return "False"

@app.route("/webhook_tv_on", methods=["GET"])
def webhook_tv_on():
    set_status("True")
    return "OK"

@app.route("/webhook_tv_off", methods=["GET"])
def webhook_tv_off():
    set_status("False")
    return "OK"

@app.route("/status_tv", methods=["GET"])
def status_tv():
    return jsonify({'value': get_status()})

if __name__ == "__main__":
    app.run()
