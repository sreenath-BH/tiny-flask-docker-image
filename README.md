# tiny-flask-docker-image

**The smallest possible Flask Docker image — only ~50 MB — for production use.**

---

## 📦 Overview
This project aims to create the most lightweight, production-ready Docker image capable of running a Flask app securely and efficiently. It uses a multi-stage build with Alpine Linux and minimal Python dependencies to achieve a tiny footprint.

**Goals:**
- Ultra-small footprint (~50 MB)  
- Secure runtime (minimal unnecessary tools)  
- Ease of use (just drop your `app.py` and `requirements.txt`)  
- Production-grade (run via WSGI server, not Flask dev server)

**🚀 Features**
- ✅ ~50 MB total image size
- ✅ Based on alpine for ultra-lightweight builds
- ✅ Multi-stage build (builder + final)
- ✅ Production-ready with Gunicorn
- ✅ Stripped binaries & minimal dependencies

---

## 🧱 How it works

The build is split into two stages:

1. **Builder stage**  
   - Uses `python:alpine` as base  
   - Installs dependencies (from `requirements.txt`)  
   - Strips shared object files, removes `ensurepip`, idlelib, unnecessary modules  
   - Produces a lean Python runtime + installed packages

2. **Final stage**  
   - Uses `alpine:latest`  
   - Installs only runtime libraries needed by CPython (BZ2, libffi, SQLite, etc.)  
   - Copies in the stripped runtime + installed packages  
   - Adds your Flask application (`app.py`)  
   - Runs the app under a WSGI server (Gunicorn) bound to `0.0.0.0:5000`

By doing all pip work in the builder and copying the result into the final image, we never need pip or build tools in the runtime container — reducing size and surface area.

---

### 🛠️ Build and Usage
```bash
docker build -t tiny-flask .         # ./docker-build.sh
docker run -p 5000:5000 tiny-flask   # ./docker-run.sh
```
Then open: http://localhost:5000 in your browser

---

### ⚙️ Production Notes
This image uses Gunicorn as a WSGI server instead of Flask’s built-in development server — making it ready for real deployments.

---

### 📜 License
MIT License — feel free to fork, modify, and use.

#### Copyright&copy; 2025 [ArdeshirV](mailto:ArdeshirV@protonmail.com), Licensed under MIT




