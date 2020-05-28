//
//  AppDelegate.m
//  INS
//
//  Created by lu peihan on 2020/5/28.
//  Copyright © 2020 lu peihan. All rights reserved.
//

#import "AppDelegate.h"
#import "TestViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 打印项目运行的地址
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString*documentsDirectory = [[paths objectAtIndex:0] copy];
    NSLog(@"项目运行的地址： %@",documentsDirectory);
  
    
//    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
       
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    TestViewController *vc = [[TestViewController alloc] init];
    UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = Nav;
    [self.window makeKeyAndVisible];
    
    
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

    // 返回应用前台，检测升级，防止用户点升级之后 在返回应用，这个时候应用升级提示框已经关闭
//    [self performSelectorInBackground:@selector(versionVerify) withObject:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier{
    
    return YES;
    
}

@end
