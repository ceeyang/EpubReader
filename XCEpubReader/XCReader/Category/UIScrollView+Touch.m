//
//  UIScrollView+Touch.m
//  CloudStudy
//
//  Created by pro on 2016/9/2.
//  Copyright © 2016年 蓝泰致铭. All rights reserved.
//

#import "UIScrollView+Touch.h"

@implementation UIScrollView (Touch)
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesBegan:touches withEvent:event];
    //[super touchesBegan:touches withEvent:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesMoved:touches withEvent:event];
    //[super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesEnded:touches withEvent:event];
    //[super touchesEnded:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self nextResponder] touchesCancelled:touches withEvent:event];
    //[super touchesCancelled:touches withEvent:event];
}
@end
