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
RUN wget -O /workspace/ComfyUI/models/checkpoints/illustrij17.safetensors \
    "https://civitai-delivery-worker-prod.5ac0637cfd0766c97916cefa3764fbdf.r2.cloudflarestorage.com/model/3920049/illustrij17.QUN8.safetensors?X-Amz-Expires=86400&response-content-disposition=attachment%3B%20filename%3D%22Illustrij17.safetensors%22&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=e01358d793ad6966166af8b3064953ad/20261111/us-east-1/s3/aws4_request&X-Amz-Date=20261111T115635Z&X-Amz-SignedHeaders=host&X-Amz-Signature=e8b58c28621a349166f8df0e947b05558132de32d683f2b1bc531dd0839e9ab9"
RUN wget -O /workspace/runpod-slim/ComfyUI/models/upscale_models/4x_foolhardy_Remacri.pth \
    "https://huggingface.co/FacehugmanIII/4x_foolhardy_Remacri/resolve/main/4x_foolhardy_Remacri.pth"

# 6. Expose ComfyUI port and start automatically
EXPOSE 8188
WORKDIR /workspace/ComfyUI
CMD ["python", "main.py", "--listen", "0.0.0.0", "--port", "8188"]
