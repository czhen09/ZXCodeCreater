//
//  FileManager.h
//  ESJsonFormatForMac
//
//  Created by zx on 17/6/13.
//  Copyright © 2017年 ZX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject
+ (FileManager *)sharedInstance;
- (void)createFolderAtPath:(NSString *)folder;
- (void)createFileAtPath:(NSString *)FilePath content:(NSString *)content;
- (NSString *)getStringWithContentsOfFilePath:(NSString *)filePath;
- (NSArray *)getFilePathArrWithPath:(NSString *)dirPath;
@end
