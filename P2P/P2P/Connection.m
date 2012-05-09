//
//  Connection.m
//  P2P
//
//  Created by Incomedia on 06/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Connection.h"

#import <stdio.h>
#import <stdlib.h>
#import <sys/socket.h>
#import <netinet/in.h> //internet domain stuff
#import <netdb.h> //server info

@implementation Connection

+ (void)qNetworkAdditions_getStreamsToHostNamed:(NSString *)hostName
                                           port:(NSInteger)port
                                    inputStream:(out NSInputStream **)inputStreamPtr
                                   outputStream:(out NSOutputStream **)outputStreamPtr
{
    CFReadStreamRef     readStream;
    CFWriteStreamRef    writeStream;
    
    assert(hostName != nil);
    assert( (port > 0) && (port < 65536) );
    assert( (inputStreamPtr != NULL) || (outputStreamPtr != NULL) );
    
    readStream = NULL;
    writeStream = NULL;
    
    CFStreamCreatePairWithSocketToHost(
                                       NULL,
                                       (__bridge CFStringRef) hostName,
                                       port,
                                       ((inputStreamPtr  != NULL) ? &readStream : NULL),
                                       ((outputStreamPtr != NULL) ? &writeStream : NULL)
                                       );
    
    if (inputStreamPtr != NULL) {
        *inputStreamPtr  = CFBridgingRelease(readStream);
    }
    if (outputStreamPtr != NULL) {
        *outputStreamPtr = CFBridgingRelease(writeStream);
    }
    
}



#pragma mark -
#pragma mark socket functions

+(NSString*)readNSStringFromSocket:(int)socket {
    
    uint8_t tmp = 0;
    uint8_t buff[1024];
    
    int count = 0;
    int err = 0;
    
    while (tmp != '\n'){
        if ((err = read(socket, &tmp, 1)) > 0){
            buff[count++] = tmp;
        }
    }
    buff[count-1]='\0';
    
    return [NSString stringWithCString:(char*)buff encoding:NSStringEncodingConversionAllowLossy];
    
}

+(NSString*)readNSStringFromInputStream:(NSInputStream*)inputStream {
    
    uint8_t tmp = 0;
    uint8_t buff[1024];
    
    int count = 0;
    
    while (tmp != '\n'){
        if ([inputStream read:&tmp maxLength:1] > 0){
            buff[count++] = tmp;
        }
    }
    buff[count-1]='\0';
    
    return [NSString stringWithCString:(char*)buff encoding:NSStringEncodingConversionAllowLossy];
    
}

+(void)sendNSString:(NSString*)string toSocket:(int)socket {
    
    uint8_t buff[1024];
    [string getCString:(char*)&buff[0] maxLength:1024 encoding:NSStringEncodingConversionAllowLossy];
    write(socket, &buff, [string length]);
    
}


+(void)sendNSString:(NSString*)string toOutputStream:(NSOutputStream*)OutputStream {
    
    uint8_t buff[1024];
    [string getCString:(char*)&buff[0] maxLength:1024 encoding:NSStringEncodingConversionAllowLossy];
    [OutputStream write:&buff[0] maxLength:[string length]];
    
}


+(NSString*)socketIPToNSString:(int)socket {
    
    uint32_t len;
    struct sockaddr_in sin;
    
    len = sizeof(sin);
    
    if (0 != getpeername(socket,(struct sockaddr*) &sin, (socklen_t*)&len)) printf("caca");
    uint32_t ip = sin.sin_addr.s_addr;
    
    return [NSString stringWithFormat:@"%d.%d.%d.%d",
            (ip&0x000000FF),
            ((ip>>8)&0x0000FF),
            ((ip>>16)&0x00FF),
            ((ip>>24))];
    
    
    
}

+(NSString*)intIPToNSString:(int)ip {
    
    return [NSString stringWithFormat:@"%d.%d.%d.%d",
            (ip&0x000000FF),
            ((ip>>8)&0x0000FF),
            ((ip>>16)&0x00FF),
            ((ip>>24))];
}

+(unsigned int)getIPIntFromString:(NSString*)ipStr{
    
    
    NSArray *parts = [ipStr componentsSeparatedByString:@"."];
    
    unsigned int ip = 
    ([[parts objectAtIndex:3] intValue] << 24)
    + ([[parts objectAtIndex:2] intValue] << 16)
    + ([[parts objectAtIndex:1] intValue] << 8)
    + [[parts objectAtIndex:0] intValue];
    
    return ip;
    
}

+(NSString*)getLocalIp {
    
    
    
    NSArray *addresses = [[NSHost currentHost] addresses];
    NSString *stringAddress;
    for (NSString *anAddress in addresses) {
        if (![anAddress hasPrefix:@"127"] && [[anAddress componentsSeparatedByString:@"."] count] == 4) {
            stringAddress = anAddress;
            break;
        }
    }
    
    return  stringAddress;
    
}






@end
