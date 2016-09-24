//
//  EpubRecordModel.h
//  XCEpubReader
//
//  Created by pro on 2016/9/24.
//  Copyright © 2016年 daisy. All rights reserved.
//


/**
 *  电子书阅读记录模型类
 *
 *  Code by:
 *           yangxichuan
 */
#import <Foundation/Foundation.h>
#import "EpubChapterModel.h"

@interface EpubRecordModel : NSObject <NSCopying, NSCoding>
/** 阅读的章节 */
@property (nonatomic, strong) EpubChapterModel * chapterModel;
/** 阅读的页数 */
@property (nonatomic, assign) NSUInteger          page;
/** 阅读的章节数 */
@property (nonatomic, assign) NSUInteger          chapter;
/** 总章节数 */
@property (nonatomic, assign) NSUInteger          chapterCount;
@end
