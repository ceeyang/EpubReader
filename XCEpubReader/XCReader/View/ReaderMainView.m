//
//  ReaderMainView.m
//  XCEpubReader
//
//  Created by pro on 2016/9/23.
//  Copyright © 2016年 daisy. All rights reserved.
//

#import "ReaderMainView.h"
#import "ReaderThemes.h"
#import "ReaderConfig.h"
#import "XCReaderConst.h"
#import "UIColor+Hex.h"

#define COLOR_WITH_HEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0f]


@interface ReaderMainView () <UIScrollViewDelegate, UIWebViewDelegate,UIGestureRecognizerDelegate>
@property (assign, nonatomic) CGPoint touchBeginPoint;
@property (nonatomic, copy) WebViewDidScrollBlock          webViewDidScrollBlock;
@property (nonatomic, copy) WebViewUrlDidClickActionBlock  webUrlClickActionBlock;
@property (nonatomic, copy) WebViewDidFinishLoadBlock      webViewDidFinishdLoadBlock;
@end

@implementation ReaderMainView

- (instancetype)init
{
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.backgroundColor = [UIColor colorWithHexString:ReaderConfiger.themes.textBackgroundColor];
    _next                                              = YES;
    _fontSize                                          = ReaderConfiger.textSize;
    _webView                                           = [UIWebView new];
    _webView.delegate                                  = self;
    _webView.backgroundColor                           = [UIColor clearColor];
    _webView.scrollView.bounces                        = true;
    _webView.scrollView.delegate                       = self;
    _webView.scrollView.pagingEnabled                  = true;
    _webView.scrollView.backgroundColor                = [UIColor clearColor];
    _webView.scrollView.alwaysBounceVertical           = false;
    _webView.scrollView.alwaysBounceHorizontal         = true;
    _webView.scrollView.showsVerticalScrollIndicator   = false;
    _webView.scrollView.showsHorizontalScrollIndicator = false;
    [self addSubview: _webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)loadChapter:(EpubChapterModel *)chapter
{
    _chapter                      = chapter;
    _recordModel.chapterModel     = _chapter;
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",kUserDocuments,chapter.spinePath]];
    [self.webView loadRequest: [NSURLRequest requestWithURL:url]];
}

- (void)loadChapter:(EpubChapterModel *)chapter withPageIndex:(NSInteger)page
{
    _chapter                      = chapter;
    _recordModel.chapterModel     = _chapter;
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",kUserDocuments,chapter.spinePath]];
    [self.webView loadRequest: [NSURLRequest requestWithURL:url]];
    
    /** 等待 webview 加载完毕,然后跳转页面 */
    __weak typeof(self) weakSelf = self;
    self.webViewDidFinishdLoadBlock = ^() {
        [weakSelf gotoPage:page isSliderAction:false];
    };
}

- (void)loadChapter:(EpubChapterModel *)chapter whenSuccess:(void (^)())successBlock
{
    _chapter                      = chapter;
    _recordModel.chapterModel     = _chapter;
    self.webView.backgroundColor  = [UIColor colorWithHexString:ReaderConfiger.themes.textBackgroundColor];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",kUserDocuments,chapter.spinePath]];
    [self.webView loadRequest: [NSURLRequest requestWithURL:url]];
    
    self.webViewDidFinishdLoadBlock = successBlock;
}

- (void)gotoPage:(NSInteger)pageIndex animation:(BOOL)animation
{
    [self gotoPage:pageIndex isSliderAction:false animation:animation];
}

- (void)gotoPage:(NSInteger)pageIndex isSliderAction:(BOOL)isSliderAction
{
    [self gotoPage:pageIndex isSliderAction:isSliderAction animation:true];
}

- (void)gotoPage: (NSInteger)pageIndex isSliderAction:(BOOL)isSliderAction animation:(BOOL)animation
{
    _currentPageIndex = pageIndex;
    _recordModel.page = pageIndex;
    float pageOffset  = pageIndex * self.webView.bounds.size.width;
    __weak typeof(self) weakSelf = self;
    if (pageIndex+1 > _pageCount) {
        return;
    }
    
    if (animation) {
        [UIView animateWithDuration:0.5 animations:^{
            [weakSelf.webView.scrollView setContentOffset:CGPointMake(pageOffset, 0) animated:NO];;
        }];
    } else {
        [weakSelf.webView.scrollView setContentOffset:CGPointMake(pageOffset, 0) animated:NO];;
    }
    
    /** 如果是滑动 slider调用这个方法 */
    if (isSliderAction == false) {
        if (self.webViewDidScrollBlock) {
            self.webViewDidScrollBlock(_currentPageIndex+1,_pageCount,_chapter.title);
        }
    }
}

- (void)setFontSize:(int)fontSize
{
    if(_fontSize <= 200 || _fontSize >= 50) {
        _fontSize = fontSize;
        
        __weak typeof(self) weakSelf = self;
        CGFloat pageValue = (CGFloat)(_currentPageIndex) / (CGFloat)(_pageCount);
        [self loadChapter:self.chapter whenSuccess:^{
            [weakSelf resetCurrentPageWhenFontSizeChangedWith:pageValue];
        }];
    }
}

- (void)resetCurrentPageWhenFontSizeChangedWith:(CGFloat)pageValue
{
    NSInteger currentPage = pageValue * _pageCount;
    [self gotoPage:currentPage isSliderAction:false];
}

- (void)updateThemes:(ReaderThemesEnum)themStyle
{
    ReaderConfiger.themeStyle = themStyle;
    self.backgroundColor = [UIColor colorWithHexString:ReaderConfiger.themes.textBackgroundColor];
    [self loadChapter: self.chapter];
}

#pragma mark - WebView Delegate Method
- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    NSString * themeTextColor = ReaderConfiger.themes.textColor;
    NSString * themeBodyColor = ReaderConfiger.themes.textBackgroundColor;
    CGFloat    pageWidth      = self.webView.frame.size.width;
    CGFloat    pageHeight     = self.webView.frame.size.height - 20;
    
    /** 添加 JS 代码 */
    NSString *varMySheet     = @"var mySheet = document.styleSheets[0];";
    NSString *addCSSRule     = @"function addCSSRule(selector, newRule) {"
                                    "if (mySheet.addRule) {"
                                        "mySheet.addRule(selector, newRule);"
                                    "} else {"
                                        "ruleIndex = mySheet.cssRules.length;"
                                        "mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);"
                                    "}"
                                 "}";
    
    /** 设置宽度 */
    NSString *setWebSize   = [NSString stringWithFormat: @"addCSSRule('html', 'padding: 10px; height: %fpx; -webkit-column-gap: 20px; -webkit-column-width: %fpx;')",pageHeight,pageWidth];
    /** 设置段落规则 */
    NSString *setPRule     = [NSString stringWithFormat: @"addCSSRule('p', 'text-align: justify;')"];
    /** 设置字体大小 */
    NSString *setTextSize  = [NSString stringWithFormat: @"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')", _fontSize];
    /** 设置字体背景色 */
    NSString *setbodycolor = [NSString stringWithFormat: @"addCSSRule('body', 'background-color: %@;')",themeBodyColor];
    /** 设置字体颜色 */
    NSString *setTitlecolor= [NSString stringWithFormat: @"addCSSRule('body', 'color: %@;')",themeTextColor];
    
    [self.webView stringByEvaluatingJavaScriptFromString: varMySheet];
    [self.webView stringByEvaluatingJavaScriptFromString: addCSSRule];
    [self.webView stringByEvaluatingJavaScriptFromString: setWebSize];
    [self.webView stringByEvaluatingJavaScriptFromString: setPRule];
    [self.webView stringByEvaluatingJavaScriptFromString: setTextSize];
    [self.webView stringByEvaluatingJavaScriptFromString: setbodycolor];
    [self.webView stringByEvaluatingJavaScriptFromString: setTitlecolor];
    
    int totalWidth    = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollWidth"] intValue];
    _pageCount        = ceil(totalWidth / self.webView.bounds.size.width);
    _currentPageIndex = 0;
    if ([self.delegate respondsToSelector:@selector(epubViewLoadFinished)]) {
        [self.delegate epubViewLoadFinished];
    }
    
    if (self.webViewDidFinishdLoadBlock) {
        self.webViewDidFinishdLoadBlock();
        self.webViewDidFinishdLoadBlock = nil;
    }
}

