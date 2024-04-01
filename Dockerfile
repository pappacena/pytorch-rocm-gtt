ARG BASE_IMAGE=rocm/pytorch:rocm6.0.2_ubuntu22.04_py3.10_pytorch_2.1.2
ARG LIB_VERSION=0.1.0

FROM ${BASE_IMAGE}

RUN pip install pytorch_rocm_gtt==${LIB_VERSION}