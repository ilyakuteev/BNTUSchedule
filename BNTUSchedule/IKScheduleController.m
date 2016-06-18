//
//  IKScheduleController.m
//  BNTUSchedule
//
//  Created by Илья Кутеев on 27.03.16.
//  Copyright © 2016 Илья Кутеев. All rights reserved.
//

#import "IKScheduleController.h"
#import "IKAddClassController.h"
#import "IKClassCell.h"
#import "IKWeekdayCell.h"
#import "IKNoClassesCell.h"
#import "IKSchedule.h"
#import "REMenu.h"


@interface IKScheduleController () <REMenuDelegate>
@property (nonatomic, weak) UIView *topView;
@property (nonatomic) REMenu *menu;
@property (nonatomic) NSInteger week;
@property (nonatomic) NSArray<NSMutableArray<IKClass *> *> *days;
@property (nonatomic) NSString *groupName;
@end


@implementation IKScheduleController

-(instancetype)initWithType:(IKScheduleType)type
{
    self = [super init];
    if (!self) return nil;
    
    _type = type;
    
    return self;
}

#pragma mark - View Lifecycle

-(void)loadView
{
    [super loadView];
    
    CGFloat topViewHeight = 40;
    
    self.tableView.contentInset = UIEdgeInsetsMake(topViewHeight, 0, 0, 0);
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, -topViewHeight, CGRectGetWidth(self.view.frame), topViewHeight)];
    topView.backgroundColor = [UIColor whiteColor];
    topView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.tableView addSubview:topView];
    self.topView = topView;
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"1 неделя", @"2 неделя"]];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.frame = CGRectInset(topView.bounds, 8, 6);
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [segmentedControl addTarget:self action:@selector(changeWeek:) forControlEvents:UIControlEventValueChanged];
    [topView addSubview:segmentedControl];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [titleButton setTitle:self.type == IKScheduleTypeClasses ? @"РАСПИСАНИЕ " : @"ЭКЗАМЕНЫ " forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    titleButton.tintColor = [UIColor whiteColor];
    [titleButton setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [titleButton sizeToFit];
    titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, -titleButton.imageView.frame.size.width, 0, titleButton.imageView.frame.size.width);
    titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, titleButton.titleLabel.frame.size.width, 0, -titleButton.titleLabel.frame.size.width);
    [titleButton addTarget:self action:@selector(openMenu:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleButton;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerClass:[IKClassCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[IKWeekdayCell class] forCellReuseIdentifier:@"weekdayCell"];
    [self.tableView registerClass:[IKNoClassesCell class] forCellReuseIdentifier:@"noClassesCell"];
    
    [self fetch];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextObjectsDidChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:IKSchedule.managedObjectContext];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadAllData];
}

-(void)reloadAllData
{
    NSArray *groups = [[NSUserDefaults standardUserDefaults] arrayForKey:@"groups"];
    NSMutableArray *items = [NSMutableArray array];
    for (NSString *group in groups) {
        REMenuItem *item = [[REMenuItem alloc] initWithTitle:group image:nil highlightedImage:nil action:^(REMenuItem *item) {
            self.groupName = group;
            [self fetch];
            [self.tableView reloadData];
        }];
        [self setupItem:item];
        [items addObject:item];
    }
    if (![groups containsObject:self.groupName] || !self.groupName.length) {
        self.groupName = groups.firstObject;
    }
    self.menu.items = items;
    
    [self fetch];
    [self.tableView reloadData];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.topView.frame = CGRectMake(0, scrollView.contentOffset.y/*-self.topView.frame.size.height*/,
                                    self.topView.frame.size.width, self.topView.frame.size.height);
}

-(void)changeWeek:(UISegmentedControl *)segmentedControl
{
    self.week = segmentedControl.selectedSegmentIndex;
    [self fetch];
    [self.tableView reloadData];
}

-(REMenu *)menu
{
    if (!_menu) {
        
        _menu = [[REMenu alloc] init];
        _menu.separatorColor = [UIColor colorWithWhite:1.0 alpha:0.6];
        _menu.highlightedSeparatorColor = [UIColor whiteColor];
        _menu.textShadowColor = [UIColor clearColor];
        _menu.subtitleTextShadowColor = [UIColor clearColor];
        _menu.separatorHeight = 0.5;
        _menu.imageOffset = CGSizeMake(5, -1);
        _menu.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.7f];
        _menu.waitUntilAnimationIsComplete = NO;
        _menu.liveBlur = YES;
        _menu.liveBlurBackgroundStyle = REMenuLiveBackgroundStyleLight;
        _menu.borderWidth = 0.0;
        _menu.delegate = self;
    }
    return _menu;
}

