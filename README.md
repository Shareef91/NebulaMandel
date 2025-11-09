# NebulaMandel

NebulaMandel — Parallel Mandelbrot renderer using CUDA.

A compact project demonstrating GPU parallelism to render fractal images efficiently. This repository intentionally excludes school assignment files and personal output files (see `.gitignore`).

## Quick overview
- Language: C++/CUDA (nvcc)
- Files: `image.cu`, `image.h`, `pmandelbrot.cu`, `smandelbrot.cu`

## Quick run (local)
1. Ensure the CUDA toolkit is installed and `nvcc` is on your PATH.
2. Build with nvcc (example):

```powershell
cd "<path-to-repo>"   # e.g. C:\projects\NebulaMandel or wherever you cloned the repo
nvcc -o pmandelbrot.exe pmandelbrot.cu image.cu
```

3. Run to produce an image (writes an example output `presult.pgm`):

```powershell
./pmandelbrot.exe
```

## Example result
This repository includes an example result file `presult.pgm` (a sample PGM image produced by the renderer).

To view or convert the example PGM to PNG (ImageMagick):

```powershell
# convert presult.pgm presult.png
# then open the PNG with your image viewer
```

If you prefer a quick preview on systems with `display` (ImageMagick) or `feh`:

```powershell
# display presult.pgm   # ImageMagick display (Unix-like)
```

## Files intentionally excluded from future commits
Files like `*.exp`, other generated `*.pgm` outputs (except the included example), and personal files are ignored via `.gitignore`.

If you want a PNG preview added to the README or prefer I remove the example PGM from the repo and keep it ignored, tell me and I'll update accordingly.
