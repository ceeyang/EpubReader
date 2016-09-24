//
//  ViewController.m
//  XCEpubReader
//
//  Created by pro on 2016/9/23.
//  Copyright © 2016年 daisy. All rights reserved.
//

#import "ViewController.h"
#import "ReaderConfig.h"
#import "EpubMainViewController.h"

#import "EpubBookModel.h"
#import "EpubChapterModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *readBtn         = [[UIButton alloc] initWithFrame:CGRectMake(50, 200, 50, 50)];
    readBtn.backgroundColor   = [UIColor lightGrayColor];
    [readBtn setTitle:@"Read" forState:UIControlStateNormal];
    [readBtn addTarget:self action:@selector(readerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: readBtn];
    
    UIButton *timeBtn         = [[UIButton alloc] initWithFrame:CGRectMake(110, 200, 50, 50)];
    timeBtn.backgroundColor   = [UIColor lightGrayColor];
    [timeBtn setTitle:@"Time" forState:UIControlStateNormal];
    [timeBtn addTarget:self action:@selector(timeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: timeBtn];
    
    UIButton *localBtn         = [[UIButton alloc] initWithFrame:CGRectMake(170, 200, 50, 50)];
    localBtn.backgroundColor   = [UIColor lightGrayColor];
    [localBtn setTitle:@"Local" forState:UIControlStateNormal];
    [localBtn addTarget:self action:@selector(localBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: localBtn];
    
}

- (void)readerBtnClick
{
    EpubMainViewController *reader          = [EpubMainViewController new];
    reader.filePath                         = [[NSBundle mainBundle] pathForResource:@"四大名捕系列" ofType:@"epub"];
    [ReaderConfig shareInstance].textSize   = 100;
    [ReaderConfig shareInstance].textColor  = [UIColor whiteColor];
    [ReaderConfig shareInstance].themeColor = [UIColor lightGrayColor];
    [self presentViewController:reader animated:true completion:nil];
}

- (void)timeBtnAction
{
//    EpubBookModel *model = [EpubBookModel getLocalModelWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"四大名捕系列" ofType:@"epub"]] local: false];
//    EpubChapterModel *chapter = model.spineArray.firstObject;
//    NSLog(@"time path :\n%@",chapter.spinePath);
    
    NSString *lastPath = kUserDocuments.lastPathComponent;
    NSInteger length   = kUserDocuments.length - (lastPath.length+1);
    NSLog(@"%@",kUserDocuments);
    NSLog(@"%@",[kUserDocuments substringToIndex:length]);
}

- (void)localBtnClick
{
    NSString *userDir = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@",userDir);
//    EpubBookModel *model = [EpubBookModel getLocalModelWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"四大名捕系列" ofType:@"epub"]]local: true];
//    EpubChapterModel *chapter = model.spineArray.firstObject;
//    NSLog(@"local path :\n%@",chapter.spinePath);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
