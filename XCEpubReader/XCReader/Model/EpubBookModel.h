//
//  EpubBookModel.h
//  XCEpubReader
//
//  Created by pro on 2016/9/23.
//  Copyright © 2016年 daisy. All rights reserved.
//

/**
 *  电子书模型类
 *
 *  Code by:
 *           yangxichuan
 */

#import <Foundation/Foundation.h>
#import "EpubRecordModel.h"

@interface EpubBookModel : NSObject<NSCopying, NSCoding>

/** 书名 */
@property (nonatomic, strong) NSString        *bookName;

/** 章节集合数目 */
@property (nonatomic, strong) NSMutableArray  *spineArray;

/** 书文件路径 */
@property (nonatomic, strong) NSString         *bookPath;

/** 判断是否解析成功 */
@property (nonatomic, assign) BOOL             parseSucceed;

/** 浏览记录信息 */
@property (nonatomic, strong) EpubRecordModel  * recordModel;

@property (nonatomic, assign) NSInteger          currentChapterIndex;
@property (nonatomic, assign) NSInteger          currentPageIndex;

/** 初始化方法 */
- (id)initWithEPubBookPath: (NSURL *)bookPath whenFirstChapterFinished:(void(^)(EpubBookModel *book))firstChacperFinished finalSuccess:(void(^)(EpubBookModel *book))success;

+ (void)parseBookWithUrl:(NSURL *)url whenFirstChapterFinished:(void(^)(EpubBookModel *book))firstChacperFinished finalSuccess:(void(^)(EpubBookModel *book))success;

+ (void)updateLocalModel: (EpubBookModel *)readModel
                     url: (NSURL *)url;

+ (id)getLocalModelWithURL: (NSURL *)url;

- (void)updateRecordeModel:(EpubRecordModel *)model withUrl:(NSURL *)url;

@end
