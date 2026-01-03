# Running a Local LLM on Raspberry Pi 5 with llama.cpp and Docker
This repository shares my setup for running a local large language model (LLM) on a Raspberry Pi 5 (8GB RAM) using llama.cpp in a Docker container. It includes building llama.cpp with server support, running the OpenAI-compatible API via llama-server, and a nice ChatGPT-like web interface with Open WebUI.
Everything is orchestrated with docker-compose for easy startup and management.

## Why this setup?

- Fully local and private — no cloud dependency.
- Efficient on ARM64 (RPi 5).
- Web UI for easy chatting.
- Reproducible with Docker.

## Hardware Requirements

- Raspberry Pi 5 with 8GB RAM (recommended; 4GB might work with smaller models but slower).
- Good cooling (active cooler suggested for longer sessions).
- Fast storage (NVMe SSD via PCIe if possible, or good microSD).-- I used a 64GB sdcard

### Recommended Model
For good performance on RPi 5:

- gemma2:2b-it-q4_K_M.gguf (~1.5GB) — Fast (~10-15 tokens/s), smart for its size.
- Ministral-3-3B-Instruct-2512-Q8_0.gguf
- Alternatives:
- phi-3.5:mini-instruct Q4 (~2GB) — Excellent reasoning.
- qwen2.5:3b-instruct Q4 — Very capable.
- llama3.2:3b-instruct Q4 — Solid all-rounder.


Larger 7B Q4 models run but are slow (~2-5 tokens/s).
Download GGUF models from Hugging Face (e.g., bartowski or TheBloke repos or unsloth).

## Directory Structure to keep:
```text
.
├── Dockerfile          # Builds llama.cpp with server
├── docker-compose.yml # Runs llama-server + Open WebUI
├── Models/             # Put your .gguf model here (gitignored)
└── README.md
```

## Setup Instructions
1. Clone this repo
```bash
git clone https://github.com/vinayakcyber/Local-LLMs.git
cd Local-LLMs
```

2. Download a model
Create Models/ folder and place your .gguf file there, e.g.:
```bash
mkdir Models
cd Models
wget https://huggingface.co/bartowski/gemma2-2b-it-GGUF/resolve/main/gemma2-2b-it-Q4_K_M.gguf
cd ..
```

3. Update Dockerfile and docker-compose files CMD (optional but recommended)
Edit the CMD line in docker-compose to point to your model filename.

5. Build and run
```bash
docker-compose up -d --build
```

5. Access the Web UI
Open your browser: http://\<your-pi-ip\>:8080

The model will be auto-detected via the OpenAI-compatible API.

## Tips & Tweaks

- **Model parameters**: Edit the CMD in Dockerfile for more options like --ctx-size 8192, --threads 4, etc.
- **Performance**: Expect 5-15 tokens/s depending on model size. Use smaller contexts for faster response.
- **Monitoring**: docker logs llama-server to see inference stats.
- **Stop/Start**: docker-compose down / docker-compose up -d
