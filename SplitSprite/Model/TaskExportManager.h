//
//  TaskExportManager.h
//  SplitSprite
//
//  Created by dj.yue on 2017/7/12.
//  Copyright © 2017年 dj.yue. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Task;
@interface TaskExportManager : NSObject

+ (TaskExportManager *)sharedManager;

- (BOOL)addTasks:(NSArray<Task *> *)tasks;

@end
