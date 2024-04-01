import subprocess

subprocess.run([
    "hipcc",
    "pytorch_rocm_gtt/gttalloc.cc",
    "-o",
    "pytorch_rocm_gtt/gttalloc.so",
    "-shared",
    "-fPIC",
], check=True)