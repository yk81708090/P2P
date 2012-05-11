//
//  DownloadEntry.m
//  P2P
//
//  Created by Incomedia on 11/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DownloadEntry.h"

@implementation DownloadEntry

@synthesize name;
@synthesize filePath;
@synthesize ownerIP;
@synthesize progress;
@synthesize speed;
@synthesize total;


+(DownloadEntry*)newDownloadEntryWithName:(NSString*)name withPath:(NSString *)fPath withTotalSize:(int)size  withIP:(NSString*)ip{
    
    DownloadEntry *entry = [DownloadEntry new];
    
    entry.name = name;
    entry.filePath = fPath;
    entry.ownerIP =ip;
    entry.progress = 0;
    entry.speed = 0;
    entry.total = size;
    
    return entry;
}

@end
