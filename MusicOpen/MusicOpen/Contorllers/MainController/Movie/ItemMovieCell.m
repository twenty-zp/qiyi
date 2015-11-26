//
//  ItemMovieCell.m
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/9.
//  Copyright © 2015年 zp. All rights reserved.
//

#import "ItemMovieCell.h"

#import "UIImageView+ImageViewAddition.h"
#import "ItemName.h"

@interface ItemMovieCell ()
@property (weak, nonatomic) IBOutlet UIButton *playNum;

@end
@implementation ItemMovieCell
- (void)setItem:(ItemName *)item
{
    
    [_imgeView downloadImageWithURL:item.poster placeholderImage:nil completed:^(UIImage *image, NSError *error, NSURL *imageURL) {
        _imgeView.contentMode = UIViewContentModeScaleAspectFill;
    }];
    
    _movieName.text = item.name;
    
    [_playNum setTitle:[NSString stringWithFormat:@"播放:%@",item.playCount] forState:(UIControlStateNormal)];
    _item = item;
}
@end
