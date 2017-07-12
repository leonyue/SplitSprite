//
//  AdjustViewController.m
//  SplitSprite
//
//  Created by dj.yue on 2017/7/12.
//  Copyright © 2017年 dj.yue. All rights reserved.
//

#import "AdjustViewController.h"
#import <AVKit/AVKit.h>
#import "Task.h"

@interface AdjustViewController ()

@property (weak) IBOutlet AVPlayerView *playerView;
@property (nonatomic, strong) AVPlayer *player;

@end

@implementation AdjustViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpPlayerObserver];
}

- (void)viewDidAppear {
    [super viewDidAppear];
    [self setUpWindowToolBarAction];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
            __weak typeof(self) weakSelf = self;
            [self.player seekToTime:self.edittingTask.begin completionHandler:^(BOOL finished) {
                [weakSelf.player play];
            }];
        }
    }
}

// MARK: private

- (void)setUpPlayerObserver {
    __weak typeof(self) weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(0.01, 300) queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
                                         usingBlock:^(CMTime time) {
                                             if (CMTimeCompare(weakSelf.edittingTask.end, time) <= 0) {
                                                 [weakSelf.player seekToTime:weakSelf.edittingTask.begin completionHandler:^(BOOL finished) {
                                                     [weakSelf.player play];
                                                 }];
                                             }
                                         }];
}

- (void)updatePlayerItem {
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:self.edittingTask.url];
    [self.player replaceCurrentItemWithPlayerItem:item];
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)setUpWindowToolBarAction {
    __weak typeof(self) weakSelf = self;
    void (^startClick)() = ^(){
        [weakSelf startClick];
    };
    void (^endClick)() = ^(){
        [weakSelf endClick];
    };
    void (^recycleClick)() = ^(){
        [weakSelf recycleClick];
    };
    [self.view.window.windowController setValue:[startClick copy] forKey:@"startClick"];
    [self.view.window.windowController setValue:[endClick copy] forKey:@"endClick"];
    [self.view.window.windowController setValue:[recycleClick copy] forKey:@"recycleClick"];
}

- (void)startClick {
    CMTime playerCurrent = self.player.currentTime;
    self.edittingTask.begin = playerCurrent;
}

- (void)endClick {
    CMTime playerCurrent = self.player.currentTime;
    self.edittingTask.end = playerCurrent;
}

- (void)recycleClick {
    self.edittingTask.begin = kCMTimeZero;
    self.edittingTask.end = self.edittingTask.duration;
}

// MARK: Setter
- (void)setEdittingTask:(Task *)edittingTask {
    if (_edittingTask != edittingTask) {
        _edittingTask = edittingTask;
        [self updatePlayerItem];
    }
}

// MARK: lazy
- (AVPlayer *)player {
    if (_player == nil) {
        _player = [AVPlayer playerWithPlayerItem:nil];
        self.playerView.player = _player;
    }
    return _player;
}
@end
