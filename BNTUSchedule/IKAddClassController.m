//
//  IKAddClassController.m
//  BNTUSchedule
//
//  Created by Илья Кутеев on 28.03.16.
//  Copyright © 2016 Илья Кутеев. All rights reserved.
//

#import "IKAddClassController.h"
#import "IKSchedule.h"
#import "IKTextFieldCell.h"
#import "IKAutocompleteCell.h"
#import "IKTimeCell.h"
#import "IKClass.h"


typedef NS_ENUM(NSUInteger, IKAddClassSection) {
    IKAddClassSectionTitle,
    IKAddClassSectionType,
    IKAddClassSectionTime,
    IKAddClassSectionGroup,
    IKAddClassSectionLecturer,
    IKAddClassSectionClassroom,
    IKAddClassSectionHousing
};

@interface IKAddClassController () <IKAutocompleteCellDelegate, IKTimeCellDelegate>

@property (nonatomic) NSString *classTitle;
@property (nonatomic) IKClassType classType;
@property (nonatomic) NSDate *classStartDate;
@property (nonatomic) NSDate *classEndDate;
@property (nonatomic) IKClassSubgroup classSubgroup;
@property (nonatomic) NSString *classLecturer;
@property (nonatomic) NSString *classClassroom;
@property (nonatomic) NSString *classHousing;

@property (nonatomic, weak) UITextField *titleField;
@property (nonatomic, weak) IKAutocompleteCell *autocompleteCell;

@end


@implementation IKAddClassController

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[IKTextFieldCell class] forCellReuseIdentifier:@"textFieldCell"];
    [self.tableView registerClass:[IKTimeCell class] forCellReuseIdentifier:@"timeCell"];
    [self.tableView registerClass:[IKAutocompleteCell class] forCellReuseIdentifier:@"autocompleteCell"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

-(void)setTitleField:(UITextField *)titleField
{
    _titleField = titleField;
    self.autocompleteCell.textField = _titleField;
}

-(void)updateTime
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:IKAddClassSectionTime];
    IKTimeCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.classStartDate = cell.startDate;
    self.classEndDate = cell.endDate;
}

-(void)titleChanged:(UITextField *)textField
{
    self.classTitle = textField.text;
    self.navigationItem.rightBarButtonItem.enabled = textField.text.length ? YES : NO;
}

-(void)lecturerChanged:(UITextField *)textField
{
    self.classLecturer = textField.text;
}

-(void)classroomChanged:(UITextField *)textField
{
    self.classClassroom = textField.text;
}

-(void)housingChanged:(UITextField *)textField
{
    self.classHousing = textField.text;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == IKAddClassSectionTitle) {
        return 2;
    } else if (section == IKAddClassSectionType || section == IKAddClassSectionGroup) {
        return 3;
    } else {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == IKAddClassSectionTitle && indexPath.row == 0) {
        
        IKTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textFieldCell"];
        cell.titleLabel.text = @"НАЗВАНИЕ:";
        cell.textField.text = self.classTitle;
        self.titleField = cell.textField;
        [cell.textField addTarget:self action:@selector(titleChanged:) forControlEvents:UIControlEventEditingChanged];
        return cell;
        
    } else if (indexPath.section == IKAddClassSectionTitle && indexPath.row == 1) {
        
        IKAutocompleteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"autocompleteCell"];
        cell.delegate = self;
        cell.suggestions = [[NSUserDefaults standardUserDefaults] arrayForKey:@"classNames"];
        cell.textField = self.titleField;
        self.autocompleteCell = cell;
        
        return cell;
        
    } else if (indexPath.section == IKAddClassSectionType) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (self.scheduleType == IKScheduleTypeClasses) {
            cell.textLabel.text = @[
                                    @"Лекция",
                                    @"Практика",
                                    @"Лабораторная"
                                    ][indexPath.row];
        } else {
            cell.textLabel.text = @[
                                    @"Консультация",
                                    @"Зачет",
                                    @"Экзамен"
                                    ][indexPath.row];
        }
        cell.accessoryType = indexPath.row == self.classType ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        return cell;
        
    } else if (indexPath.section == IKAddClassSectionTime) {
        
        IKTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timeCell"];
        if (!self.classStartDate) {
            self.classStartDate = cell.startDate;
        } else {
            cell.startDate = self.classStartDate;
        }
        if (!self.classEndDate) {
            self.classEndDate = cell.endDate;
        } else {
            cell.endDate = self.classEndDate;
        }
        cell.delegate = self;
        return cell;
        
    } else if (indexPath.section == IKAddClassSectionGroup) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.textLabel.text = @[
                                @"1 подгруппа",
                                @"2 подгруппа",
                                @"все подгруппы"
                                ][indexPath.row];
        cell.accessoryType = indexPath.row == self.classSubgroup ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        return cell;
        
    } else if (indexPath.section == IKAddClassSectionLecturer) {
        
        IKTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textFieldCell"];
        cell.titleLabel.text = @"ПРЕПОДОВАТЕЛЬ:";
        cell.textField.text = self.classLecturer;
        [cell.textField addTarget:self action:@selector(lecturerChanged:) forControlEvents:UIControlEventEditingChanged];
        return cell;
        
    } else if (indexPath.section == IKAddClassSectionClassroom) {
        
        IKTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textFieldCell"];
        cell.titleLabel.text = @"КАБИНЕТ:";
        cell.textField.text = self.classClassroom;
        [cell.textField addTarget:self action:@selector(classroomChanged:) forControlEvents:UIControlEventEditingChanged];
        return cell;
        
    } else if (indexPath.section == IKAddClassSectionHousing) {
        
        IKTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textFieldCell"];
        cell.titleLabel.text = @"КОРПУС:";
        cell.textField.text = self.classHousing;
        [cell.textField addTarget:self action:@selector(housingChanged:) forControlEvents:UIControlEventEditingChanged];
        return cell;
        
    } else { return nil; }
}

