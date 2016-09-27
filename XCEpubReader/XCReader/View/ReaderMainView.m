//
//  ReaderMainView.m
//  XCEpubReader
//
//  Created by pro on 2016/9/23.
//  Copyright © 2016年 daisy. All rights reserved.
//

#import "ReaderMainView.h"

#define COLOR_WITH_HEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0f]


@interface ReaderMainView () <UIScrollViewDelegate, UIWebViewDelegate,UIGestureRecognizerDelegate>
@property (assign, nonatomic) CGPoint touchBeginPoint;
@property (nonatomic, copy) WebViewDidScrollBlock webViewDidScrollBlock;
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
    self.backgroundColor                               = ReaderConfiger.themeColor;
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
    _chapter                  = chapter;
    _recordModel.chapterModel = _chapter;
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",kUserDocuments,chapter.spinePath]];
    [self.webView loadRequest: [NSURLRequest requestWithURL:url]];
}

- (void)gotoPage:(int)pageIndex
{
    _currentPageIndex = pageIndex;
    _recordModel.page = pageIndex;
    float pageOffset  = pageIndex * self.webView.bounds.size.width;
    [self.webView.scrollView setContentOffset:CGPointMake(pageOffset, 0) animated:NO];;
    if (self.webViewDidScrollBlock) {
        CGFloat pageValue = (CGFloat)(_currentPageIndex+1) / (CGFloat)_pageCount;
        self.webViewDidScrollBlock(pageValue);
    }
}

- (void)setFontSize:(int)fontSize
{
    
    if(_fontSize <= 200 || _fontSize >= 50) {
        _fontSize = fontSize;
        [self loadChapter:self.chapter];
    }
}


#pragma mark - WebView Delegate Method
- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    NSString * themeTextColor = @"#000000";
    NSString * themeBodyColor = @"#ffffff";
    CGFloat    pageWidth      = self.webView.frame.size.width;
    CGFloat    pageHeight     = self.webView.frame.size.height - 20;
    
    /** 添加 JS 代码 */
    NSString *varMySheet     = @"var mySheet = document.styleSheets[0];";
    NSString *addCSSRule     = @"function addCSSRule(selector, newRule) {"
    "if (mySheet.addRule) {"
    "mySheet.addRule(selector, newRule);"								// For Internet Explorer
    "} else {"
    "ruleIndex = mySheet.cssRules.length;"
    "mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);"   // For Firefox, Chrome, etc.
    "}"
    "}";
    
    /** 设置宽度 */
    NSString *setWebSize   = [NSString stringWithFormat: @"addCSSRule('html', 'padding: 10px; height: %fpx; -webkit-column-gap: 20px; -webkit-column-width: %fpx;')",pageHeight,pageWidth];
    /** 设置段落规则 */
    NSString *setPRule     = [NSString stringWithFormat: @"addCSSRule('p', 'text-align: justify;')"];
    /** 设置字体大小 */
    NSString *setTextSize  = [NSString stringWithFormat: @"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')", _fontSize];
    /** 设置字体颜色 */
    NSString *setbodycolor = [NSString stringWithFormat: @"addCSSRule('body', 'background-color: %@;')",themeBodyColor];
    /** 设置 H1标签 颜色 */
    NSString *setH1Color   = [NSString stringWithFormat: @"addCSSRule('h1', 'color: %@;')",themeTextColor];
    /** 设置段颜色 */
    NSString *setPcolor    = [NSString stringWithFormat: @"addCSSRule('p', 'color: %@;')",themeTextColor];
    
    [self.webView stringByEvaluatingJavaScriptFromString: varMySheet];
    [self.webView stringByEvaluatingJavaScriptFromString: addCSSRule];
    [self.webView stringByEvaluatingJavaScriptFromString: setWebSize];
    [self.webView stringByEvaluatingJavaScriptFromString: setPRule];
    [self.webView stringByEvaluatingJavaScriptFromString: setTextSize];
    [self.webView stringByEvaluatingJavaScriptFromString: setbodycolor];
    [self.webView stringByEvaluatingJavaScriptFromString: setH1Color];
    [self.webView stringByEvaluatingJavaScriptFromString: setPcolor];
    
    int totalWidth    = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollWidth"] intValue];
    _pageCount        = ceil(totalWidth / self.webView.bounds.size.width);
    _currentPageIndex = 0;
    if ([self.delegate respondsToSelector:@selector(epubViewLoadFinished)]) {
        [self.delegate epubViewLoadFinished];
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
            CGFloat pageValue = (CGFloat)(_currentPageIndex+1) / (CGFloat)_pageCount;
            self.webViewDidScrollBlock(pageValue);
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

- (void)setBlockPageDidChangedAction:(void (^)(CGFloat))block
{
    self.webViewDidScrollBlock = block;
}
@end
