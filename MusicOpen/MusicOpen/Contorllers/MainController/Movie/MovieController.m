//
//  MovieController.m
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/9.
//  Copyright © 2015年 zp. All rights reserved.
//

#define kWidth 122
#define kHeight (kWidth * 2)

#import "MovieController.h"
#import "ShowCategory.h"
#import "ZPRequestClient.h"
#import "ItemName.h"


#import "ItemMovieCell.h"
#import "MovieDetailController.h"


@import CoreSpotlight;
@interface MovieController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray * array;
    UICollectionView * collection;
    
    NSMutableArray * searchItems;
}
@end

@implementation MovieController
- (void)viewDidLoad
{
    [super viewDidLoad];
 
    array = [NSMutableArray array];
    searchItems = [NSMutableArray array];
    [self addContentView];
    [self requestData];
    
}
- (void)addContentView
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOrientation) name:UIDeviceOrientationDidChangeNotification object:nil];
    UICollectionViewFlowLayout *layout =  [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollPositionCenteredVertically;
    layout.minimumInteritemSpacing = 1.0f;
    layout.minimumLineSpacing = 1.0f;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);
//    NSInteger num = 0;
//    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)) {
//            num = 3;
//    }else
//    {
//        num = 5;
//    }
//    CGFloat w = (self.view.frame.size.width - 1.0*(num+1))/num;
    layout.itemSize = CGSizeMake(kWidth, kHeight);
    collection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    collection.backgroundColor = [UIColor whiteColor];
    collection.delegate = self;
    collection.dataSource = self;
    [self.contentView addSubview:collection];
   
    [collection registerNib:[UINib nibWithNibName:@"ItemMovieCell" bundle:nil] forCellWithReuseIdentifier:@"Identifier"];
    WS(ws);
    [collection makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(ws.view);
    }];
}
- (void)changeOrientation
{
    [collection reloadData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str = @"Identifier";
    ItemMovieCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:str forIndexPath:indexPath];
    cell.item = array[indexPath.row];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    ItemName * item = array[indexPath.row];
    MovieDetailController *player = [[MovieDetailController alloc]init];
    player.playlink = @"http://v.cctv.com/flash/mp4video1/huangjinqiangdang/2010/01/02/huangjinqiangdang_h264818000nero_aac32000_20100102_1262437187617-1.mp4"   ;//http://v.cctv.com/flash/mp4video1/huangjinqiangdang/2010/01/02/huangjinqiangdang_h264818000nero_aac32000_20100102_1262437187617-1.mp4
    //http://pl.youku.com/playlist/m3u8?ids=%7B%22a1%22%3A%22XMTM3ODA5MjU2MA%3D%3D_flv%22%2C%22a2%22%3A%22XMTM2MTQwNzIwNA%3D%3D_flv%22%2C%22a3%22%3A%22XMTM3NjY3NzAyNA%3D%3D_flv%22%2C%22a4%22%3A%22XMTM3NzYzNjc1Mg%3D%3D_flv%22%2C%22a5%22%3A%22XMTM2MTM3OTk5Mg%3D%3D_flv%22%7D&ts=1447223936663&sid=1448671168043&ctype=21&token=8645&ev=1&oip=2130706433&ep=1acd7TNVFIvZiNJoxhpMs8AoagkMYFOXzOQHX9VUUdL4EDX%2BptNVWXl%2BpgRVoG5juNxlS4JTMunMcEQ8blJRW%2BQwe6dUPBTjiJ8vEHNtjxgM3QMLtIzqXXD16Tpm5ygHWwjXUYxq%2B07ZMSBAxuU5u15JQ%3D%3D (AVPlayer 不支持m3u8格式,不支持swf，)
    
    
    [self.navigationController pushViewController:player animated:YES];
}

#pragma mark 随机颜色
- (UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}


#pragma mark 
- (void)requestData
{
    [self startLoadingAnimation];
    NSString * path  = [NSString stringWithFormat:@"shows/by_category.json\?client_id=%@&&category=%@",kYouKuClientID,self.category.label];
    [[ZPRequestClient shareClient]requestJsonDataWithPath:path withParams:nil withMethodType:GET andBlock:^(id data, NSError *error) {
          [self stopLoadingAnimation];
        if (data && data != nil && [data class] != [NSNull null]) {
            NSArray * shows = [data objectForKey:@"shows"];
            if (shows.count) {
                for (NSDictionary * dic in shows) {
                    ItemName * item = [ItemName objectWithKeyValues:dic];
                    
                    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_8_3) {
                        CSSearchableItemAttributeSet * set = [[CSSearchableItemAttributeSet alloc]initWithItemContentType:@"views"];
                        set.title = item.name;
                        set.contentDescription = [NSString stringWithFormat:@"评分:%f",item.score];
                        set.thumbnailURL = [NSURL URLWithString:item.thumbnail];
                        CSSearchableItem * searchItem = [[CSSearchableItem alloc]initWithUniqueIdentifier:item.ID domainIdentifier:@"com.ios9Day.searchApi" attributeSet:set];
                        [searchItems addObject:searchItem];
                    }
                    [array addObject:item];
                }
                
             [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:searchItems completionHandler:^(NSError * _Nullable error) {
                 if (error) {
                     DDLog(@"%@",error.description);
                 }
             }];
                
                    [collection reloadData];

            }
            
        }
    }];
}
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
@end
