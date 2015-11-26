
//
//  ItemName.m
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/9.
//  Copyright © 2015年 zp. All rights reserved.
//

#import "ItemName.h"

@implementation ItemName
+ (NSDictionary * )replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}
- (void)setView_count:(NSInteger)view_count
{
    if (view_count >1000000) {
     _view_count =   view_count/1000000;
     _playCount = [NSString stringWithFormat:@"%ldW",(long)_view_count];
        
    }else if(view_count > 100000)
    {
        _view_count =   view_count/100000;
         _playCount = [NSString stringWithFormat:@"%ldW",(long)_view_count];
       
    }else if (view_count > 10000) {
        _view_count = view_count /10000;
         _playCount = [NSString stringWithFormat:@"%ldW",(long)_view_count];
    }else
    {
    _playCount = [NSString stringWithFormat:@"%ld",(long)_view_count];
    }
}
@end
