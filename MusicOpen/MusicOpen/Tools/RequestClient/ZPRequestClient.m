//
//  ZPRequestClient.m
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/6.
//  Copyright © 2015年 zp. All rights reserved.
//

#import "ZPRequestClient.h"

static ZPRequestClient * client = nil;
static ZPRequestClient * session = nil;
@interface ZPRequestClient ()
{
    AFHTTPRequestOperationManager * operation;
}
@end
@implementation ZPRequestClient
+ (instancetype)shareClient
{
    if (!client) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            client = [[self alloc]init];
        });
    }
    return client;
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (!client) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            client = [super allocWithZone:zone];
        });
    }
    return client;
}
- (instancetype)init
{
    self = [super init];
    if (self) {

        operation = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:@"https://openapi.youku.com/v2"]];
        operation.requestSerializer =  [AFJSONRequestSerializer serializer];
//        [operation.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

         operation.requestSerializer.timeoutInterval = 60 ;
        
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json",@"multipart/form-data", nil];
        
      

    }
    return self;
}
- (void)requestJsonDataWithPath:(NSString *)path withParams:(NSDictionary *)params withMethodType:(NSInteger)NetworkMethod andBlock:(void (^)(id, NSError *))block
{
   
    if (NSFoundationVersionNumber>NSFoundationVersionNumber_iOS_7_0) {
        path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }else
    {
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    DDLog(@"%@",path);
    switch (NetworkMethod) {
        case GET:
        {
            [operation GET:path parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                                id error = [self handleResponse:responseObject];
                if (error) {
                    block(nil,error);
                }else
                {
                    block(responseObject,nil);
                }
               
            } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                block(nil,error);
            }];
        }
            break;
        case POST:
        {
            [operation POST:path parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                id error = [self handleResponse:responseObject];
                if (error) {
                    block(nil,error);
                }else
                {
                    block(responseObject,nil);
                }
            } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                block(nil,error);
            }];
            
        }
            break;

        default:
            break;
    }
}


- (id)handleResponse:(id)responeObject
{
    NSError *error = nil;
    return error;
}
@end


#import "DownloadTask.h"
static ZPSessionManager  *manager = nil;
@interface ZPSessionManager ()
{
    AFURLSessionManager * sessionManager;
    NSMutableDictionary * daskDic;
}
@end

@implementation ZPSessionManager

+ (instancetype)shareSessionManager
{
    if (!manager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [[self alloc]init];
           
        });
    }
    return manager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
         daskDic = [NSMutableDictionary dictionary];
        NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
       sessionManager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];

    }
    return self;
}
- (void)pause
{
    NSLog(@"---%@",[sessionManager downloadTasks]);
   
  
}
- (DownloadTask *)downloadUrl:(NSString * )urlStr progress:(NSProgress *)progress complete:(void (^)(NSURLResponse *))block error:(void (^)(NSError *))failed
{
    
   
    NSURL * url = [NSURL URLWithString:urlStr];
    if ([daskDic objectForKey:[urlStr stringByDeletingPathExtension]])
    {
        DownloadTask * dtask  = [daskDic objectForKey:[urlStr stringByDeletingPathExtension]];
        switch (dtask.task.state) {
            case NSURLSessionTaskStateSuspended:
            {
                [dtask.task resume];
            }
                break;
            case NSURLSessionTaskStateRunning :
            {
                [dtask.task suspend];
            }
                break;
            default:
                break;
        }
    }else
    {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];

        progress.cancellable = YES;
        progress.pausable = YES ;
        
        NSURLSessionDownloadTask * downtask = [sessionManager downloadTaskWithRequest:request progress:&progress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            
            [progress removeObserver:self forKeyPath:@"fractionCompleted"];
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            failed(error);
            [progress removeObserver:self forKeyPath:@"fractionCompleted"];
        } ];
        [downtask resume];
        DownloadTask * dtask = [[DownloadTask alloc]init];
        dtask.task = downtask;
        dtask.progress = progress;
        
        [daskDic setObject:dtask forKey:[urlStr stringByDeletingPathExtension]];
        
    }
    
    return [daskDic objectForKey:[urlStr stringByDeletingPathExtension]];
}

@end
