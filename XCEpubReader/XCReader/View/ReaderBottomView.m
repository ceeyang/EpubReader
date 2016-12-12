//
//  ReaderBottomView.m
//  XCEpubReader
//
//  Created by pro on 2016/9/24.
//  Copyright © 2016年 daisy. All rights reserved.
//

#import "ReaderBottomView.h"

@interface ReaderBottomView()
@property (nonatomic, copy) ButtonActionBlock  bottomBtnClickActionBlock;
@property (nonatomic, strong) UILabel * currentChapterLabel;
@property (nonatomic, strong) SliderValueChangeBlock sliderValueChangeBlock;
@end

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
    self.backgroundColor   = [ReaderConfig shareInstance].themeColor;
    
    NSArray *btnTitleArr   = @[@"A-",@"A+",@"Last",@"Next",@"Daily",@"Night"];
    NSMutableArray *btnArr = [NSMutableArray array];
    for (int i = 0; i < btnTitleArr.count; i++) {
        UIButton *btn = [UIButton new];
        [btn setTitle:btnTitleArr[i] forState:UIControlStateNormal];
        [btn setBackgroundColor: [UIColor lightGrayColor]];
        [btn setTag: i];
        [btn addTarget:self action:@selector(bottomBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: btn];
        [btnArr addObject: btn];
    }
    [btnArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:5 leadSpacing:10 tailSpacing:10];
    [btnArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.height.equalTo(@44);
    }];
    
    UISlider *slider      = [UISlider new];
    slider.backgroundColor= [UIColor clearColor];
    slider.maximumValue   = 1.0f;
    slider.minimumValue   = 0.0f;
    [slider addTarget:self action:@selector(sliderClickAction:) forControlEvents:UIControlEventValueChanged];
    [self addSubview: slider];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.bottom.equalTo(self.mas_bottom).offset(-54);
        make.height.equalTo(@20);
    }];
    self.pageSlider       = slider;
    
    UILabel *label        = [UILabel new];
    label.textColor       = [ReaderConfig shareInstance].textColor;
    label.textAlignment   = NSTextAlignmentCenter;
    label.font            = [UIFont systemFontOfSize: 14];
    label.backgroundColor = [UIColor clearColor];
    label.text            = @"章节";
    [self addSubview: label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(slider.mas_top).offset(-10);
        make.centerX.equalTo(self.mas_centerX);
        make.width.greaterThanOrEqualTo(@60);
        make.height.equalTo(@14);
    }];
    self.currentChapterLabel = label;
}

- (void)bottomBtnClickAction:(UIButton *)sender
{
    if (self.bottomBtnClickActionBlock) {
        self.bottomBtnClickActionBlock(sender);
    }
}

- (void)sliderClickAction:(UISlider *)slider
{
    if (self.sliderValueChangeBlock) {
        self.sliderValueChangeBlock(slider.value);
    }
}

- (void)setBlockBottomBtnAction:(void (^)(UIButton *))block
{
    self.bottomBtnClickActionBlock = block;
}

- (void)setMCurrentChapter:(NSString *)mCurrentChapter
{
    self.currentChapterLabel.text = mCurrentChapter;
}

- (void)setBlockSliderValueChangeAction:(void (^)(CGFloat))block
{
    self.sliderValueChangeBlock = block;
}

@end
