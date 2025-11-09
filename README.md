# NebulaMandel

NebulaMandel — Parallel Mandelbrot renderer using CUDA.

A compact project demonstrating GPU parallelism to render fractal images efficiently. This repository intentionally excludes school assignment files and personal output files (see `.gitignore`).

## Quick overview
- Language: C++/CUDA (nvcc)
- Files: `image.cu`, `image.h`, `pmandelbrot.cu`, `smandelbrot.cu`

## Quick run (local)
1. Ensure CUDA toolkit is installed and `nvcc` is on your PATH.
2. Build with nvcc (example):

```powershell
cd "C:\Users\ganam\OneDrive\Desktop\Fall Semester 2025\Parallel Processing CSC 473\Assignment3"
nvcc -o pmandelbrot.exe pmandelbrot.cu image.cu
```

3. Run to produce an image:

```powershell
./pmandelbrot.exe
```

## Files excluded from this repo
- pmandelbrot.exp, smandelbrot.exp, presult.pgm, sresult.pgm

If you want me to add a small build script or a CONTRIBUTING.md, tell me and I'll add it.
