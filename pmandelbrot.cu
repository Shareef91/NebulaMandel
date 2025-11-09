#include <cuda.h>
#include <stdio.h>
#include "image.h"

__device__ int mandelbrot(float cx, float cy) {
    int count = 0;
    int max_iterations = 32;
    float zx = 0.0;
    float zy = 0.0;
    float temp = 0.0;
    float lengthsquared = 0.0;
    do {
        temp = zx * zx - zy * zy + cx;
        zy = 2 * zx * zy + cy;
        zx = temp;
        lengthsquared = zx * zx + zy * zy;
        count++;
    } while ((lengthsquared < 4.0) && (count < max_iterations));
    return count - 1;
}

__global__ void mandelbrot_kernel(unsigned char *pixel, int width, int height) {
        //Computing the pixel coordinates within the 2-D image//
        int col = blockIdx.x * blockDim.x + threadIdx.x; //x
        int row = blockIdx.y * blockDim.y + threadIdx.y; // y

        // Some threads may be out-of-bounds when width/height aren't multiples of block size //
        if (col >= width || row >= height) return;

        // Map (col,row) to a complex plane://
        // real in [-2.5, 1.0], imag in [-1.0, 1.0]//
        float cx = -2.5f + (3.5f * (float)col) / (float)width;
        float cy = -1.0f + (2.0f * (float)row) / (float)height;

        int iters = mandelbrot(cx, cy);
        pixel[row * width + col] = (unsigned char)iters; // write result to global memory //
}


void process_data(image *photo) {
    if (!photo || !photo->data) {
        fprintf(stderr, "Invalid image data\n");
        return;
    }

        /* Extract image properties                        */
        const int width = (int)photo->width;
        const int height = (int)photo->height;
        const size_t nbytes =(size_t)width * (size_t)height * sizeof(unsigned char);
        /* Declare variables for grid and block dimensions */
        dim3 block(16, 16);
        dim3 grid( ( width + block.x - 1) / block.x,
                   ( height + block.y - 1) / block.y );
        /* Declare device memory                           */
        unsigned char *d_pixel = nullptr;
        cudaError_t err = cudaMalloc((void**)&d_pixel, nbytes);
        if (err != cudaSuccess) {
            fprintf(stderr, "cudaMalloc failed: %s\n", cudaGetErrorString(err));
            return;
        }
        /* Allocate device memory                          */
        err = cudaMemset(d_pixel, 0, nbytes);
        if (err != cudaSuccess) {
            fprintf(stderr, "cudaMemset failed: %s\n", cudaGetErrorString(err));
            cudaFree(d_pixel);
            return;
        }
        // Launch kernel to compute Mandelbrot set //
        mandelbrot_kernel<<<grid, block>>>(d_pixel, width, height);

        // Check for kernel launch errors //
        err = cudaGetLastError();
        if (err != cudaSuccess) {
            fprintf(stderr, "Kernel launch failed: %s\n", cudaGetErrorString(err));
            cudaFree(d_pixel);
            return;
        }
        // Synchronize threads before copying data back to host //
        err = cudaDeviceSynchronize();
        if (err != cudaSuccess) {
            fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching the kernel!\n", err);
            cudaFree(d_pixel);
            return;
        }

        // Copy result from device to host image data //
        err = cudaMemcpy(photo->data, d_pixel, nbytes, cudaMemcpyDeviceToHost);
        if (err != cudaSuccess) {
            fprintf(stderr, "cudaMemcpy failed: %s\n", cudaGetErrorString(err));
            cudaFree(d_pixel);
            return;
        }
        /* Free device memory*/
        cudaFree(d_pixel);
}

image *setup(int argc, char **argv) {
    if (argc < 3) {
        fprintf(stderr, "Usage: %s <outfile> <size>\n\n", argv[0]);
        return NULL;
    }

    int size = atoi(argv[2]);
    return create_image(size, size, 31);
}

void cleanup(image *photo, char **argv) {
    int rc = write_image(argv[1], photo);
    if (!rc) {
        fprintf(stderr, "Unable to write output file %s\n\n", argv[1]);
    }

    clear_image(photo);
}

int main(int argc, char **argv) {
    image *photo = setup(argc, argv);
    process_data(photo);
    cleanup(photo, argv);
    return 0;
}
/*
=============================================================
AI USE REPORT
=============================================================

Date: October 19, 2025
Service: ChatGPT (OpenAI GPT-5)

Prompts Used:
1. "Help me fix errors in my CUDA Mandelbrot program."
2. "Explain CUDA compile and run commands on Windows (nvcc)."

Responses Generated:
ChatGPT helped identify and correct a bounds-checking error
(if (col >= width || row >= height) return;),
and explained how to compile and run CUDA programs using
`nvcc -O2 -o pmandelbrot.exe pmandelbrot.cu image.cu`
and `pmandelbrot.exe presult.pgm 512`.

Parts of Response Used:
Only the corrected bounds check line and compile/run command syntax.
All other code and logic were written by me.

=============================================================
*/
