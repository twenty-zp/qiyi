//
//  SearchButton.m
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/6.
//  Copyright © 2015年 zp. All rights reserved.
//

#import "SearchButton.h"

@implementation SearchButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];

    }
    return self;
}

- (CGRect )titleRectForContentRect:(CGRect)contentRect
{
    UIImage * image = [self imageForState:(UIControlStateNormal)];
    
    CGFloat w = contentRect.size.width - image.size.width;
    return  CGRectMake(image.size.width, contentRect.origin.y, w, contentRect.size.height);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    UIImage * image = [self imageForState:(UIControlStateNormal)];

    return CGRectMake(0, contentRect.origin.y, image.size.width, image.size.height);
}
- (void)setHighlighted:(BOOL)highlighted {}
@end
