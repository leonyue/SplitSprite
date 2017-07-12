//
//  Task.h
//  SplitSprite
//
//  Created by dj.yue on 2017/7/11.
//  Copyright © 2017年 dj.yue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSNotificationName taskChangedNotif;

@interface Task : NSObject

@property (nonatomic, copy  ) NSURL                 *url;
@property (nonatomic, strong) AVAsset               *asset;
@property (nonatomic, assign) CMTime                begin;
@property (nonatomic, assign) CMTime                end;
@property (nonatomic, assign) CMTime                duration;
@property (nonatomic, strong) AVAssetImageGenerator *generator;

- (_Nullable id)initWithFileUrl:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
