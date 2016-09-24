//
//  XCReaderConst.h
//  XCEpubReader
//
//  Created by pro on 2016/9/24.
//  Copyright © 2016年 daisy. All rights reserved.
//

#ifndef XCReaderConst_h
#define XCReaderConst_h

#pragma mark - Global Define -
#define FileManager      [NSFileManager defaultManager]
#define ReaderConfiger   [ReaderConfig shareInstance]
#define kUserDocuments   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

/** Default value */
#define kTopViewHeight   64.f

/** Notification */

/** Action Block */
typedef void(^ButtonActionBlock)(UIButton *btn);


#endif /* XCReaderConst_h */
