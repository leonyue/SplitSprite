//
//  WindowController.m
//  SplitSprite
//
//  Created by dj.yue on 2017/7/12.
//  Copyright © 2017年 dj.yue. All rights reserved.
//

#import "WindowController.h"

@interface WindowController ()

@end

@implementation WindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)dealloc {
    NSLog(@"dealloc");
}

- (IBAction)addTask:(id)sender {
    if (self.addClick) {
        self.addClick();
    }
}
- (IBAction)convertClick:(id)sender {
    if (self.convertClick) {
        self.convertClick();
    }
}
- (IBAction)startClick:(id)sender {
    if (self.startClick) {
        self.startClick();
    }
}
- (IBAction)endClick:(id)sender {
    if (self.endClick) {
        self.endClick();
    }
}
- (IBAction)minusClick:(id)sender {
    if (self.minusClick) {
        self.minusClick();
    }
}
- (IBAction)recycleClick:(id)sender {
    if (self.recycleClick) {
        self.recycleClick();
    }
}

@end
