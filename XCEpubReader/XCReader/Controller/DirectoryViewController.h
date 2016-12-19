//
//  DirectoryViewController.h
//  XCEpubReader
//
//  Created by pro on 2016/12/9.
//  Copyright © 2016年 daisy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EpubChapterModel.h"

@interface DirectoryViewController : UIViewController

@property (nonatomic, strong) NSMutableArray * spineArray;

@property (nonatomic, assign) NSInteger  currentIndex;

- (void)setDirectorySelectedAction:(void(^)(EpubChapterModel *model))block;

@end
