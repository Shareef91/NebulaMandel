#include <stdio.h>
#include "image.h"

image *create_image(int width, int height, int maxValue) {
    image *photo = (image *) malloc(sizeof (image));
    photo -> width = width;
    photo -> height = height;
    photo -> max_value = maxValue;
    photo -> data = (unsigned char *) malloc(width * height);
    return photo;
}

image *read_image(const char *filename) {
    image *photo = NULL;
    int width, height, max_value, n;
    char magic[3];
    unsigned char dummy;

    FILE *file = fopen(filename, "r");
    if (file == NULL) {
        return NULL;
    }

    fscanf(file, "%s", magic);
    if (strcmp(magic, "P5") != 0) {
        fclose(file);
        return NULL;
    }

    fscanf(file, "%ud", &width);
    fscanf(file, "%ud", &height);
    fscanf(file, "%ud", &max_value);

    n = width * height;

    photo = (image *) malloc(sizeof (image));
    if (photo == NULL) {
        fclose(file);
        return NULL;
    }

    photo->width = width;
    photo->height = height;
    photo->max_value = max_value;

    photo->data = (unsigned char *) malloc(n);

    if (photo->data == NULL) {
        free(photo);
        fclose(file);
        return NULL;
    }

    fread(&dummy, 1, 1, file); /* read the required white space */
    fread(photo->data, n, 1, file);
    return photo;
}

int write_image(const char *filename, image *photo) {
    FILE *file = fopen(filename, "w");
    int length = photo->width * photo->height;
    unsigned char *p = photo->data;
    int i;

    if (file == NULL) {
        return FALSE;
    }

    fprintf(file, "P5\n");
    fprintf(file, "%u %u\n", photo->width, photo->height);
    fprintf(file, "%u\n", photo->max_value);

    for (i = 0; i < length; i++) {
        putc(*p, file);
        p++;
    }

    fclose(file);
    return TRUE;
}

void clear_image(image *photo) {
    free(photo -> data);
    free(photo);
}

