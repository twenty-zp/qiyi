//
//  Common.h
//  MusicOpen
//
//  Created by iLogiEMAC on 15/11/6.
//  Copyright © 2015年 zp. All rights reserved.
//



#define kYouKuClientID @"5675ceef36115e89"

#define kYouKuClientSecret @"0a7d3c20990a270cb30cd93863279a62"

#define WS(weakSelf)  __weak typeof(self)weakSelf = self;

#ifdef DEBUG
#define DDLog(s, ...) NSLog(@"%s(%d): %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#else
#define DDLog(s, ...)
#endif



#define kDockHeight 55


#import "RDVTabBarController.h"
#import "AFNetworking.h"
#import "MJExtension.h"


#define MAS_SHORTHAND
#import "Masonry.h"

