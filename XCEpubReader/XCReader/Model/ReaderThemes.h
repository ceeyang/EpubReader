//
//  ReaderThemes.h
//  XCEpubReader
//
//  Created by pro on 2016/9/27.
//  Copyright © 2016年 daisy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReaderThemes : NSObject

/** WebView 背景色,由 JS 脚本加载,使用 "十六进制字符串颜色" 为字符串类型*/
@property (nonatomic, strong) NSString * textBackgroundColor;


/** WebView 文字颜色,由 JS 脚本加载,使用 "十六进制字符串颜色" 为字符串类型*/
@property (nonatomic, strong) NSString * textColor;


/** the backGroundColor of the main webView,Default is white */
@property (nonatomic, strong) UIColor * webBackgroundColor;

/** 工具栏背景色 UIColor 类型 */
@property (nonatomic, strong) UIColor * toolViewBackgroundColor;


/** 工具栏控件颜色 UIColor 类型 */
@property (nonatomic, strong) UIColor * toolViewToolColor;

@end
