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
}

- (void)viewDidAppear {
    [super viewDidAppear];
    [self setUpWindowToolBarAction];
}

// MARK: private
- (void)updatePlayerItem {
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:self.edittingTask.url];
    [self.player replaceCurrentItemWithPlayerItem:item];
    [self.player play];
}

- (void)setUpWindowToolBarAction {
    __weak typeof(self) weakSelf = self;
    void (^startClick)() = ^(){
        [weakSelf startClick];
    };
    void (^endClick)() = ^(){
        [weakSelf endClick];
    };
    [self.view.window.windowController setValue:[startClick copy] forKey:@"startClick"];
    [self.view.window.windowController setValue:[endClick copy] forKey:@"endClick"];
}

- (void)startClick {
    CMTime playerCurrent = self.player.currentTime;
    self.edittingTask.begin = playerCurrent;
}

- (void)endClick {
    CMTime playerCurrent = self.player.currentTime;
    self.edittingTask.end = playerCurrent;
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
