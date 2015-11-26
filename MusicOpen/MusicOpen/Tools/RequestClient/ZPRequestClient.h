//
//  ZPRequestClient.h
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/6.
//  Copyright © 2015年 zp. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DownloadTask;
typedef NS_ENUM(NSInteger,NetworkMethod)
{
    GET ,
    POST ,
    PUST,
    DELETE,
};

@interface ZPRequestClient : NSObject
+ (instancetype)shareClient;

- (void)requestJsonDataWithPath:(NSString *)path withParams:(NSDictionary *)params withMethodType:(NSInteger)NetworkMethod andBlock:(void(^)(id data,NSError * error))block;
@end


@interface ZPSessionManager : NSObject


+ (instancetype)shareSessionManager;

- (DownloadTask *)downloadUrl:(NSString * )urlStr progress:(NSProgress *)progress  complete:(void (^)(NSURLResponse *))block error:(void (^)(NSError *))failed;

- (void)pause;
@end
