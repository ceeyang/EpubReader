//
//  ReaderPageViewController.m
//  XCEpubReader
//
//  Created by pro on 2016/9/27.
//  Copyright © 2016年 daisy. All rights reserved.
//

#import "ReaderPageViewController.h"
#import "ReaderTopView.h"
#import "MainViewController.h"
#import "ReaderBottomView.h"
#import "EpubBookModel.h"

@interface ReaderPageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property (nonatomic, strong) UIPageViewController * pageViewController;
@property (nonatomic, strong) MainViewController   * readViewController;
@property (nonatomic, strong) ReaderTopView        * topView;
@property (nonatomic, strong) ReaderBottomView     * bottomView;
@property (nonatomic, strong) EpubBookModel        * epubBook;
@end

@implementation ReaderPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self parseEpubData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self performSelector:@selector(showOrHidenToolView) withObject:nil afterDelay:2.0f];
}

- (void)setupUI
{
    [self addChildViewController: self.pageViewController];
    [self.view addSubview: self.pageViewController.view];
    
    ReaderTopView *topView = [ReaderTopView new];
    [self.view addSubview: topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@kTopViewHeight);
    }];
    self.topView           = topView;
    
    ReaderBottomView *bottomView = [ReaderBottomView new];
    [self.view addSubview: bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@110);
    }];
    self.bottomView        = bottomView;
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
                [weakSelf.readViewController.mainView loadChapter: weakSelf.epubBook.spineArray[0]];
            });
        });
    }
}

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
    } else {
        viewAlpha        = 1.0f;
        headCenter.y    += self.topView.frame.size.height;
        footCenter.y    -= self.bottomView.frame.size.height;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    }
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3f animations:^{
        weakSelf.topView.alpha    = viewAlpha;
        weakSelf.bottomView.alpha = viewAlpha;
        weakSelf.topView.center   = headCenter;
        weakSelf.bottomView.center=footCenter;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - UIPageViewControllerDelegate & DataSource -
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    MainViewController *readView = [[MainViewController alloc] init];
    return readView;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    MainViewController *readView = [[MainViewController alloc] init];
    return readView;
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    
}

#pragma mark - Lazy -
- (UIPageViewController *)pageViewController
{
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle: UIPageViewControllerTransitionStylePageCurl navigationOrientation: UIPageViewControllerNavigationOrientationHorizontal options: nil];
        _pageViewController.delegate   = self;
        _pageViewController.dataSource = self;
        [_pageViewController setViewControllers: @[self.readViewController]
                                      direction: UIPageViewControllerNavigationDirectionForward
                                       animated: YES
                                     completion: nil];
    }
    return _pageViewController;
}

- (MainViewController *)readViewController
{
    if (!_readViewController) {
        _readViewController = [MainViewController new];
    }
    return _readViewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"\n%@ Dealloc Success",[self class]);
}
@end
