//
//  ReaderConfig.m
//  XCEpubReader
//
//  Created by pro on 2016/9/23.
//  Copyright © 2016年 daisy. All rights reserved.
//

#import "ReaderConfig.h"

@implementation ReaderConfig

+(instancetype)shareInstance
{
    static ReaderConfig *readConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        readConfig = [[self alloc] init];
    });
    return readConfig;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey: @"ReadConfig"];
        if (data) {
            NSKeyedUnarchiver *unarchive = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
            ReaderConfig *config         = [unarchive decodeObjectForKey:@"ReadConfig"];
            [config addObserver:config forKeyPath:@"textSize"   options: NSKeyValueObservingOptionNew context: NULL];
            [config addObserver:config forKeyPath:@"textColor"  options: NSKeyValueObservingOptionNew context: NULL];
            [config addObserver:config forKeyPath:@"themeColor" options: NSKeyValueObservingOptionNew context: NULL];
            [config addObserver:config forKeyPath:@"backColr"   options: NSKeyValueObservingOptionNew context: NULL];
            return config;
        }
        
        _textSize       = 100;
        _textColor      = [UIColor blackColor];
        _themeColor     = [UIColor lightGrayColor];
        _backGroundColr = [UIColor whiteColor];
        
        [self addObserver:self forKeyPath:@"textSize"   options:NSKeyValueObservingOptionNew context: NULL];
        [self addObserver:self forKeyPath:@"textColor"  options:NSKeyValueObservingOptionNew context: NULL];
        [self addObserver:self forKeyPath:@"themeColor" options:NSKeyValueObservingOptionNew context: NULL];
        [self addObserver:self forKeyPath:@"backColr"   options:NSKeyValueObservingOptionNew context: NULL];
        [ReaderConfig updateLocalConfig:self];
        
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    [ReaderConfig updateLocalConfig:self];
}

+(void)updateLocalConfig:(ReaderConfig *)config
{
    NSMutableData *data       = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:config forKey:@"ReadConfig"];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"ReadConfig"];
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeDouble: self.textSize       forKey: @"textSize"];
    [aCoder encodeObject: self.textColor      forKey: @"textColor"];
    [aCoder encodeObject: self.themeColor     forKey: @"themeColor"];
    [aCoder encodeObject: self.backGroundColr forKey: @"backColr"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.textSize       = [aDecoder decodeDoubleForKey: @"textSize"];
        self.textColor      = [aDecoder decodeObjectForKey: @"textColor"];
        self.themeColor     = [aDecoder decodeObjectForKey: @"themeColor"];
        self.backGroundColr = [aDecoder decodeObjectForKey: @"backColr"];
    }
    return self;
}

@end