/** 设置 webview 中的链接地址是否可点击 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        
        if (ReaderConfiger.isUrlEnable) {
            /** 获取到链接的 url 地址,在主控制器中做跳转 */
            NSString *urlStr = request.URL.absoluteString.lastPathComponent;
            if (self.webUrlClickActionBlock) {
                self.webUrlClickActionBlock(urlStr);
            }
        }
        return false;
    } else {
        return true;
    }
}

#pragma mark - ScrollView Delegate Method
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    self.touchBeginPoint  = scrollView.contentOffset;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat   pageWidth   = scrollView.frame.size.width;
    CGFloat lastPageIndex = _currentPageIndex;
    _currentPageIndex     = ceil(scrollView.contentOffset.x / pageWidth);
    
    if (lastPageIndex != _currentPageIndex) {
        if (self.webViewDidScrollBlock) {
            self.webViewDidScrollBlock(_currentPageIndex+1,_pageCount,_chapter.title);
        }
    }
    
    CGPoint touchEndPoint = scrollView.contentOffset;
    _next = self.touchBeginPoint.x > touchEndPoint.x + 5;
    
    if (!self.next) {
        if (_currentPageIndex == 0) {
            [self.delegate gotoPrevSpine];
        }
    } else {
        if(_currentPageIndex + 1 == _pageCount) {
            [self.delegate gotoNextSpine];
        }
    }
}

/** 捕获 webView 的单击事件 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapGestureDidRecognized)]) {
        [self.delegate tapGestureDidRecognized];
    }
}

- (void)setBlockPageDidChangedAction:(void (^)(NSInteger currentPage,NSInteger totalPage,NSString *chapterName))block
{
    self.webViewDidScrollBlock = block;
}

- (void)setBlockWebUrlDidClickAction:(void (^)(NSString *pathUrl))block
{
    self.webUrlClickActionBlock = block;
}
@end
