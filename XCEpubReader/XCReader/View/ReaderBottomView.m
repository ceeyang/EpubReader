//
//  ReaderBottomView.m
//  XCEpubReader
//
//  Created by pro on 2016/9/24.
//  Copyright © 2016年 daisy. All rights reserved.
//

#import "ReaderBottomView.h"
#import "XCReaderConst.h"
#import "ReaderConfig.h"

@interface ReaderBottomView()
@property (nonatomic, copy)   ButtonActionBlock      bottomBtnClickActionBlock;
@property (nonatomic, copy)   SliderValueChangeBlock sliderValueChangeBlock;

@property (nonatomic, strong) UILabel * currentChapterLabel;

@property (nonatomic, strong) UILabel * currentPageLabel;

@property (nonatomic, assign) NSInteger  currentPage;

@property (nonatomic, assign) NSInteger  totalPage;

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
    
    UILabel *currentPageLabel = [UILabel new];
    currentPageLabel.numberOfLines = 1;
    currentPageLabel.textAlignment = NSTextAlignmentRight;
    currentPageLabel.font          = [UIFont systemFontOfSize:14];
    currentPageLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:currentPageLabel];
    self.currentPageLabel = currentPageLabel;
    [currentPageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.width.mas_greaterThanOrEqualTo(40);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(self.mas_bottom).offset(-54);
    }];
    
    
    UISlider *slider      = [UISlider new];
    slider.backgroundColor= [UIColor clearColor];
    slider.maximumValue   = 1.0f;
    slider.minimumValue   = 0.0f;
    [slider addTarget:self action:@selector(sliderClickAction:) forControlEvents:UIControlEventValueChanged];
    [self addSubview: slider];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(currentPageLabel.mas_left).offset(-5);
        make.bottom.height.equalTo(currentPageLabel);
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
    _currentPage               = _totalPage * slider.value;
    self.currentPageLabel.text = [NSString stringWithFormat:@"%ld/%ld",_currentPage,_totalPage];
    if (self.sliderValueChangeBlock) {
        self.sliderValueChangeBlock(slider.value);
    }
}

- (void)setMCurrentChapter:(NSString *)mCurrentChapter
{
    self.currentChapterLabel.text = mCurrentChapter;
}

- (void)updatePageLabelWithCurrentPage:(NSInteger)currentPage totalPage:(NSInteger)totalPage;
{
    self.currentPage           = currentPage;
    self.totalPage             = totalPage;
    self.currentPageLabel.text = [NSString stringWithFormat:@"%ld/%ld",currentPage,totalPage];
}

- (void)setBlockSliderValueChangeAction:(void (^)(CGFloat))block
{
    self.sliderValueChangeBlock = block;
}

- (void)setBlockBottomBtnAction:(void (^)(UIButton *))block
{
    self.bottomBtnClickActionBlock = block;
}

@end
