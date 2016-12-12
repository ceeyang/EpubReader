//
//  ReaderThemes.m
//  XCEpubReader
//
//  Created by pro on 2016/9/27.
//  Copyright © 2016年 daisy. All rights reserved.
//

#import "ReaderThemes.h"

@implementation ReaderThemes
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.textBackgroundColor     = [aDecoder decodeObjectForKey: @"textBackgroundColor"];
        self.textColor               = [aDecoder decodeObjectForKey: @"textColor"];
        self.toolViewToolColor       = [aDecoder decodeObjectForKey: @"toolViewToolColor"];
        self.toolViewBackgroundColor = [aDecoder decodeObjectForKey: @"toolViewBackgroundColor"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject: self.textBackgroundColor     forKey: @"textBackgroundColor"];
    [aCoder encodeObject: self.textColor               forKey: @"textColor"];
    [aCoder encodeObject: self.toolViewToolColor       forKey: @"toolViewToolColor"];
    [aCoder encodeObject: self.toolViewBackgroundColor forKey: @"toolViewBackgroundColor"];
}

- (id)copyWithZone:(NSZone *)zone
{
    ReaderThemes *model = [[ReaderThemes allocWithZone:zone] init];
    model.textBackgroundColor     = self.textBackgroundColor;
    model.textColor               = self.textColor;
    model.toolViewToolColor       = self.toolViewToolColor;
    model.toolViewBackgroundColor = self.toolViewBackgroundColor;
    return model;
}

@end
