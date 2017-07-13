//
//  ViewController.m
//  SplitSprite
//
//  Created by dj.yue on 2017/7/11.
//  Copyright © 2017年 dj.yue. All rights reserved.
//

#import "ViewController.h"
#import "Task.h"
#import "NSString+MovieTimeSupport.h"
#import "AdjustViewController.h"
#import "TaskExportManager.h"

static NSString *kNoColumnIdentifier   = @"NoColumn";
static NSString *kNormalCellIdentifier = @"normalCell";
static NSString *kTaskColumnIdentifier = @"taskColumn";
static NSString *kTaskCellIdentifier   = @"taskCell";
static NSString *kGotoSettingSegueIdentifier = @"gotoSettingSegue";

@interface ViewController ()<NSTableViewDelegate,NSTableViewDataSource>

@property (nonatomic, strong) NSMutableArray *tasks;

@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTextField *informationNalTextField;
@property (weak) IBOutlet NSView *footerView;

@property (nonatomic, weak) Task *currentTask;

@property (nonatomic, assign) BOOL shouldPerformSegue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tasks = [NSMutableArray new];
    [self setUpObserver];
    [self setUp];
}

- (void)viewDidAppear {
    [super viewDidAppear];
    [self setUpWindowToolBarAction];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kGotoSettingSegueIdentifier]) {
        AdjustViewController *adj = (AdjustViewController *)((NSWindowController *)(segue.destinationController)).contentViewController;
        adj.edittingTask = self.currentTask;
    }
}

//- (BOOL)shouldPerformSegueWithIdentifier:(NSStoryboardSegueIdentifier)identifier sender:(id)sender {
//    if ([identifier isEqualToString:kGotoSettingSegueIdentifier]) {
//        return self.shouldPerformSegue;
//    }
//    return YES;
//}

// MARK: IBAction

- (void)setUp {
    NSMenuItem *edit = [[NSApplication sharedApplication].menu itemWithTitle:@"Edit"];
    NSMenu *editMenu = edit.submenu;
    NSMenuItem *delete = [editMenu itemWithTitle:@"Delete"];
    [delete setAction:@selector(deleteBtnClick)];
}

- (IBAction)deleteBtnClick {
    NSIndexSet  *indexSet = self.tableView.selectedRowIndexes;
    [self.tasks removeObjectsAtIndexes:indexSet];
    [self.tableView reloadData];
}


// MARK: private

- (void)setUpObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotTaskChangeNotif:) name:taskChangedNotif object:nil];
}

- (void)gotTaskChangeNotif:(NSNotification *)notif {
    NSUInteger index = [self.tasks indexOfObject:notif.object];
    if (index != NSNotFound) {
        [self.tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:index]
                                  columnIndexes:[NSIndexSet indexSetWithIndex:1]];
    }
}

- (void)setUpWindowToolBarAction {
    __weak typeof(self) weakSelf = self;
    void (^addClick)() = ^(){
        [weakSelf addClick];
    };
    void (^convertClick)() = ^(){
        [weakSelf convertClick];
    };
    [self.view.window.windowController setValue:[addClick copy] forKey:@"addClick"];
    [self.view.window.windowController setValue:[convertClick copy] forKey:@"convertClick"];
}

- (void)addClick {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.allowsMultipleSelection = YES;
    __weak typeof(self) weakSelf = self;
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            NSMutableArray *invalidTasks = [NSMutableArray new];
            [panel.URLs enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                Task *task = [[Task alloc] initWithFileUrl:obj];
                if (task != nil) {
                    [weakSelf.tasks addObject:task];
                } else {
                    [invalidTasks addObject:obj];
                }
            }];
            [weakSelf.tableView reloadData];
            if (invalidTasks.count != 0) {
                NSAttributedString *attribute = weakSelf.informationNalTextField.attributedStringValue;
                NSMutableAttributedString *mu = [[NSMutableAttributedString alloc]
                                                 initWithString:[NSString stringWithFormat:@"Add task fail:%@",
                                                                 [invalidTasks componentsJoinedByString:@"\n                     "]
                                                                 ]
                                                 attributes:@{
                                                              NSForegroundColorAttributeName:[NSColor redColor]
                                                              }
                                                 ];
                [mu appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
                [mu appendAttributedString:attribute];
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.informationNalTextField.attributedStringValue = mu;
                });
            }
        }
    }];
}

- (void)convertClick {
    [[TaskExportManager sharedManager] addTasks:self.tasks];
}

// MARK: TableView DataSource & Delegate

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    self.currentTask = [self.tasks objectAtIndex:row];
    return YES;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.tasks.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if ([tableColumn.identifier isEqualToString:kNoColumnIdentifier]) {
        NSView *normal = [tableView makeViewWithIdentifier:kNormalCellIdentifier owner:self];
        NSTableCellView *cell = (NSTableCellView *)normal;
        cell.textField.stringValue = [NSString stringWithFormat:@"%ld.",row];
        return normal;
    }
    if ([tableColumn.identifier isEqualToString:kTaskColumnIdentifier]) {
        NSView *taskCell = [tableView makeViewWithIdentifier:kTaskCellIdentifier owner:self];
        
        NSButton *imageButton = [taskCell viewWithTag:1];
        NSTextField *textField = [taskCell viewWithTag:2];
        Task *task = self.tasks[row];
        __weak typeof(self) weakSelf = self;
        void(^detailClick)() = ^{
            weakSelf.currentTask = task;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf performSegueWithIdentifier:kGotoSettingSegueIdentifier sender:nil];
            });
        };
        [taskCell setValue:[detailClick copy] forKey:@"detailClick"];
        dispatch_async(dispatch_get_main_queue(), ^{
            textField.attributedStringValue = [[NSAttributedString alloc]
                                               initWithString:[NSString stringWithFormat:
                                                               @"     %@\n     %@\n     %@  ->  %@",
                                                               task.url,
                                                               [NSString stringWithCMTime:task.duration],
                                                               [NSString stringWithCMTime:task.begin],
                                                               [NSString stringWithCMTime:task.end]
                                                               ]
                                               attributes:nil
                                               ];
        });
        [task.generator generateCGImagesAsynchronouslyForTimes:@[[NSValue valueWithCMTime:kCMTimeZero]] completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
            CGImageRef icopy = CGImageCreateCopy(image);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSImage *imageNS = [[NSImage alloc] initWithCGImage:icopy size:imageButton.bounds.size];
                imageButton.image = imageNS;
                CGImageRelease(icopy);
            });
        }];
        return taskCell;
    }
    return nil;

}

// MARK: lazilization
- (NSMutableArray *)tasks {
    if (_tasks == nil) {
        _tasks = [NSMutableArray new];
    }
    return _tasks;
}

@end