#pragma mark - UITableViewDataDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == IKAddClassSectionTitle && indexPath.row == 1) {
        return self.autocompleteCell.prefferedHeight;
    } else if (indexPath.section == IKAddClassSectionTime) {
        return 220;
    } else {
        return tableView.rowHeight;
    }
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[IKTextFieldCell class]]) {
        [[(IKTextFieldCell *)cell textField] removeTarget:self action:NULL forControlEvents:UIControlEventEditingChanged];
    }
    
    if (indexPath.section == IKAddClassSectionTitle && indexPath.row == 0) {
        self.titleField = nil;
    }
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == IKAddClassSectionGroup || indexPath.section == IKAddClassSectionType;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == IKAddClassSectionType) {
        self.classType = indexPath.row;
        for (UITableViewCell *cell in tableView.visibleCells) {
            if ([tableView indexPathForCell:cell].section == IKAddClassSectionType) {
                cell.accessoryType = [tableView indexPathForCell:cell].row == self.classType ?
                                     UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            }
        }
    }
    
}

#pragma mark - Target Actions

-(void)done
{    
    if (self.titleField) {
        self.classTitle = self.titleField.text;
    }
    
    IKClass *newClass = [NSEntityDescription insertNewObjectForEntityForName:@"IKClass" inManagedObjectContext:IKSchedule.managedObjectContext];
    newClass.title = self.classTitle;
    newClass.type = self.classType + self.scheduleType*3;
    newClass.startDate = self.classStartDate;
    newClass.endDate = self.classEndDate;
    newClass.subgroup = self.classSubgroup;
    newClass.lecturer = self.classLecturer;
    newClass.classroom = self.classClassroom;
    newClass.housing = self.classHousing;
    newClass.weekday = @(self.weekday);
    newClass.week = @(self.week);
    newClass.group = self.group;
    [IKSchedule save];
    
    NSMutableArray *classNames = [[NSUserDefaults standardUserDefaults] arrayForKey:@"classNames"].mutableCopy;
    if (!classNames) classNames = [NSMutableArray array];
    if (![classNames containsObject:self.classTitle]) {
        [classNames addObject:self.classTitle];
        [[NSUserDefaults standardUserDefaults] setObject:classNames.copy forKey:@"classNames"];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)cancel
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IKTimeCellDelegate

-(void)timeCellTimeChanged:(IKTimeCell *)timeCell
{
    self.classStartDate = timeCell.startDate;
    self.classEndDate = timeCell.endDate;
}

#pragma mark - IKAutocompleteCellDelegate

-(void)autocompleteCellDidChangeHeight:(IKAutocompleteCell *)cell
{
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

-(void)autocompleteCell:(IKAutocompleteCell *)cell didDeleteWord:(NSString *)word
{
    NSMutableArray *classNames = [[NSUserDefaults standardUserDefaults] arrayForKey:@"classNames"].mutableCopy;
    [classNames removeObject:word];
    [[NSUserDefaults standardUserDefaults] setObject:classNames.copy forKey:@"classNames"];
}

@end
