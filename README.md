# pytorch_rocm_gtt

[![codecov](https://codecov.io/gh/pappacena/pytorch-rocm-gtt/branch/main/graph/badge.svg?token=pytorch-rocm-gtt_token_here)](https://codecov.io/gh/pappacena/pytorch-rocm-gtt)
[![CI](https://github.com/pappacena/pytorch-rocm-gtt/actions/workflows/main.yml/badge.svg)](https://github.com/pappacena/pytorch-rocm-gtt/actions/workflows/main.yml)


Python package to allow ROCm to overcome the reserved iGPU memory limits.

Based on https://github.com/pomoke/torch-apu-helper/tree/main, after discussion here: https://github.com/ROCm/ROCm/issues/2014

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

## Development

Read the [CONTRIBUTING.md](CONTRIBUTING.md) file.

### How to release

Update pyproject.toml file with the desired version, and run `make release` to create the new tag.

After that, the github action will publish to pypi.

Once it is published, run the `docker_build_and_publish.sh <version-number>` script to update the docker images.
