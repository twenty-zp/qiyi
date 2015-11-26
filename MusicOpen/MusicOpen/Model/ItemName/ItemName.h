//
//  ItemName.h
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/9.
//  Copyright © 2015年 zp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemName : NSObject
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *link;
@property (nonatomic,copy)NSString *play_link;
@property (nonatomic,copy)NSString *last_play_link;
@property (nonatomic,copy)NSString *poster;
@property (nonatomic,copy)NSString *thumbnail;

@property (nonatomic,assign)NSInteger episode_count; //总集数
@property (nonatomic,assign)NSInteger episode_updated; //更新至
@property (nonatomic,assign)NSInteger view_count; //总播放数

@property (nonatomic,copy)NSString * playCount; //已处理过的播放总数

@property (nonatomic,assign)CGFloat score; //评分

@property (nonatomic,assign)NSInteger paid; //是否付费 0 否 1是


@end
