#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>

// Run a process as singleton. Uses loopback sockets for locking instead of files.
    
int main (int argc, char** argv) {
    if(argc < 3) {fprintf(stderr,"USAGE: solo LOCKPORT COMMAND...\n");return 4;}
    int sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) { perror("socket"); return 3; }
    uint32_t uid = getuid();
    struct sockaddr_in addr; // bind to user id as lo ip and specified port
    addr.sin_family = AF_INET;
    addr.sin_port = htons(atoi(argv[1])); // first argument is the port to use
    addr.sin_addr.s_addr = ( // transform uid bytes X.C.B.A to ip 127.B.A.(C&0xef)
            (127            << 24) 
          | ((uid & 0xFFFF ) << 8) 
          | ((uid >> 16) & 0xEF ));
    if (bind(sockfd, (struct sockaddr *) &addr, sizeof(addr)) == -1) {
        return 2; // probably locked, another solo running
    } else execvp(argv[2],argv+2); // run the singleton
}
