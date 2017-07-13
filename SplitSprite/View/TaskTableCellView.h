//
//  TaskTableCellView.h
//  SplitSprite
//
//  Created by dj.yue on 2017/7/13.
//  Copyright © 2017年 dj.yue. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TaskTableCellView : NSTableCellView

@property (nonatomic, copy) void(^detailClick)() ;

@end
