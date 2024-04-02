import os
import subprocess

import torch

HERE = os.path.dirname(__file__)
SO_FILE_NAME = "gttalloc.so"
SOURCE_FILE_NAME = "gttalloc.c"


def patch():
    compile()

    new_alloc = torch.cuda.memory.CUDAPluggableAllocator(
        os.path.join(HERE, SO_FILE_NAME),
        "gtt_alloc",
        "gtt_free",
    )
    torch.cuda.memory.change_current_allocator(new_alloc)


def compile():
    if os.path.exists(os.path.join(HERE, "gttalloc.so")):
        return

    subprocess.run(
        [
            "hipcc",
            os.path.join(HERE, SOURCE_FILE_NAME),
            "-o",
            os.path.join(HERE, SO_FILE_NAME),
            "-shared",
            "-fPIC",
        ],
        check=True,
    )
