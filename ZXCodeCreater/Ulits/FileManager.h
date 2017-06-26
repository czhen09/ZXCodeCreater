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
/**创建文件夹*/
- (void)createFolderAtPath:(NSString *)folder;
/**创建文件*/
- (void)createFileAtPath:(NSString *)FilePath content:(NSString *)content;
/**获取文件内容*/
- (NSString *)getStringWithContentsOfFilePath:(NSString *)filePath;
/**根据目录遍历文件夹*/
- (NSArray *)getFilePathArrWithPath:(NSString *)dirPath;
@end
