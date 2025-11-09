#include <stdio.h>
#include "image.h"

int mandelbrot(float cx, float cy) {
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

void process_data(image *photo) {
    int i;
    int j;
    int width = photo -> width;
    int height = photo -> height;
    int index = 0;
    float cx;
    float cy;

    for (i = 0; i < height; i++) {
        for (j = 0; j < width; j++) {
            cx = 4.0 * (j + 0.5) / width - 2.0;
            cy = 4.0 * (i + 0.5) / height - 2.0;
            photo->data[index] = mandelbrot(cx, cy);
            index++;
        }
    }
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
