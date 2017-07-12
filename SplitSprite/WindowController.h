//
//  WindowController.h
//  SplitSprite
//
//  Created by dj.yue on 2017/7/12.
//  Copyright © 2017年 dj.yue. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef void(^BtnClick)();

@interface WindowController : NSWindowController

@property (nonatomic, copy) BtnClick addClick;
@property (nonatomic, copy) BtnClick convertClick;

@end
