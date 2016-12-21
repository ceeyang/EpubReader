//
//  DirectoryViewController.m
//  XCEpubReader
//
//  Created by pro on 2016/12/9.
//  Copyright © 2016年 daisy. All rights reserved.
//

#import "DirectoryViewController.h"
#import "Masonry.h"

typedef void(^DirectoryDidSelectedBlock)(EpubChapterModel *model);

@interface DirectoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView * headView;
@property (nonatomic, strong) UILabel * lbTitle;
@property (nonatomic, strong) UIView * footView;
@property (nonatomic, strong) UIButton * btnBack;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, copy) DirectoryDidSelectedBlock  directoryChangeBlock;
@end

@implementation DirectoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //界面
    [self setupUI];
    
    [self performSelector:@selector(refreshSelectRow) withObject:nil afterDelay:0.5f];
    
}


-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

-(void)setupUI
{
    _headView=[[UIView alloc] init];
    _headView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:_headView];
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    
    _lbTitle=[[UILabel alloc] init];
    _lbTitle.backgroundColor=[UIColor clearColor];
    _lbTitle.textColor=[UIColor whiteColor];
    _lbTitle.textAlignment=NSTextAlignmentCenter;
    _lbTitle.font=[UIFont boldSystemFontOfSize:16.0f];
    [_headView addSubview:_lbTitle];
    [_lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(_headView);
    }];
    
    //
    _footView=[[UIView alloc] init];
    _footView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:_footView];
    [_footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    self.btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnBack addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_footView addSubview:self.btnBack];
    self.btnBack.titleLabel.font=[UIFont systemFontOfSize:14.0f];
    [self.btnBack setTitle:@"返回"forState:UIControlStateNormal];
    [self.btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.mas_equalTo(_footView);
    }];
    
    
    _tableView=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.autoresizesSubviews=YES;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview: _tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(64);
        make.bottom.mas_equalTo(self.view).offset(-44);
    }];
}


-(void)refreshSelectRow
{
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

#pragma mark - TableView data source delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.spineArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=nil;
    
    static NSString *CellIdentifier = @"Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if( !cell )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (self.spineArray.count) {
        EpubChapterModel *model = self.spineArray[indexPath.row];
        cell.textLabel.text = model.title;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EpubChapterModel *model = self.spineArray[indexPath.row];
    if (self.directoryChangeBlock) {
        self.directoryChangeBlock(model);
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

- (void)setDirectorySelectedAction:(void (^)(EpubChapterModel *))block
{
    self.directoryChangeBlock = block;
}

-(void)btnClick:(id)sender
{
    [self dismissViewControllerAnimated:true completion:nil];
}
@end
