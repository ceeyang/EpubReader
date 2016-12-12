//
//  MainView.m
//  XCEpubReader
//
//  Created by pro on 2016/9/27.
//  Copyright © 2016年 daisy. All rights reserved.
//

#import "MainViewController.h"


@interface MainViewController()<UIWebViewDelegate>

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [self setupUI];
}

- (void)setupUI
{
    /** main web view */
    ReaderMainView *mainView = [ReaderMainView new];
    [self.view addSubview: mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.mainView            = mainView;
}

- (void)loadChapter:(EpubChapterModel *)chapter
{
    [self.mainView loadChapter: chapter];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"%@ : %s",[self class],__func__);
}

- (void)dealloc
{
    NSLog(@"%@ Dealloc Success",[self class]);
}

@end
