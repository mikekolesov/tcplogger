//
//  main.c
//  logserver
//
//  Created by MKolesov on 31/07/2017.
//  Copyright © 2017 Mikhail Kolesov. All rights reserved.
//

#include<stdio.h> //printf
#include<string.h>    //strlen
#include<sys/socket.h>    //socket
#include<arpa/inet.h> //inet_addr
#include<unistd.h>    //write

#define PORT 7771

void launchLogServer() {
 
        int socket_desc , client_sock , c , read_size;
        struct sockaddr_in server , client;
        char client_message[2000];
        
        //Create socket
        socket_desc = socket(AF_INET , SOCK_STREAM , 0);
        if (socket_desc == -1)
        {
            printf("Could not create socket");
        }
#ifdef __APPLE__
        int     kOne = 1;
        setsockopt(socket_desc, SOL_SOCKET, SO_NOSIGPIPE, &kOne, sizeof(kOne));
#endif
        puts("Socket created");
        
        //Prepare the sockaddr_in structure
        server.sin_family = AF_INET;
        server.sin_addr.s_addr = INADDR_ANY;
        server.sin_port = htons( PORT );
        
        //Bind
        if(bind(socket_desc,(struct sockaddr *)&server , sizeof(server))  < 0)
        {
            //print the error message
            perror("bind failed. Error");
            return;
        }
        puts("bind done");
        
        //Listen
        listen(socket_desc , 3);
        
    
    
    while (1) {
        //Accept and incoming connection
        puts("Waiting for a new connection...");
        c = sizeof(struct sockaddr_in);
        
        //accept connection from an incoming client
        client_sock = accept(socket_desc, (struct sockaddr *)&client, (socklen_t*)&c);
        if (client_sock < 0)
        {
            perror("accept failed");
            return;
        }
        #ifdef __APPLE__
        setsockopt(client_sock, SOL_SOCKET, SO_NOSIGPIPE, &kOne, sizeof(kOne));
        #endif
        puts("Connection accepted");
        
        //Receive a message from client
        while( 1 )
        {
            memset(client_message, '\0', 2000);
            read_size = (int)recv(client_sock , client_message , 2000 , 0);
            
            if (read_size > 0) {
                printf("%s\n", client_message);
            } else if (read_size == 0) {
                printf("looks like client is dead\n");
                break;
            } else {
                // < 0
                perror("recv failed");
            }
        }
    }

}


int main(int argc, const char * argv[]) {
    printf("Launching log server..\n");
    launchLogServer();
    return 0;
}

