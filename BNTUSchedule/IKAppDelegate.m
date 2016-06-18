//
//  AppDelegate.m
//  BNTUSchedule
//
//  Created by Илья Кутеев on 27.03.16.
//  Copyright © 2016 Илья Кутеев. All rights reserved.
//

#import "IKAppDelegate.h"
#import "IKScheduleController.h"
#import "IKOptionsController.h"


@implementation IKAppDelegate


-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    IKScheduleController *examsController = [[IKScheduleController alloc] initWithType:IKScheduleTypeExams];
    UINavigationController *examsNavigationController = [[UINavigationController alloc] initWithRootViewController:examsController];
    
    IKScheduleController *scheduleController = [[IKScheduleController alloc] initWithType:IKScheduleTypeClasses];
    UINavigationController *scheduleNavigationController = [[UINavigationController alloc] initWithRootViewController:scheduleController];
    
    IKOptionsController *optionsController = [[IKOptionsController alloc] init];
    UINavigationController *optionsNavigationController = [[UINavigationController alloc] initWithRootViewController:optionsController];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[examsNavigationController, scheduleNavigationController, optionsNavigationController];
    tabBarController.tabBar.items[1].image = [UIImage imageNamed:@"exams"];
    tabBarController.tabBar.items[0].image = [UIImage imageNamed:@"schedule"];
    tabBarController.tabBar.items[2].image = [UIImage imageNamed:@"settings"];
    tabBarController.tabBar.items[1].title = @"Экзамены";
    tabBarController.tabBar.items[0].title = @"Расписание";
    tabBarController.tabBar.items[2].title = @"Настройки";
    
    UIScreen *screen = [UIScreen mainScreen];
    
    self.window = [[UIWindow alloc] initWithFrame:screen.bounds];
    self.window.rootViewController = tabBarController;
    self.window.tintColor = [UIColor colorWithRed:43.0/255.0 green:213.0/255.0 blue:83.0/255.0 alpha:1.0];
    [self.window makeKeyAndVisible];
    
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    navigationBar.barTintColor = self.window.tintColor;
    navigationBar.translucent = NO;
    navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor] };

    [UIBarButtonItem appearance].tintColor = [UIColor whiteColor];
    
    NSArray *groups = [[NSUserDefaults standardUserDefaults] arrayForKey:@"groups"];
    if (!groups.count) {
        
        __block UITextField *nameField;
        
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Готово" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSMutableArray *groups = [[NSUserDefaults standardUserDefaults] arrayForKey:@"groups"].mutableCopy;
            if (!groups) groups = [NSMutableArray array];
            [groups addObject:nameField.text];
            [[NSUserDefaults standardUserDefaults] setObject:groups.copy forKey:@"groups"];
            
            [examsController reloadAllData];
            
        }];
        doneAction.enabled = NO;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Создание группы" message:@"Введите название группы" preferredStyle:UIAlertControllerStyleAlert];
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
        
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }
    
    return YES;
}

@end
