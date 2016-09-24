//
//  ReaderBottomView.m
//  XCEpubReader
//
//  Created by pro on 2016/9/24.
//  Copyright © 2016年 daisy. All rights reserved.
//

#import "ReaderBottomView.h"

@implementation ReaderBottomView
- (instancetype)init
{
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI
{
    UILabel *label        = [UILabel new];
    label.textColor       = [ReaderConfig shareInstance].textColor;
    label.textAlignment   = NSTextAlignmentCenter;
    label.font            = [UIFont systemFontOfSize: 14];
    label.backgroundColor = [UIColor clearColor];
    [self addSubview: label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.centerX.equalTo(self.mas_centerX);
        make.width.greaterThanOrEqualTo(@60);
        make.height.equalTo(@14);
    }];
    self.mCurrentChapterlabel = label;
    
    UISlider *slider      = [UISlider new];
    slider.backgroundColor= [UIColor clearColor];
    [self addSubview: slider];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(label.mas_bottom).offset(5);
        make.height.equalTo(@20);
    }];
    self.mSlider          = slider;
    
//    UIButton *
}
@end