-(void)setupItem:(REMenuItem *)item
{
    item.backgroundColor = [UIColor clearColor];
    item.highlightedBackgroundColor = [UIColor clearColor];
    item.textColor = item.highlightedTextColor = [UIColor blackColor];
    item.subtitleTextColor = [UIColor whiteColor];
    item.subtitleHighlightedTextColor = [UIColor whiteColor];
    item.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    item.highlightedTextShadowOffset = CGSizeMake(0, 0);
    item.textShadowOffset = CGSizeMake(0, 0);
    item.textShadowColor = [UIColor clearColor];
    item.highlightedTextShadowColor  = [UIColor clearColor];
    item.highlightedBackgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.05 alpha:1.0];
}

-(void)openMenu:(UIButton *)sender
{
    if (self.menu.isOpen) {
        [self.menu close];
    } else {
        [self.menu showFromNavigationController:self.navigationController];
    }
}

#pragma mark - REMenuDelegate

-(void)willCloseMenu:(REMenu *)menu
{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    [titleButton setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
}

-(void)willOpenMenu:(REMenu *)menu
{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    [titleButton setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
}

#pragma mark - Fetch Requests

-(void)fetch
{
    NSMutableArray *days = [NSMutableArray array];
    for (int i = 0; i < self.tableView.numberOfSections; i++) {
        NSFetchRequest *fetchRequest = [self fetchRequestForSection:i];
        [days addObject:[IKSchedule.managedObjectContext executeFetchRequest:fetchRequest error:nil].mutableCopy];
    }
    self.days = days.copy;
}

-(NSFetchRequest *)fetchRequestForSection:(NSInteger)section
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"IKClass"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES]];

    NSInteger subgroup = [[NSUserDefaults standardUserDefaults] integerForKey:@"subgroup"];
    
    if (self.type == IKScheduleTypeClasses) {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"group == %@ && week == %d && weekday == %d && type_ < 3 && (subgroup_ == 2 || subgroup_ == %d)", self.groupName, self.week, section, subgroup];
    } else {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"group == %@ && week == %d && weekday == %d && type_ >= 3 && (subgroup_ == 2 || subgroup_ == %d)", self.groupName, self.week, section, subgroup];
    }
    return fetchRequest;
}

#pragma mark - NSManagedObjectContextObjectsDidChangeNotification

-(void)managedObjectContextObjectsDidChange:(NSNotification *)notification
{
    [(NSManagedObjectContext *)notification.object save:nil];
    
    NSArray *inserted = notification.userInfo[NSInsertedObjectsKey];
    NSArray *deleted = notification.userInfo[NSDeletedObjectsKey];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView beginUpdates];
        
        for (NSManagedObject *managedobject in inserted) {
            if ([managedobject isKindOfClass:[IKClass class]]) {
                IKClass *class = (IKClass *)managedobject;
                if (!([class.group isEqualToString:self.groupName] && class.week.integerValue == self.week)) continue;
                if (self.type == IKScheduleTypeClasses) {
                    if (class.type_.integerValue >= 3) continue;
                } else {
                    if (class.type_.integerValue < 3) continue;
                }
                
                NSFetchRequest *fetchRequest = [self fetchRequestForSection:class.weekday.integerValue];
                NSArray *objects = [IKSchedule.managedObjectContext executeFetchRequest:fetchRequest error:nil];
                
                NSInteger row = [objects indexOfObject:class];
                NSInteger section = class.weekday.integerValue;
                
                [self.days[section] insertObject:class atIndex:row];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row+1 inSection:section];
                if (self.days[section].count == 1) {
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                } else {
                    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                }
                
            }
        }
        
        for (NSManagedObject *managedobject in deleted) {
            if ([managedobject isKindOfClass:[IKClass class]]) {
                IKClass *class = (IKClass *)managedobject;
                
                NSInteger section = class.weekday.integerValue;
                NSInteger row = [self.days[section] indexOfObject:class];
                
                [self.days[section] removeObject:class];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row+1 inSection:section];
                if (self.days[section].count == 0) {
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                } else {
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                }
            }
        }
        [self.tableView endUpdates];
    });
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + MAX(self.days[section].count, 1);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        IKWeekdayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weekdayCell"];
        cell.weekday = indexPath.section;
        return cell;
        
    } else if (self.days[indexPath.section].count) {
        
        IKClassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.ik_class = self.days[indexPath.section][indexPath.row-1];
        return cell;
        
    } else {
        return [tableView dequeueReusableCellWithIdentifier:@"noClassesCell"];
    }
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return [IKWeekdayCell prefferedHeight];
    } else {
        return 66;
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return UITableViewCellEditingStyleInsert;
    } else if (self.days[indexPath.section].count) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        
        IKAddClassController *addClassController = [[IKAddClassController alloc] init];
        addClassController.weekday = indexPath.section;
        addClassController.week = self.week;
        addClassController.group = self.groupName;
        addClassController.scheduleType = self.type;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addClassController];
        [self.navigationController presentViewController:navigationController animated:YES completion:nil];
        
    } else {
        
        IKClass *classToDelete = self.days[indexPath.section][indexPath.row-1];
        [IKSchedule.managedObjectContext deleteObject:classToDelete];
        [IKSchedule save];
        
    }
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row != 0 && self.days[indexPath.section].count;
}

@end
