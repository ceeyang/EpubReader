//
//  EpubMainViewController.m
//  XCEpubReader
//
//  Created by pro on 2016/9/23.
//  Copyright © 2016年 daisy. All rights reserved.
//

#import "EpubMainViewController.h"
#import "ReaderTopView.h"
#import "EPubBookModel.h"
#import "ReaderMainView.h"
#import "EpubRecordModel.h"

@interface EpubMainViewController ()<EPubViewDelegate>

/** 导航栏视图 */
@property (nonatomic, strong) ReaderTopView  * topView;
/** 当前加载的电子书 */
@property (nonatomic, strong) EpubBookModel  * epubBook;
/** 主视图 */
@property (nonatomic, strong) ReaderMainView * mainView;

/** 当前章节在书中的索引值，从0开始 */
@property (nonatomic, assign) int              currentSpineIndex;
/** 书籍总页数，等于所有章节页数之和 */
@property (nonatomic, assign) int              totalPagesCount;
/** 跳转页码 */
@property (nonatomic, assign) NSInteger        gotoPage;

@end

@implementation EpubMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self parseEpubData];
    [self setupUI];
    [self addBlockAction];
}

- (void)setupUI
{
    /** main web view */
    ReaderMainView *mainView = [ReaderMainView new];
    mainView.delegate        = self;
    [self.view addSubview: mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.mainView            = mainView;
    
    /** TopView */
    ReaderTopView *topView   = [ReaderTopView new];
    [self.view addSubview: topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(kTopViewHeight);
    }];
    self.topView             = topView;
}

- (void)addBlockAction
{
    __weak typeof(self) weakSelf = self;
    [self.topView setBlockBackBtnAction:^(UIButton *sender) {
        [weakSelf dismissViewControllerAnimated:true completion:nil];
    }];
    
    [self.topView setBlockMoreBtnAction:^(UIButton *sender) {
        NSLog(@"%@ : %s",[weakSelf class],__func__);
    }];
}

- (void)parseEpubData
{
    __weak typeof(self) weakSelf = self;
    NSURL * PathUrl = [NSURL fileURLWithPath:self.filePath];
    if (self.filePath && [[NSFileManager defaultManager] fileExistsAtPath: self.filePath]) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            weakSelf.epubBook = [EpubBookModel getLocalModelWithURL: PathUrl];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.topView setTitle: weakSelf.epubBook.bookName];
                [weakSelf.mainView loadChapter: weakSelf.epubBook.spineArray[0]];
            });
        });
    }
}

#pragma mark - EPubView Delegate Method

- (void)gotoPrevSpine
{
    if (_currentSpineIndex > 0)
    {
        [self gotoPage:0 inSpine:--_currentSpineIndex];
    }
}

- (void)gotoNextSpine
{
    if (_currentSpineIndex < self.epubBook.spineArray.count - 1)
        [self gotoPage:0 inSpine:++_currentSpineIndex];
}

- (void)epubViewLoadFinished
{
    if (self.mainView.next)
        [self gotoPageInCurrentSpine:0];
    else
        [self gotoPageInCurrentSpine:self.mainView.pageCount - 1];
}

- (void)tapGestureDidRecognized
{
    [self showOrHidenTopView];
}


#pragma mark - Read Control

- (void)gotoPageInCurrentSpine:(int)pageIndex
{
    [self.mainView gotoPage: pageIndex];
}

- (void)gotoPage:(int)pageIndex inSpine:(int)spineIndex
{
    _currentSpineIndex        = spineIndex;
    self.gotoPage             = pageIndex;
    EpubChapterModel *chapter = [self.epubBook.spineArray objectAtIndex:spineIndex];
    [self.mainView loadChapter: chapter];
}

- (void)showOrHidenTopView
{
    
    CGPoint headCenter = self.topView.center;
    CGFloat viewAlpha  = 0;
    
    if (self.topView.center.y > 0) {
        viewAlpha      = 0;
        headCenter.y  -= self.topView.frame.size.height;
        /** 需要设置info.plist里的 View controller-based status bar appearance 设为NO */
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    } else {
        viewAlpha      = 1.0f;
        headCenter.y  += self.topView.frame.size.height;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    }
    
    self.mainView.webView.userInteractionEnabled = false;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3f animations:^{
        weakSelf.topView.alpha  = viewAlpha;
        weakSelf.topView.center = headCenter;
    } completion:^(BOOL finished) {
        weakSelf.mainView.webView.userInteractionEnabled = true;
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"%@ : %s",[self class],__func__);
}

- (void)dealloc
{
    NSLog(@"%@ Dealloc Success",[self class]);
}


@end
