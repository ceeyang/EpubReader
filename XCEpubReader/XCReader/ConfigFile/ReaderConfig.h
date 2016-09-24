//
//  ReaderConfig.h
//  XCEpubReader
//
//  Created by pro on 2016/9/23.
//  Copyright © 2016年 daisy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - ReaderConfig -
@interface ReaderConfig : NSObject

/** 配置文件单利 */
+(instancetype)shareInstance;

/** 用于 web 脚本的字体大小, 默认: 100 */
@property (nonatomic)         CGFloat   textSize;

/** 字体颜色, 默认: 黑色 */
@property (nonatomic, strong) UIColor * textColor;

/** 主题颜色, 默认: 灰色 */
@property (nonatomic, strong) UIColor * themeColor;

/** 背景颜色, 默认: 白色 */
@property (nonatomic, strong) UIColor * backGroundColr;

@end


