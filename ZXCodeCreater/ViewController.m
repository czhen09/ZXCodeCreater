//
//  ViewController.m
//  ZXCodeCreater
//
//  Created by zx on 17/6/23.
//  Copyright © 2017年 zx. All rights reserved.
//

#import "ViewController.h"
#import "FileManager.h"
#import "FileHandle.h"



#define UserDefaults [NSUserDefaults standardUserDefaults]
NSString *const firstFolderPath = @"firstFolderPath";
NSString *const secondFolderPath = @"secondFolderPath";
NSString *const firstClassPrefix = @"firstClassPrefix";
NSString *const secondClassPrefix = @"secondClassPrefix";
@interface ViewController()<NSTextViewDelegate>


@property (unsafe_unretained) IBOutlet NSTextView *firstModulePathTxv;
@property (weak) IBOutlet NSTextField *firstModuleTxf;
@property (weak) IBOutlet NSTextField *firstReplacedTxf;


@property (unsafe_unretained) IBOutlet NSTextView *secondModulePathTxv;
@property (weak) IBOutlet NSTextField *secondModuleTxf;
@property (weak) IBOutlet NSTextField *secondReplacedTxf;




@property (nonatomic,copy) NSString *firstFolderPathString;
@property (nonatomic,copy) NSString *secondFolderPathString;
@property (nonatomic,copy) NSString *moduleClassPrefix;
@property (nonatomic,copy) NSString *targetClassPrefix;

@end


@implementation ViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    

}


- (void)initData
{
    self.firstFolderPathString = [UserDefaults objectForKey:firstFolderPath];
    self.secondFolderPathString = [UserDefaults objectForKey:secondFolderPath];
    
    NSString *firstClassPrefixString = [UserDefaults objectForKey:firstClassPrefix];
    NSString *secondClassPrefixString = [UserDefaults objectForKey:secondClassPrefix];
    
    
    if (self.firstFolderPathString) {
        
        self.firstModulePathTxv.string =  self.firstFolderPathString;
    }
    if (self.secondFolderPathString) {
        
        self.secondModulePathTxv.string = self.secondFolderPathString;
    }
    
    if (firstClassPrefixString) {
        
        self.firstModuleTxf.stringValue = firstClassPrefixString;
    }
    
    if (secondClassPrefixString) {
        
        self.secondModuleTxf.stringValue = secondClassPrefixString;
    }
    
}


- (IBAction)firstOpenBtnAction:(NSButton *)sender {
    
    [self openPanelWithSenderTag:sender.tag];
}
- (IBAction)firstCreateBtnAction:(id)sender {
    
    
    if (!self.firstModulePathTxv.string||[self.firstModulePathTxv.string isEqualToString:@""]) {
        
        [self showAlertWithMessage:@"Please select first module filePath "];
        return;
    }
    
    if (!self.firstModuleTxf.stringValue||[self.firstModuleTxf.stringValue isEqualToString:@""]) {
        
        [self showAlertWithMessage:@"Please input first mlass prefix "];
        return;
    }
    
    
    if (!self.firstReplacedTxf.stringValue||[self.firstReplacedTxf.stringValue isEqualToString:@""]) {
        
        [self showAlertWithMessage:@"Please input first target class prefix "];
        return;
    }
    
    self.moduleClassPrefix = self.firstModuleTxf.stringValue;
    self.targetClassPrefix = self.firstReplacedTxf.stringValue;
    [self creatFolderAndFileAtModuleFilePath:self.firstFolderPathString];
     [UserDefaults setObject:self.firstModuleTxf.stringValue forKey:firstClassPrefix];
}

- (IBAction)secondOpenBtnAction:(NSButton *)sender {
    
     [self openPanelWithSenderTag:sender.tag];
}

- (IBAction)secondCreateOpenBtnAction:(id)sender {
    if (!self.secondModulePathTxv.string||[self.secondModulePathTxv.string isEqualToString:@""]) {
        
        [self showAlertWithMessage:@"Please select second module filePath "];
        return;
    }
    
    if (!self.secondModuleTxf.stringValue||[self.secondModuleTxf.stringValue isEqualToString:@""]) {
        
        [self showAlertWithMessage:@"Please input second mlass prefix "];
        return;
    }
    
    
    if (!self.secondReplacedTxf.stringValue||[self.secondReplacedTxf.stringValue isEqualToString:@""]) {
        
        [self showAlertWithMessage:@"Please input second target class prefix "];
        return;
    }
    self.moduleClassPrefix = self.secondModuleTxf.stringValue;
    self.targetClassPrefix = self.secondReplacedTxf.stringValue;
    [self creatFolderAndFileAtModuleFilePath:self.secondFolderPathString];
    [UserDefaults setObject:self.secondModuleTxf.stringValue forKey:secondClassPrefix];
}


- (void)openPanelWithSenderTag:(NSUInteger)tag
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setTitle:@"ZXCodeCreater"];
    [panel setCanChooseDirectories:YES];
    [panel setCanCreateDirectories:YES];
    [panel setCanChooseFiles:NO];
    if ([panel runModal] == NSModalResponseOK) {
        
        NSString *tempPathString = [[[panel URLs] objectAtIndex:0] relativePath];
        if (tag==201) {
            
            self.firstFolderPathString = tempPathString;
            self.firstModulePathTxv.string = self.firstFolderPathString;
            [[NSUserDefaults standardUserDefaults] setValue:self.firstFolderPathString  forKey:firstFolderPath];
        }else{
            self.secondFolderPathString = tempPathString;
            self.secondModulePathTxv.string = self.secondFolderPathString;
            [[NSUserDefaults standardUserDefaults] setValue:self.secondFolderPathString  forKey:secondFolderPath];
        }

    }

}

- (void)creatFolderAndFileAtModuleFilePath:(NSString *)filePath
{

    //所有的文件以及文件夹子目录
   NSArray *filePathArr = [[FileManager sharedInstance] getFilePathArrWithPath:filePath];
    for (NSString *subPath in filePathArr) {
        NSString * wholePath = [filePath stringByAppendingPathComponent:subPath];
        NSString *newWholePath = [wholePath stringByReplacingOccurrencesOfString:self.moduleClassPrefix withString:self.targetClassPrefix];
        //忽略隐藏文件
        if ([subPath containsString:@".DS_Store"]) {
            
            continue;
        }
        //文件夹路径;如果是文件夹的话，就创建文件夹
        if (![subPath containsString:@"/"]) {
        
            [[FileManager sharedInstance] createFolderAtPath:newWholePath];
            continue;
        }
        NSString *str =  [[FileManager sharedInstance] getStringWithContentsOfFilePath:wholePath];
        NSString *replacedStr = [str stringByReplacingOccurrencesOfString:self.moduleClassPrefix withString:self.targetClassPrefix];
        [[FileManager sharedInstance] createFileAtPath:newWholePath content:replacedStr];
    }
    [[NSWorkspace sharedWorkspace] openFile:filePath];

}

- (void)showAlertWithMessage:(NSString *)message{
    
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:message];
    [alert runModal];
}

#pragma mark - Getter && Setter


@end
