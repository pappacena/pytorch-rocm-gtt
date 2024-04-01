#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <tag>"
    exit 1
fi
TAG=$1

docker build -t pappacena/rocm-pytorch:rocm6.0.2_ubuntu22.04_py3.10_pytorch_2.1.2 \
		--build-arg="BASE_IMAGE=rocm/pytorch:rocm6.0.2_ubuntu22.04_py3.10_pytorch_2.1.2" \
		--build-arg="LIB_VERSION=${TAG}" .
docker push pappacena/rocm-pytorch:rocm6.0.2_ubuntu22.04_py3.10_pytorch_2.1.2