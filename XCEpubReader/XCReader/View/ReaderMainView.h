//
//  ReaderMainView.h
//  XCEpubReader
//
//  Created by pro on 2016/9/23.
//  Copyright © 2016年 daisy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EpubChapterModel.h"
#import "EpubRecordModel.h"

@protocol EPubViewDelegate <NSObject>

@required
/** 上一章 */
- (void)gotoPrevSpine;

/** 下一章 */
- (void)gotoNextSpine;

/** 单击屏幕 */
- (void)tapGestureDidRecognized;

@optional

/** 电子书加载结束 */
- (void)epubViewLoadFinished;

@end


@interface ReaderMainView : UIView

/** 当前页在当前章节的索引值，从0开始 */
@property (nonatomic, readonly) int                currentPageIndex;

/** 当前章节的页数 */
@property (nonatomic, readonly) int                pageCount;

/** 文字字号大小 */
@property (nonatomic, assign)   int                fontSize;

/** webView 用于加载文本 */
@property (nonatomic, readonly) UIWebView        * webView;

/** 当前显示的章节 */
@property (nonatomic, readonly) EpubChapterModel * chapter;

/** 判断手势是上一章还是下一章，默认为YES，即为下一章。 */
@property (nonatomic, readonly, getter = isNext) BOOL next;

/** 离线模型 */
@property (nonatomic, strong) EpubRecordModel    * recordModel;

@property (nonatomic, weak)   id <EPubViewDelegate> delegate;

/** 章节跳转 */
- (void)loadChapter: (EpubChapterModel *)chapter;

/** 下一页   */
- (void)gotoPage: (int)pageIndex;

- (void)setFontSize:(int)fontSize;
@end
