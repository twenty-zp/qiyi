//
//  UIImageView+ImageViewAddition.m
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/9.
//  Copyright © 2015年 zp. All rights reserved.
//

#import "UIImageView+ImageViewAddition.h"
#import "UIImageView+WebCache.h"
@implementation UIImageView (ImageViewAddition)
- (void)downloadImageWithURL:(NSString *)str placeholderImage:(UIImage *)image completed:(void(^)(UIImage *image,NSError *error,NSURL *imageURL))completed
{
    NSURL * url = [NSURL URLWithString:str];
    [self sd_setImageWithURL:url placeholderImage:image options:SDWebImageRetryFailed |SDWebImageHighPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completed) {
            completed(image,error,imageURL);
        }
    }];
}

@end
