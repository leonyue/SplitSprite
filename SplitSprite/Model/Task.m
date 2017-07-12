//
//  Task.m
//  SplitSprite
//
//  Created by dj.yue on 2017/7/11.
//  Copyright © 2017年 dj.yue. All rights reserved.
//

#import "Task.h"

NSNotificationName taskChangedNotif = @"taskChangedNotif";

@implementation Task

- (id)initWithFileUrl:(NSURL *)url {
    self = [super init];
    if (self) {
        self.url = url;
        BOOL ret = [self setUp];
        if (!ret) {
            return nil;
        }
    }
    return self;
}

- (BOOL)setUp {
    AVAsset *asset  = [AVAsset assetWithURL:self.url];
    NSArray<AVAssetTrack *> *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if (tracks.count == 0) {
        return NO;
    }
    CMTime duration = asset.duration;
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    self.asset      = asset;
    self.begin      = kCMTimeZero;
    self.end        = duration;
    self.duration   = duration;
    self.generator   = generator;
    return YES;
}

// MARK: private
- (void)sendNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:taskChangedNotif object:self];
}

// MARK: Setter
- (void)setBegin:(CMTime)begin {
    if (CMTimeCompare(_begin, begin) != 0) {
        _begin = begin;
        [self sendNotification];
    }
}

- (void)setEnd:(CMTime)end {
    if (CMTimeCompare(_end, end) != 0) {
        _end = end;
        [self sendNotification];
    }
}

@end
