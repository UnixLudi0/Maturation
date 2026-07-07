#!/bin/bash

#davinci-resolve-studio
yay -S --noconfirm davinci-resolve-studio
sudo mkdir /opt/resolve/libs/disabled-libraries
sudo mv /opt/resolve/libs/libglib* /opt/resolve/libs/libgio* /opt/resolve/libs/libgmodule* disabled-libraries

#throne
yay -S --noconfirm throne

#ComfyUI
git clone https://github.com/comfy-org/ComfyUI ComfyUI/custom_nodes
git clone https://github.com/Comfy-Org/ComfyUI-Manager  ComfyUI/custom_nodes/comfyui-manager
python -m venv venv
source venv/bin/activate
pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu132
pip install -r requirements.txt
pip install -r manager_requirements.txt
#add qemu later
