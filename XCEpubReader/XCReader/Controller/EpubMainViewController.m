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
#import "ReaderBottomView.h"
#import "AppDelegate.h"
#import "DirectoryViewController.h"
#import "XCReaderConst.h"
#import "ReaderConfig.h"

@interface EpubMainViewController ()<EPubViewDelegate>

/** 导航栏视图 */
@property (nonatomic, strong) ReaderTopView  * topView;
/** 主视图 */
@property (nonatomic, strong) ReaderMainView * mainView;
/** 底部视图 */
@property (nonatomic, strong) ReaderBottomView * bottomView;
/** 遮罩层 */
@property (nonatomic, strong) UIControl * coverControl;


/** 当前加载的电子书 */
@property (nonatomic, strong) EpubBookModel  * epubBook;

/** 书籍总页数，等于所有章节页数之和 */
@property (nonatomic, assign) int              totalPagesCount;
/** 跳转页码 */
@property (nonatomic, assign) NSInteger        gotoPage;
/** 是否需要显示工具栏 */
@property (nonatomic, assign) BOOL             needShowToolView;

@end

@implementation EpubMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.needShowToolView     = true;
    
    /** 解析电子书 */
    [self parseEpubData];
    
    /** 创建界面 */
    [self setupUI];
    
    /** 添加点击事件 */
    [self addBlockAction];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self performSelector:@selector(showOrHidenToolView) withObject:nil afterDelay:2.0f];
}

#pragma mark - UI -
- (void)setupUI
{
    __weak typeof(self) weakSelf = self;
    
    /** main web view */
    ReaderMainView *mainView = [ReaderMainView new];
    mainView.delegate        = self;
    [self.view addSubview: mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    self.mainView            = mainView;
    
    /** TopView */
    ReaderTopView *topView   = [ReaderTopView new];
    [self.view addSubview: topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(kTopViewHeight);
    }];
    self.topView             = topView;
    
    ReaderBottomView *bottom = [ReaderBottomView new];
    [self.view addSubview: bottom];
    [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.height.equalTo(@110);
    }];
    self.bottomView          = bottom;
    
    UIControl *cover = [UIControl new];
    [cover addTarget:self action:@selector(showOrHidenToolView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cover];
    self.coverControl = cover;
    [cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(topView.mas_bottom);
        make.bottom.mas_equalTo(bottom.mas_top);
    }];
}

#pragma mark - Action -
- (void)addBlockAction
{
    __weak typeof(self) weakSelf = self;
    [self.topView setBlockBackBtnAction:^(UIButton *sender) {
        [EpubBookModel updateLocalModel:weakSelf.epubBook url:[NSURL fileURLWithPath: weakSelf.filePath]];
        [weakSelf dismissViewControllerAnimated:true completion:nil];
    }];
    
     /** 目录按钮 */
    [self.topView setBlockMoreBtnAction:^(UIButton *sender) {
        DirectoryViewController *directory = [DirectoryViewController new];
        directory.currentIndex = weakSelf.epubBook.currentChapterIndex;
        directory.spineArray = weakSelf.epubBook.spineArray;
        /** 目录点击事件 */
        [directory setDirectorySelectedAction:^(EpubChapterModel *model) {
            weakSelf.epubBook.currentPageIndex    = 1;
            weakSelf.epubBook.currentChapterIndex = model.spineIndex;
            [weakSelf.mainView loadChapter: model withPageIndex:0];
            
        }];
        [weakSelf presentViewController:directory animated:true completion:nil];
    }];
    
    /** 刷新底部视图,包括:当前页码,slider */
    [self.mainView setBlockPageDidChangedAction:^(NSInteger currentPage, NSInteger totalPage, NSString *chapterName) {
        [weakSelf.bottomView updatePageLabelWithCurrentPage:currentPage totalPage:totalPage];
        weakSelf.bottomView.pageSlider.value  = (CGFloat)(currentPage) / (CGFloat)(totalPage);
        weakSelf.bottomView.mCurrentChapter   = chapterName;
        weakSelf.epubBook.currentPageIndex    = currentPage;
    }];
    
    /** 电子书链接点击事件 */
    [self.mainView setBlockWebUrlDidClickAction:^(NSString *pathUrl) {
        [weakSelf webUrlDidClickWith:pathUrl];
    }];
    
    /** 底部按钮点击事件 */
    [self.bottomView setBlockBottomBtnAction:^(UIButton *btn) {
        
        if        (btn.tag == 0) {
            /** 字体放大 */
            ReaderConfiger.textSize -= 5;
            [weakSelf.mainView setFontSize:ReaderConfiger.textSize];
            
        } else if (btn.tag == 1) {
            
            /** 字体缩小 */
            ReaderConfiger.textSize += 5;
            [weakSelf.mainView setFontSize:ReaderConfiger.textSize];
            
        } else if (btn.tag == 2) {
            
            /** 上一章节 */
            weakSelf.epubBook.currentChapterIndex -=1;
            if (weakSelf.epubBook.currentChapterIndex < 0) {return ;}
            [weakSelf.mainView loadChapter: weakSelf.epubBook.spineArray[weakSelf.epubBook.currentChapterIndex]];
            
        } else if (btn.tag == 3) {
            
            /** 下一章节 */
            weakSelf.epubBook.currentChapterIndex +=1;
            if (weakSelf.epubBook.currentChapterIndex >= weakSelf.epubBook.spineArray.count) {return ;}
            [weakSelf.mainView loadChapter: weakSelf.epubBook.spineArray[weakSelf.epubBook.currentChapterIndex]];
            
        } else if (btn.tag == 4) {
            
            /** 日间模式 */
            [weakSelf.mainView updateThemes: Daily];
            
        } else if (btn.tag == 5) {
            
            /** 夜间模式 */
            [weakSelf.mainView updateThemes: Night];
            
        }
    }];
    
    /** slider 滑动事件 */
    [self.bottomView setBlockSliderValueChangeAction:^(CGFloat value) {
        int sliderPage = weakSelf.mainView.pageCount * value;
        weakSelf.epubBook.currentPageIndex = sliderPage;
        [weakSelf.mainView gotoPage: sliderPage isSliderAction:true];
    }];
}

