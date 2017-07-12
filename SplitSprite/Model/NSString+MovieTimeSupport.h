//
//  NSString+MovieTimeSupport.h
//  YuneecApp
//
//  Created by dj.yue on 2017/3/10.
//  Copyright © 2017年 yuneec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface NSString (MovieTimeSupport)

/**
 视频时间转换成用于显示的时间

 @param time 时间
 @return 如42:30
 */
+ (instancetype)stringWithCMTime:(CMTime)time;

@end
