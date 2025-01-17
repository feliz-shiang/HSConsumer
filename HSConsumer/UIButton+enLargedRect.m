//
//  UIButton+enLargedRect.m
//  Srollview
//
//  Created by apple on 14-11-10.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "UIButton+enLargedRect.h"
#import <objc/runtime.h>
@implementation UIButton (enLargedRect)
static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

-(void)setEnlargEdgeWithTop : (CGFloat )top right :(CGFloat)right bottom :(CGFloat )bottom left :(CGFloat)left
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect) enlargedRect
{
    NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge)
    {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }
    else
    {
          return self.bounds;
    }
}
- (UIView*) hitTest:(CGPoint) point withEvent:(UIEvent*) event
{
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds))
    {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}

- (void)setBorderWithWidth:(CGFloat)width andRadius:(CGFloat)radius andColor:(UIColor *)color
{
    self.layer.borderWidth = width;
    self.layer.cornerRadius = radius;
    if (color)
        self.layer.borderColor = color.CGColor;
}

@end
