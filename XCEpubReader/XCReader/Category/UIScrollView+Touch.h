//
//  UIScrollView+Touch.h
//  CloudStudy
//
//  Created by pro on 2016/9/2.
//  Copyright © 2016年 蓝泰致铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Touch)
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
@end
