//
//  EpubRecordModel.m
//  XCEpubReader
//
//  Created by pro on 2016/9/24.
//  Copyright © 2016年 daisy. All rights reserved.
//

#import "EpubRecordModel.h"

@implementation EpubRecordModel
-(id)copyWithZone:(NSZone *)zone {
    EpubRecordModel *recordModel = [[EpubRecordModel allocWithZone:zone]init];
    recordModel.chapterModel     = [self.chapterModel copy];
    recordModel.page             = self.page;
    recordModel.chapter          = self.chapter;
    return recordModel;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject : self.chapterModel forKey: @"chapterModel"];
    [aCoder encodeInteger: self.page         forKey: @"page"];
    [aCoder encodeInteger: self.chapter      forKey: @"chapter"];
    [aCoder encodeInteger: self.chapterCount forKey: @"chapterCount"];
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.chapterModel = [aDecoder decodeObjectForKey : @"chapterModel"];
        self.page         = [aDecoder decodeIntegerForKey: @"page"];
        self.chapter      = [aDecoder decodeIntegerForKey: @"chapter"];
        self.chapterCount = [aDecoder decodeIntegerForKey: @"chapterCount"];
    }
    return self;
}
@end
