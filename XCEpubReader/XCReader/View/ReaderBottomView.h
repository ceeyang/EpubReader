//
//  ReaderBottomView.h
//  XCEpubReader
//
//  Created by pro on 2016/9/24.
//  Copyright © 2016年 daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReaderBottomView : UIView

@property (nonatomic, strong) UISlider * pageSlider;

@property (nonatomic, strong) NSString  * mCurrentChapter;

- (void)setBlockBottomBtnAction:(void (^)(UIButton *btn))block;

- (void)setBlockSliderValueChangeAction:(void (^)(CGFloat value))block;

@end
