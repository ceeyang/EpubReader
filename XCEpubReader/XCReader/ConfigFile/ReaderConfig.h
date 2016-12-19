//
//  ReaderConfig.h
//  XCEpubReader
//
//  Created by pro on 2016/9/23.
//  Copyright © 2016年 daisy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ReaderThemes.h"

/** ENUM */
typedef NS_ENUM(NSUInteger, ReaderThemesEnum) {
    Default      = 0,     /**< 默认主题 */
    ProtectEyes,          /**< 护眼模式 */
    Daily,                /**< 白天模式 */
    Night                 /**< 夜间模式 */
};

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

/** 当前主题 */
@property (nonatomic, strong) ReaderThemes * themes;

/** 提供几个默认主题,也可以自己设置 */
@property (nonatomic, assign) ReaderThemesEnum  themeStyle;

/** 是否开启, web页面内部链接跳转,default is false */
@property (nonatomic, assign,getter=isUrlEnable) BOOL  urlEnable;
@end


