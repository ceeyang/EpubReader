//
//  EpubChapterModel.m
//  XCEpubReader
//
//  Created by pro on 2016/9/23.
//  Copyright © 2016年 daisy. All rights reserved.
//

#import "EpubChapterModel.h"

@implementation EpubChapterModel
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init]) {
        _title      = [aDecoder decodeObjectForKey : @"title"];
        _spinePath  = [aDecoder decodeObjectForKey : @"spinePath"];
        _spineIndex = [aDecoder decodeIntegerForKey: @"spineIndex"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject : self.title       forKey: @"title"];
    [aCoder encodeObject : self.spinePath   forKey: @"spinePath"];
    [aCoder encodeInteger: self.spineIndex  forKey: @"spineIndex"];
}
-(id)copyWithZone:(NSZone *)zone
{
    EpubChapterModel *model = [[EpubChapterModel allocWithZone:zone] init];
    model.title             = self.title;
    model.spineIndex        = self.spineIndex;
    model.spinePath         = self.spinePath;
    return model;
    
}
@end
