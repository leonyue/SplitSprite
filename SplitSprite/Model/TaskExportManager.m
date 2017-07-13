//
//  TaskExportManager.m
//  SplitSprite
//
//  Created by dj.yue on 2017/7/12.
//  Copyright © 2017年 dj.yue. All rights reserved.
//

#import "TaskExportManager.h"
#import "Taskit.h"
#import "Task.h"
#import "NSString+MovieTimeSupport.h"
static TaskExportManager *_sharedManager;

@interface TaskExportManager ()

@property (atomic, assign) BOOL isExporting;
@property (nonatomic, strong) NSMutableArray<Task *> *tasks;

@end;

@implementation TaskExportManager

+ (TaskExportManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[TaskExportManager alloc] init];
        _sharedManager.tasks = [NSMutableArray new];
    });
    return _sharedManager;
}


- (BOOL)addTasks:(NSArray<Task *> *)tasks {
    if (self.tasks.count != 0) {
        return NO;
    }
    [self.tasks addObjectsFromArray:tasks];
    [self downloadTask];
    return YES;
}

- (void)downloadTask {
    Task *vTask = [self.tasks firstObject];
    if (vTask == nil) {
        return;
    }
    [self.tasks removeObjectAtIndex:0];
    
    NSString *exe = [[NSBundle mainBundle] pathForResource:@"ffmpeg" ofType:nil];
    Taskit *task = [Taskit task];
    task.launchPath = exe;
    [task.arguments addObject:@"-i"];
    [task.arguments addObject:vTask.url.resourceSpecifier];
    [task.arguments addObject:@"-ss"];
    NSString *ss = [NSString stringWithCMTime:vTask.begin];
    [task.arguments addObject:ss];
    [task.arguments addObject:@"-to"];
    NSString *tt = [NSString stringWithCMTime:vTask.end];
    [task.arguments addObject:tt];
    [task.arguments addObject:@"-vcodec"];
    [task.arguments addObject:@"copy"];
    [task.arguments addObject:@"-acodec"];
    [task.arguments addObject:@"copy"];
    
    NSString *outputPath = [vTask.url.resourceSpecifier stringByDeletingPathExtension];
    outputPath = [outputPath stringByAppendingString:@"_"];
    outputPath = [outputPath stringByAppendingString:[ss stringByReplacingOccurrencesOfString:@":" withString:@""]];
    outputPath = [outputPath stringByAppendingString:@"_"];
    outputPath = [outputPath stringByAppendingString:[tt stringByReplacingOccurrencesOfString:@":" withString:@""]];
    outputPath = [outputPath stringByAppendingPathExtension:vTask.url.resourceSpecifier.pathExtension];
    
    [task.arguments addObject:outputPath];
    
    [task.arguments addObject:@"-y"];
    
    
    NSLog(@"task.argument:%@",task.arguments);
    NSLog(@"task.exe:%@",task.launchPath);
    __weak typeof(self) weakSelf = self;
    task.receivedOutputString = ^void(NSString *output) {
        NSLog(@"output*************%@", output);
    };
    task.receivedErrorString = ^(NSString *errString) {
        
        NSLog(@"error**************:%@",errString);
        [weakSelf downloadTask];
    };
    [task launch];
}

@end