/** web url 点击事件 */
- (void)webUrlDidClickWith:(NSString *)pathUrlStr
{
    if (!self.epubBook || self.epubBook.parseSucceed == false) {
        NSLog(@"数据解析中,请稍等");
        return;
    }
    for (EpubChapterModel *chapter in self.epubBook.spineArray) {
        if ([chapter.spinePath.lastPathComponent isEqualToString: pathUrlStr]) {
            [self gotoPage:0 inSpine:chapter.spineIndex];
        }
    }
}

/** 解析电子书 */
- (void)parseEpubData
{
    __weak typeof(self) weakSelf = self;
    if (self.filePath && [[NSFileManager defaultManager] fileExistsAtPath: self.filePath]) {
        [self showLoadingView];
        NSURL * PathUrl = [NSURL fileURLWithPath:self.filePath];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            EpubBookModel *localBook = [EpubBookModel getLocalModelWithURL: PathUrl];
            if (localBook == nil) {
                [EpubBookModel parseBookWithUrl:PathUrl whenFirstChapterFinished:^(EpubBookModel *book) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf hideLoadingView];
                        [weakSelf.topView setTitle: book.bookName];
                        [weakSelf.mainView loadChapter:book.spineArray.firstObject];
                    });
                } finalSuccess:^(EpubBookModel *model) {
                    weakSelf.epubBook = model;
                }];
            } else {
                weakSelf.epubBook = localBook;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakSelf hideLoadingView];
                    /** 设置标题 */
                    [weakSelf.topView setTitle: weakSelf.epubBook.bookName];
                    EpubChapterModel * historyChapter = weakSelf.epubBook.spineArray[weakSelf.epubBook.currentChapterIndex];
                    NSInteger          historyPage    = weakSelf.epubBook.currentPageIndex-1;
                    [weakSelf.mainView loadChapter: historyChapter withPageIndex:historyPage];
                });
            }
        });
    }
}

#pragma mark - EPubView Delegate Method
/** 上一章节 */
- (void)gotoPrevSpine
{
    if (self.epubBook.currentChapterIndex > 0)
    {
        [self gotoPage:0 inSpine: --self.epubBook.currentChapterIndex];
    }
}
/** 下一章 */
- (void)gotoNextSpine
{
    if (self.epubBook.currentChapterIndex < self.epubBook.spineArray.count - 1) {
        [self gotoPage:0 inSpine: ++self.epubBook.currentChapterIndex];
    }
}

- (void)epubViewLoadFinished
{
    [self hideLoadingView];
    if (self.mainView.next) {
        [self gotoPageInCurrentSpine:0];
    } else {
        [self gotoPageInCurrentSpine:self.mainView.pageCount - 1];
    }
    CGFloat sliderValue = self.mainView.currentPageIndex / self.mainView.pageCount;
    self.bottomView.pageSlider.value = sliderValue;
}

- (void)tapGestureDidRecognized
{
    [self showOrHidenToolView];
}


#pragma mark - Read Control
- (void)gotoPageInCurrentSpine:(NSInteger)pageIndex
{
    [self.mainView gotoPage: pageIndex isSliderAction:false];
}

- (void)gotoPage:(NSInteger)pageIndex inSpine:(NSInteger)spineIndex
{
    self.epubBook.currentPageIndex    = pageIndex+1;
    self.epubBook.currentChapterIndex = spineIndex;
    EpubChapterModel *chapter      = [self.epubBook.spineArray objectAtIndex:spineIndex];
    [self.mainView loadChapter: chapter];
}

/** 隐藏或者显示工具栏 */
- (void)showOrHidenToolView
{
    CGPoint headCenter   = self.topView.center;
    CGPoint footCenter   = self.bottomView.center;
    CGFloat viewAlpha    = 0;
    
    if (self.topView.center.y > 0) {
        viewAlpha        = 0;
        headCenter.y    -= self.topView.frame.size.height;
        footCenter.y    += self.bottomView.frame.size.height;
        /** 需要设置info.plist里的 View controller-based status bar appearance 设为NO */
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
        self.coverControl.hidden = true;
    } else {
        viewAlpha        = 1.0f;
        headCenter.y    += self.topView.frame.size.height;
        footCenter.y    -= self.bottomView.frame.size.height;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
        self.coverControl.hidden = false;
    }
    
    self.mainView.webView.userInteractionEnabled = false;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3f animations:^{
        weakSelf.topView.alpha    = viewAlpha;
        weakSelf.bottomView.alpha = viewAlpha;
        weakSelf.topView.center   = headCenter;
        weakSelf.bottomView.center=footCenter;
    } completion:^(BOOL finished) {
        weakSelf.mainView.webView.userInteractionEnabled = true;
    }];
}

- (void)showLoadingView
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo: delegate.window animated:YES];
    hud.labelText      = @"请稍等";
    hud.dimBackground  = true;
    hud.opacity        = 0.5;
}

- (void)hideLoadingView
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [MBProgressHUD hideHUDForView:delegate.window animated:true];
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
