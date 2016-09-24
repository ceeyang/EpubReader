//
//  ReaderTopView.h
//  XCEpubReader
//
//  Created by pro on 2016/9/23.
//  Copyright © 2016年 daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReaderTopView : UIView

/** 返回按钮 */
@property (nonatomic, strong) UIButton       * mBackBtn;

/** 标题 */
@property (nonatomic, strong) NSString       * title;

/** 功能菜单 */
@property (nonatomic, strong) UIButton       * mRightBtn;

/** 返回按钮点击事件 */
- (void)setBlockBackBtnAction:(void (^)(UIButton *sender))block;

/** 更多按钮点击事件 */
- (void)setBlockMoreBtnAction:(void (^)(UIButton *sender))block;

@end
