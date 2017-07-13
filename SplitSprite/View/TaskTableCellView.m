//
//  TaskTableCellView.m
//  SplitSprite
//
//  Created by dj.yue on 2017/7/13.
//  Copyright © 2017年 dj.yue. All rights reserved.
//

#import "TaskTableCellView.h"

@interface TaskTableCellView ()
@property (weak) IBOutlet NSImageView *imageV;

@end

@implementation TaskTableCellView


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    // Drawing code here.
}
- (IBAction)clickBtn:(id)sender {
    if (self.detailClick) {
        self.detailClick();
    }
}

@end
