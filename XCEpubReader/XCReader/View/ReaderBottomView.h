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

/** 当前章节 */
@property (nonatomic, strong) NSString  * mCurrentChapter;

/** 刷新页码 */
- (void)updatePageLabelWithCurrentPage:(NSInteger)currentPage totalPage:(NSInteger)totalPage;

/** 底部按钮点击事件 */
- (void)setBlockBottomBtnAction:(void (^)(UIButton *btn))block;

/** slider 滑动事件 */
- (void)setBlockSliderValueChangeAction:(void (^)(CGFloat value))block;

@end
