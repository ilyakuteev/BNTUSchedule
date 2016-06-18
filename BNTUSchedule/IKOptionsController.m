
//
//  IKOptionsController.m
//  BNTUSchedule
//
//  Created by Ilya Kuteev on 06.04.16.
//  Copyright © 2016 Илья Кутеев. All rights reserved.
//

#import "IKOptionsController.h"


@interface IKOptionsController ()
@property (nonatomic) NSMutableArray *groups;
@end


@implementation IKOptionsController

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.groups = [[NSUserDefaults standardUserDefaults] arrayForKey:@"groups"].mutableCopy;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NSUserDefaultsDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        NSArray *newGroups = [[NSUserDefaults standardUserDefaults] arrayForKey:@"groups"];
        for (int i = 0; i < self.groups.count; i++) {
            if (![newGroups containsObject:self.groups[i]]) {
                [self.groups removeObjectAtIndex:i];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                i--;
            }
        }
        
        for (int i = 0; i < newGroups.count; i++) {
            if (![self.groups containsObject:newGroups[i]]) {
                [self.groups insertObject:newGroups[i] atIndex:i];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                i++;
            }
        }
        
    }];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    } else {
        return 1 + self.groups.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (indexPath.section == 0) {
        
        cell.textLabel.text = [NSString stringWithFormat:@"%d подгруппа", (int)indexPath.row+1];
        
        NSInteger currentSubgroup = [[NSUserDefaults standardUserDefaults] integerForKey:@"subgroup"];
        cell.accessoryType = indexPath.row == currentSubgroup ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        
    } else if (indexPath.row < [tableView numberOfRowsInSection:indexPath.section]-1) {
        
        cell.textLabel.text = self.groups[indexPath.row];
        
    } else {
        cell.textLabel.text = @"Добавить группу";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Выберите подгруппу";
    } else {
        return @"Группы";
    }
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row < [tableView numberOfRowsInSection:indexPath.section]-1) {
        return NO;
    } else {
        return YES;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"subgroup"];
        for (UITableViewCell *cell in tableView.visibleCells) {
            if ([tableView indexPathForCell:cell].section == 0) {
                if ([tableView indexPathForCell:cell].row == indexPath.row) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                } else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
        }
        
    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        
        __block UITextField *nameField;
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Готово" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSMutableArray *groups = [[NSUserDefaults standardUserDefaults] arrayForKey:@"groups"].mutableCopy;
            if (!groups) groups = [NSMutableArray array];
            [groups addObject:nameField.text];
            [[NSUserDefaults standardUserDefaults] setObject:groups.copy forKey:@"groups"];
            
        }];
        doneAction.enabled = NO;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Создание группы" message:@"Ведите название группы" preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
            nameField = textField;
            [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:textField queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
                
                BOOL found = NO;
                for (NSString *group in [[NSUserDefaults standardUserDefaults] arrayForKey:@"groups"]) {
                    if ([group isEqualToString:textField.text]) found = YES;
                }
                
                doneAction.enabled = textField.text.length && !found ? YES : NO;
            }];
        }];
        [alert addAction:cancelAction];
        [alert addAction:doneAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [tableView numberOfRowsInSection:indexPath.section]-1 && indexPath.section == 1) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Да" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSMutableArray *groups = [[NSUserDefaults standardUserDefaults] arrayForKey:@"groups"].mutableCopy;
            [groups removeObjectAtIndex:indexPath.row];
            [[NSUserDefaults standardUserDefaults] setObject:groups.copy forKey:@"groups"];
            
            if (!groups.count) {
                
                __block UITextField *nameField;
                
                UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Готово" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    NSMutableArray *groups = [[NSUserDefaults standardUserDefaults] arrayForKey:@"groups"].mutableCopy;
                    if (!groups) groups = [NSMutableArray array];
                    [groups addObject:nameField.text];
                    [[NSUserDefaults standardUserDefaults] setObject:groups.copy forKey:@"groups"];
                    
                }];
                doneAction.enabled = NO;
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Создание группы" message:@"Вы удалили все группы. Создайте новую, введя ее название." preferredStyle:UIAlertControllerStyleAlert];
                [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    textField.keyboardType = UIKeyboardTypeNumberPad;
                    nameField = textField;
                    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:textField queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
                        
                        BOOL found = NO;
                        for (NSString *group in [[NSUserDefaults standardUserDefaults] arrayForKey:@"groups"]) {
                            if ([group isEqualToString:textField.text]) found = YES;
                        }
                        
                        doneAction.enabled = textField.text.length && !found ? YES : NO;
                    }];
                }];
                [alert addAction:doneAction];
                
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            
        }];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Удаление группы" message:@"При удалении группы все ее пары будут также безвозвратно удалены. Продолжить?" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:cancelAction];
        [alert addAction:doneAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
}

@end
