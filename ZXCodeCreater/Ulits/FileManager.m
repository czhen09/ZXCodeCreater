//
//  FileManager.m
//  ESJsonFormatForMac
//
//  Created by zx on 17/6/13.
//  Copyright © 2017年 ZX. All rights reserved.
//

#import "FileManager.h"
@interface FileManager()
@property (nonatomic,strong) NSFileManager *fileManager;
@end


@implementation FileManager

+ (FileManager *)sharedInstance
{
    static FileManager *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (void)createFileAtFilePath:(NSString *)filePath
                        fileName:(NSString *)fileName
                       hContent :(NSString *)hContent
                       mContent :(NSString *)mContent

{
    //创建.h文件
    [self createFileAtPath:[filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.h",fileName]] content:hContent];
    if (![fileName containsString:@"Keys"]) {
        //创建.m文件
        [self createFileAtPath:[filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m",fileName]] content:mContent];
    }
    
}

- (void)createFolderAtPath:(NSString *)folder{
    
    [self.fileManager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
}


- (void)createFileAtPath:(NSString *)FilePath content:(NSString *)content{

    
    [self.fileManager createFileAtPath:FilePath contents:[content dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
}

- (NSString *)getStringWithContentsOfFilePath:(NSString *)filePath{

    NSData *reader = [NSData dataWithContentsOfFile:filePath];
    NSString *content = [[NSString alloc] initWithData:reader                                  encoding:NSUTF8StringEncoding];
    return content;

}


- (NSArray *)getFilePathArrWithPath:(NSString *)dirPath
{
    
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSMutableArray *fileArr = [NSMutableArray array];
    NSDirectoryEnumerator *myDirectoryEnumerator;
    myDirectoryEnumerator=[fileManager enumeratorAtPath:dirPath];
    //列举目录内容，可以遍历子目录
    NSLog(@"用enumeratorAtPath:显示目录%@的内容：",dirPath);
    
    while((dirPath=[myDirectoryEnumerator nextObject])!=nil)
        
    {
        [fileArr addObject:dirPath];
        NSLog(@"%@",dirPath);
        
    }

    return [fileArr copy];
}




- (NSFileManager *)fileManager
{
    if (!_fileManager) {
        
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}
@end
