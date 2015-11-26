//
//  ZPPlayerViewController.h
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/9.
//  Copyright © 2015年 zp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPPlayerViewController : UIView
//@property (nonatomic,strong,readonly)UIView     *topBar;

@property (nonatomic,strong,readonly)UIView     *bottomBar;

@property (nonatomic,strong,readonly)UIButton   *playerBtn;
@property (nonatomic,strong,readonly)UISlider   *progressSlider;

@property (nonatomic,strong,readonly)UIButton   *fullScreenBtn;

@property (nonatomic,strong,readonly)UILabel    *timeLabel;

@property (nonatomic,strong,readonly)UIButton   *download;

@property (nonatomic,strong,readonly)UIButton   *backButton;
@property (nonatomic,strong,readonly)UIButton    *lockScreenBtn;
@property (nonatomic,strong,readonly)UIActivityIndicatorView * indicatorView;

- (void)startAnimation;
- (void)stopAnimation;

//- (void)autoFadeOutControlBar;
//- (void)cancelAutoFadeOutControlBar;
- (void)animateHide;
- (void)animateShow;
@end

@protocol ZPPlayerViewControllerDelegate <NSObject>

 //向左清扫
- (void)playerViewControllerWithSwipeLeft:(ZPPlayerViewController *)vc ;
//向右清扫
- (void)playerViewControllerWithSwipeRight:(ZPPlayerViewController *)vc ;

@end