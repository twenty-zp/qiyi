//
//  UIImageView+ImageViewAddition.h
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/9.
//  Copyright © 2015年 zp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ImageViewAddition)

- (void)downloadImageWithURL:(NSString *)str placeholderImage:(UIImage *)image completed:(void(^)(UIImage *image,NSError *error,NSURL *imageURL))complete;
@end
