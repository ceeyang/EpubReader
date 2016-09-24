//
//  ReaderTopView.m
//  XCEpubReader
//
//  Created by pro on 2016/9/23.
//  Copyright © 2016年 daisy. All rights reserved.
//

#import "ReaderTopView.h"

@interface ReaderTopView()
@property (nonatomic, strong) UILabel * mTitleLabel;
@property (nonatomic, copy) ButtonActionBlock  backBtnActionBlock;
@property (nonatomic, copy) ButtonActionBlock  moreBtnActionBlock;
@end

@implementation ReaderTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    CGFloat statusBarHeight = 20;
    self.backgroundColor    = [ReaderConfig shareInstance].themeColor;
    
    UIButton *backBtn = [UIButton new];
    [backBtn setImage:[UIImage imageNamed:@"new_head_arrow_left"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"new_head_arrow_left_pre"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview: backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top).offset(statusBarHeight);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    self.mBackBtn         = backBtn;
    
    UILabel *label        = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor       = [ReaderConfig shareInstance].textColor;
    label.font            = [UIFont systemFontOfSize:17];
    label.textAlignment   = NSTextAlignmentCenter;
    [self addSubview: label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.greaterThanOrEqualTo(@100);
        make.height.equalTo(@44);
        make.top.equalTo(self.mas_top).offset(statusBarHeight);
    }];
    self.mTitleLabel      = label;
    
    UIButton *rightBtn    = [UIButton new];
    [rightBtn setImage:[UIImage imageNamed:@"new_head_more"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"new_head_more_pre"] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(rightBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview: rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self.mas_top).offset(statusBarHeight);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    self.mRightBtn        = rightBtn;
    
}

- (void)setTitle:(NSString *)title
{
    if (self.mTitleLabel) {
        self.mTitleLabel.text = title;
    }
}

- (void)backBtnClickAction:(UIButton *)sender
{
    if (self.backBtnActionBlock) {
        self.backBtnActionBlock(sender);
    }
}

- (void)rightBtnClickAction:(UIButton *)sender
{
    if (self.moreBtnActionBlock) {
        self.moreBtnActionBlock(sender);
    }
}

- (void)setBlockBackBtnAction:(void (^)(UIButton *))block
{
    self.backBtnActionBlock = block;
}

- (void)setBlockMoreBtnAction:(void (^)(UIButton *))block
{
    self.moreBtnActionBlock = block;
}
@end
