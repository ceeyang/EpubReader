//
//  EpubChapterModel.h
//  XCEpubReader
//
//  Created by pro on 2016/9/23.
//  Copyright © 2016年 daisy. All rights reserved.
//

/**
 *  电子书章节模型类
 *
 *  Code by:
 *           yangxichuan
 */
#import <Foundation/Foundation.h>

@interface EpubChapterModel : NSObject <NSCopying, NSCoding>

/** 章节标题 */
@property (nonatomic, strong) NSString  *title;

/** 章节路径 */
@property (nonatomic, strong) NSString  *spinePath;

/** 章节索引 */
@property (nonatomic, assign) NSInteger spineIndex;

@end
