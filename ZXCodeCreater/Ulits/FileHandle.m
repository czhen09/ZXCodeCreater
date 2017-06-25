//
//  FileHandle.m
//  ZXCodeCreater
//
//  Created by zx on 17/6/25.
//  Copyright © 2017年 zx. All rights reserved.
//

#import "FileHandle.h"
@interface FileHandle()
@property (nonatomic,strong) NSFileHandle *fileHandler;
@end

@implementation FileHandle
+ (instancetype)shareInstance
{
    static FileHandle *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[FileHandle alloc] init];
    });
    return shareInstance;
}


- (void)clearFileContentWithFilePath:(NSString *)filePath
{
   
    self.fileHandler = [NSFileHandle fileHandleForWritingAtPath:filePath];
    [self.fileHandler truncateFileAtOffset:0];
}

- (void)writeContentToFileWithFilePath:(NSString *)filePath content:(NSString *)content
{
    self.fileHandler = [NSFileHandle fileHandleForWritingAtPath:filePath];
    [self.fileHandler writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
}

@end
