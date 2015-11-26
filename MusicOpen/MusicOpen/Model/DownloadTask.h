//
//  DownloadTask.h
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/18.
//  Copyright © 2015年 zp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadTask : NSObject
@property (nonatomic,strong)NSURLSessionDownloadTask *task;
@property (nonatomic,strong)NSProgress *progress;
@end
