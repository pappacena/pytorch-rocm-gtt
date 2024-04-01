def patch():
    import torch

    new_alloc = torch.cuda.memory.CUDAPluggableAllocator(
        "gttalloc.so",
        "gtt_alloc",
        "gtt_free",
    )
    torch.cuda.memory.change_current_allocator(new_alloc)
