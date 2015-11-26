//
//  ItemMovieCell.h
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/9.
//  Copyright © 2015年 zp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ItemName;
@interface ItemMovieCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgeView;
@property (weak, nonatomic) IBOutlet UILabel *movieName;
@property (weak, nonatomic) ItemName * item;
@end
