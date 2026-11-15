# 1. Start from RunPod's official PyTorch + CUDA base image
FROM runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04

# 2. Install system tools and graphics libraries
RUN apt-get update && apt-get install -y git wget aria2 libgl1 libglib2.0-0 && rm -rf /var/lib/apt/lists/*

# 3. Clone ComfyUI and install requirements
WORKDIR /workspace
RUN git clone https://github.com/Comfy-Org/ComfyUI
WORKDIR /workspace/ComfyUI
RUN pip install --no-cache-dir -r requirements.txt

# 4. Install ComfyUI-Manager, Impact-Pack, and Impact-Subpack
WORKDIR /workspace/ComfyUI/custom_nodes
# RUN git clone https://github.com
# ComfyUI-Impact-Pack
RUN git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack && \
    pip install --no-cache-dir -r ComfyUI-Impact-Pack/requirements.txt && \
    python ComfyUI-Impact-Pack/install.py
# ComfyUI-Impact-Subpack
RUN git clone https://github.com/ltdrdata/ComfyUI-Impact-Subpack && \
    pip install --no-cache-dir -r ComfyUI-Impact-Subpack/requirements.txt && \
    python ComfyUI-Impact-Subpack/install.py

# 5. Download your models (replace with your model URLs)
#RUN wget -O /workspace/ComfyUI/models/checkpoints/illustrij17.safetensors \
#    "https://civitai.com/api/download/models/2001618?fileId=1898811"
RUN wget -O /workspace/ComfyUI/models/upscale_models/4x_foolhardy_Remacri.pth \
    "https://huggingface.co/FacehugmanIII/4x_foolhardy_Remacri/resolve/main/4x_foolhardy_Remacri.pth"

# 6. Expose ComfyUI port and start automatically
EXPOSE 8188
WORKDIR /workspace/ComfyUI
CMD ["python", "main.py", "--listen", "0.0.0.0", "--port", "8188"]
