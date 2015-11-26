//
//  ViewController.h
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/4.
//  Copyright © 2015年 zp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShowCategory;
@interface ViewController : UIViewController


@property (nonatomic,strong)ShowCategory * category;
@property (nonatomic,strong,readonly)UIView * contentView;

- (void)startLoadingAnimation;
- (void)stopLoadingAnimation;
@end

