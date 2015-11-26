//
//  ShowCategory.h
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/6.
//  Copyright © 2015年 zp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowCategory : NSObject
@property (nonatomic,strong)NSString * term;//视频分类标识
@property (nonatomic,strong)NSString * label;//视频分类显示名称
@property (nonatomic,strong)NSString * lang; //语言

@property (nonatomic,strong)NSArray * genre;
@end
