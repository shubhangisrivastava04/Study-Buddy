from flask import Flask, request, jsonify, send_file
import requests
import os

app = Flask(__name__)

MASTER_URL = "http://localhost:5001"  # Master running on 5001
OUTPUT_DIR = "outputs"  # IMPORTANT: Must match master output folder


@app.route("/")
def home():
    return """
    <h2>Distributed Image Processing</h2>

    <form id="uploadForm" enctype="multipart/form-data">
      <p><b>Select Image:</b><br><input type="file" name="image" required></p>
      <p><b>Select Transformation:</b><br>
         <select name="transform">
           <option value="grayscale">Grayscale</option>
           <option value="blur">Blur</option>
         </select>
      </p>
      <button type="submit">Start Processing</button>
    </form>

    <div id="status" style="margin-top:20px;"></div>

    <script>
    document.getElementById('uploadForm').onsubmit = async function(e) {
        e.preventDefault();
        const formData = new FormData(e.target);

        document.getElementById("status").innerHTML = "<p>Uploading...</p>";

        const resp = await fetch("/upload", { method: "POST", body: formData });
        const data = await resp.json();

        if (!data.job_id) {
            document.getElementById("status").innerHTML = "<p>Error starting job.</p>";
            return;
        }

        const job_id = data.job_id;

        document.getElementById("status").innerHTML = `
            <p>Job ID: <b>${job_id}</b></p>
            <div style="width:300px;height:20px;border:1px solid #000;">
              <div id="bar" style="height:100%;width:0%;background:green;"></div>
            </div>
            <p id="percent">0%</p>
        `;

        const interval = setInterval(async () => {
            const r = await fetch('/progress/' + job_id);
            const p = await r.json();
            const progress = parseFloat(p.progress);

            document.getElementById('bar').style.width = progress + "%";
            document.getElementById('percent').innerText = p.progress;

            if (progress >= 100) {
                clearInterval(interval);
                document.getElementById("status").innerHTML += `
                    <br><button onclick="window.open('/output/${job_id}', '_blank')">
                        View Processed Image
                    </button>
                `;
            }
        }, 1000);
    };
    </script>
    """


@app.route("/upload", methods=["POST"])
def upload():
    image = request.files["image"]
    transform = request.form["transform"]

    files = {"image": (image.filename, image.stream, image.mimetype)}
    data = {"transform": transform}

    resp = requests.post(f"{MASTER_URL}/process", files=files, data=data)
    return jsonify(resp.json())


@app.route("/progress/<job_id>")
def progress(job_id):
    resp = requests.get(f"{MASTER_URL}/progress/{job_id}")
    return jsonify(resp.json())


@app.route("/output/<job_id>")
def get_output(job_id):
    path = os.path.join(OUTPUT_DIR, f"{job_id}_output.png")

    if not os.path.exists(path):
        return jsonify({"error": "Output not generated yet"}), 404

    return send_file(path, mimetype="image/png")


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

