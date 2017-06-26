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
    
    self.firstFolderPathString = self.firstModulePathTxv.string;
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
    
    
    self.secondFolderPathString = self.secondModulePathTxv.string;
    
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
        //直接修改路径，然后根据路径新建文件夹及其文件，也就相当于修改文件及其文件夹名称；
        NSString *newWholePath = [wholePath stringByReplacingOccurrencesOfString:self.moduleClassPrefix withString:self.targetClassPrefix];
        //忽略隐藏文件
        if ([subPath containsString:@".DS_Store"]) {
            
            continue;
        }
        //文件夹路径;如果是文件夹的话，就创建文件夹(如果后缀是.h或者.m的话，那么就是文件，否则是文件夹)
        if (!([subPath containsString:@".h"]||[subPath containsString:@".m"])) {
        
            [[FileManager sharedInstance] createFolderAtPath:newWholePath];
            continue;
        }
        NSString *str =  [[FileManager sharedInstance] getStringWithContentsOfFilePath:wholePath];
        //将文件中的字段替换成目标字段
        NSString *replacedStr = [str stringByReplacingOccurrencesOfString:self.moduleClassPrefix withString:self.targetClassPrefix];
        //修改文件顶部注释的模板文件中的日期；
        NSString *stringAfterReplaceDate =  [self replaceModuleDateWithNowDate:[self getNowDateStr] nowYear:[self getNowYearStr] moduleStr:replacedStr];
        //创建文件
        [[FileManager sharedInstance] createFileAtPath:newWholePath content:stringAfterReplaceDate];
    }
    [[NSWorkspace sharedWorkspace] openFile:filePath];
}



#pragma mark - ReplaceDate
- (NSString *)replaceModuleDateWithNowDate:(NSString *)nowDate nowYear:(NSString *)nowYear moduleStr:(NSString *)moduleStr{
    
    NSMutableString *searchText = [NSMutableString stringWithFormat:@"%@",moduleStr];
    NSError *error = NULL;
    //匹配17/06/25
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]{1,2}/[0-9]{1,2}/[0-9]{1,2}" options:NSRegularExpressionCaseInsensitive error:&error];
    //匹配2017年;
    NSRegularExpression *regexT = [NSRegularExpression regularExpressionWithPattern:@"[0-9]{1}[0-9]{1}[0-9]{1}[0-9]{1}[\u4e00-\u9fa5]" options:NSRegularExpressionCaseInsensitive error:&error];
    [regex replaceMatchesInString:searchText options:0 range:NSMakeRange(0, searchText.length) withTemplate:nowDate];
    [regexT replaceMatchesInString:searchText options:0 range:NSMakeRange(0, searchText.length) withTemplate:nowYear];
    return searchText;
}

- (NSString *)getNowDateStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yy/MM/dd";
    return [formatter stringFromDate:[NSDate date]];
}

- (NSString *)getNowYearStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy";
    
    NSString *nowYear = [NSString stringWithFormat:@"%@年",[formatter stringFromDate:[NSDate date]]];
    
    return nowYear;
}


- (void)showAlertWithMessage:(NSString *)message{
    
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:message];
    [alert runModal];
}

@end
