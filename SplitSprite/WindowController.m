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

@end
