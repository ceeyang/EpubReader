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

#import "ReaderPageViewController.h"
#import "Masonry.h"
#import "EpubBookModel.h"
#import "EpubChapterModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"EpubReader";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *btnTitleArr = @[@"Open EpubReader",@"Page view test"];
    NSMutableArray *btnArr = [NSMutableArray array];
    for (int i = 0; i < btnTitleArr.count; i++) {
        UIButton *btn         = [[UIButton alloc] init];
        [btn setBackgroundColor: [UIColor lightGrayColor]];
        [btn setTag: i];
        [btn setTitle: btnTitleArr[i] forState:UIControlStateNormal];
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius  = 5.0f;
        btn.layer.borderWidth   = 1;
        btn.layer.borderColor   = [UIColor blueColor].CGColor;
        [btn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: btn];
        [btnArr addObject: btn];
        
        if (i == 1) {
            btn.hidden = true;
        }
    }
    
    [btnArr mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedItemLength:44 leadSpacing:164 tailSpacing:100];
    [btnArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_greaterThanOrEqualTo(@100);
    }];
    
}

- (void)btnClickAction:(UIButton *)sender
{
    if (sender.tag == 0) {
        
        EpubMainViewController *reader          = [EpubMainViewController new];
        reader.filePath                         = [[NSBundle mainBundle] pathForResource:@"GreatWorld" ofType:@"epub"];
        [ReaderConfig shareInstance].themeStyle = ProtectEyes;
        [ReaderConfig shareInstance].urlEnable  = true;
        [self presentViewController:reader animated:true completion:nil];
        
    } else if (sender.tag == 1) {
        
        ReaderPageViewController *reader        = [ReaderPageViewController new];
        reader.filePath                         = [[NSBundle mainBundle] pathForResource:@"四大名捕系列" ofType:@"epub"];
        [ReaderConfig shareInstance].textSize   = 100;
        [ReaderConfig shareInstance].textColor  = [UIColor whiteColor];
        [ReaderConfig shareInstance].themeColor = [UIColor lightGrayColor];

        [self presentViewController:reader animated:true completion:nil];
        
    } else {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
