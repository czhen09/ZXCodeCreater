//
//  FileHandle.h
//  ZXCodeCreater
//
//  Created by zx on 17/6/25.
//  Copyright © 2017年 zx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileHandle : NSObject
+ (instancetype)shareInstance;
- (void)clearFileContentWithFilePath:(NSString *)filePath;
- (void)writeContentToFileWithFilePath:(NSString *)filePath content:(NSString *)content;
@end
