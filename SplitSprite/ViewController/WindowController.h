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
@property (nonatomic, copy) BtnClick startClick;
@property (nonatomic, copy) BtnClick endClick;
@property (nonatomic, copy) BtnClick minusClick;
@property (nonatomic, copy) BtnClick recycleClick;

@end
