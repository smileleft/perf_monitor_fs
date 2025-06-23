#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>

#define FILE_NAME "test_file.txt"
#define TEST_DATA "Hello, perf for filesystem monitoring!\n"
#define BUFFER_SIZE 1024

int main() {
    int fd;
    ssize_t bytes_written, bytes_read;
    char buffer[BUFFER_SIZE];

    printf("Starting file operations...\n");

    // 1. 파일 생성 및 열기 (쓰기 모드)
    fd = open(FILE_NAME, O_CREAT | O_WRONLY | O_TRUNC, 0644);
    if (fd == -1) {
        perror("Error opening file");
        return 1;
    }
    printf("File '%s' created and opened for writing.\n", FILE_NAME);

    // 2. 파일에 데이터 쓰기
    bytes_written = write(fd, TEST_DATA, strlen(TEST_DATA));
    if (bytes_written == -1) {
        perror("Error writing to file");
        close(fd);
        return 1;
    }
    printf("Wrote %zd bytes to '%s'.\n", bytes_written, FILE_NAME);
    close(fd);

    // 3. 파일 열기 (읽기 모드)
    fd = open(FILE_NAME, O_RDONLY);
    if (fd == -1) {
        perror("Error opening file for reading");
        return 1;
    }
    printf("File '%s' opened for reading.\n", FILE_NAME);

    // 4. 파일에서 데이터 읽기
    bytes_read = read(fd, buffer, BUFFER_SIZE - 1);
    if (bytes_read == -1) {
        perror("Error reading from file");
        close(fd);
        return 1;
    }
    buffer[bytes_read] = '\0'; // Null-terminate the buffer
    printf("Read %zd bytes from '%s': '%s'\n", bytes_read, FILE_NAME, buffer);
    close(fd);

    // 5. 파일 삭제
    if (unlink(FILE_NAME) == -1) {
        perror("Error deleting file");
        return 1;
    }
    printf("File '%s' deleted.\n", FILE_NAME);

    printf("File operations completed.\n");

    return 0;
}
