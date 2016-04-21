//
//  CALayer+Addition.m
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/9.
//  Copyright © 2015年 zp. All rights reserved.
//

#import "CALayer+Addition.h"
#import <objc/runtime.h>
static const NSString * kBorderColor = @"kBorderColor";
@implementation CALayer (Addition)

-(void)setBorderUIColor:(UIColor*)color
{
    objc_setAssociatedObject(self, &kBorderColor, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIColor*)borderUIColor
{
    return objc_getAssociatedObject(self, &kBorderColor);
}
@end

