//
//  ReaderBottomView.h
//  XCEpubReader
//
//  Created by pro on 2016/9/24.
//  Copyright © 2016年 daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReaderBottomView : UIView

@property (nonatomic, strong) UISlider * mSlider;

@property (nonatomic, strong) UILabel  * mCurrentChapterlabel;

@property (nonatomic, strong) UIButton * mBigSizeBtn;

@property (nonatomic, strong) UIButton * mSmallSizeBtn;

@property (nonatomic, strong) UIButton * mDaytimeBtn;

@property (nonatomic, strong) UIButton * mNightModelBtn;

@end
