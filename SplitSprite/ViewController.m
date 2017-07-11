//
//  ViewController.m
//  SplitSprite
//
//  Created by dj.yue on 2017/7/11.
//  Copyright © 2017年 dj.yue. All rights reserved.
//

#import "ViewController.h"
#import "Task.h"

static NSString *kNoColumnIdentifier   = @"NoColumn";
static NSString *kNormalCellIdentifier = @"normalCell";
static NSString *kTaskColumnIdentifier = @"taskColumn";
static NSString *kTaskCellIdentifier   = @"taskCell";

@interface ViewController ()<NSTableViewDelegate,NSTableViewDataSource>

@property (nonatomic, strong) NSMutableArray *tasks;

@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSButton    *addButton;
@property (weak) IBOutlet NSTextField *informationNalTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.layer.contents = [NSImage imageNamed:@"beauty"];
    _tasks = [NSMutableArray new];
    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

// MARK: IBAction
- (IBAction)addButtonClick:(id)sender {
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
                NSMutableAttributedString *mu = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Add task fail:%@",[invalidTasks componentsJoinedByString:@","]] attributes:@{NSForegroundColorAttributeName:[NSColor redColor]}];
                [mu appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
                [mu appendAttributedString:attribute];
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.informationNalTextField.attributedStringValue = mu;
                });
            }
        }
    }];
}

// MARK: TableView DataSource & Delegate

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
