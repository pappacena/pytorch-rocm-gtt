# pytorch_rocm_gtt

[![codecov](https://codecov.io/gh/pappacena/pytorch-rocm-gtt/branch/main/graph/badge.svg?token=pytorch-rocm-gtt_token_here)](https://codecov.io/gh/pappacena/pytorch-rocm-gtt)
[![CI](https://github.com/pappacena/pytorch-rocm-gtt/actions/workflows/main.yml/badge.svg)](https://github.com/pappacena/pytorch-rocm-gtt/actions/workflows/main.yml)


Python package to allow PyTorch ROCm to overcome the reserved iGPU memory limits.

Based on https://github.com/pomoke/torch-apu-helper/tree/main, after discussion here: https://github.com/ROCm/ROCm/issues/2014

## About
If you need to run machine learning workload, you usually need a bunch of GPU memory to hold your PyTorch tensors and your model. Ryzen APU (integrated GPUs) are usually quite good, and more recent versions of ROCm added support to some of those Radeon integrated graphics, but a major limitation is the amount of VRAM usually reserved to those GPUs.

But the VRAM used by those GPUs is actually shared with system memory, so there is no real reason for PyTorch to be
limited by the reserved memory only: it could potentially use the whole system RAM memory anyway.

This package patches pytorch at runtime, allowing it to allocate more memory than what is currently reserved in system BIOS for the integrated card.

All you need is ROCm and drivers properly installed ([check AMD documentation](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/how-to/native-install/index.html)), a `pip install pytorch_rocm_gtt` and a `pytorch_rocm_gtt.patch()` call in the begining of your script (thanks, [@segurac](https://github.com/segurac)!).


## Install it from PyPI

```bash
pip install pytorch_rocm_gtt
```

## Usage

Just call this before starting pytorch allocations (model or torch):

```py
import pytorch_rocm_gtt

pytorch_rocm_gtt.patch()
```

`hipcc` command should be in your `$PATH`.

After that, just allocate GPU memory as you would with cuda:

```py
import torch

torch.rand(1000).to("cuda")
```

## Compatibility
In order to use this package, your APU must be compatible with ROCm in the first place.

Check AMD documentation on how to install ROCm for your distribution.

## Docker images
We have pre-built images based on ROCm images, but also including the new memory allocator.

You can check the list of available images in [DockerHub](https://hub.docker.com/repository/docker/pappacena/rocm-pytorch/general).

For example, to run a python shell with ROCm 6.0.2, PyTorch 2.1.2 and the unbounded memory allocator, run this shell command:

```
$ docker run --rm -it \
  --cap-add=SYS_PTRACE \
  --security-opt seccomp=unconfined \
  --device=/dev/kfd \
  --device=/dev/dri \
  --group-add video \
  --ipc=host \
  --shm-size 8G \
  -e HSA_OVERRIDE_GFX_VERSION=11.0.1 \
  pappacena/rocm-pytorch:rocm6.0.2_ubuntu22.04_py3.10_pytorch_2.1.2 \
  python

Python 3.10.13 (main, Sep 11 2023, 13:44:35) [GCC 11.2.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import pytorch_rocm_gtt
>>> pytorch_rocm_gtt.patch()
>>> import torch
>>> torch.rand(1000, 1000).to("cuda")
tensor([[0.3428, 0.3032, 0.7657,  ..., 0.1255, 0.3866, 0.3153],
        [0.9015, 0.3409, 0.8885,  ..., 0.4413, 0.4961, 0.9245],
        [0.3883, 0.2388, 0.7439,  ..., 0.0647, 0.6922, 0.9496],
        ...,
        [0.4221, 0.7197, 0.5481,  ..., 0.5292, 0.7475, 0.3166],
        [0.1787, 0.9987, 0.7080,  ..., 0.8570, 0.3217, 0.1324],
        [0.6306, 0.0611, 0.1979,  ..., 0.1404, 0.4922, 0.2805]],
       device='cuda:0')
```


## Development

Read the [CONTRIBUTING.md](CONTRIBUTING.md) file.

### How to release

Update pyproject.toml file with the desired version, and run `make release` to create the new tag.

After that, the github action will publish to pypi.

Once it is published, run the `docker_build_and_publish.sh <version-number>` script to update the docker images.
