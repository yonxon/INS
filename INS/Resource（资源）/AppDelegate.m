

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "MPBaseNavigationController.h"
#import "MPHomeViewController.h"
#import "LoginVC.h"
#import "WXApi.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 打印项目运行的地址
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString*documentsDirectory = [[paths objectAtIndex:0] copy];
    NSLog(@"项目运行的地址： %@",documentsDirectory);
  
    [WXApi registerApp:appId];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
       
    // UserModel 数据检测更新
    [self UserModelVerify];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  
    
     [self setupLoginViewController];
    
    
//    [UIApplication sharedApplication].statusBarStyle = ![UIApplication sharedApplication].statusBarStyle;  //UIStatusBarStyleLightContent状态栏字体白色 UIStatusBarStyleDefault黑色
//    [[UIApplication sharedApplication]setStatusBarStyle:![UIApplication sharedApplication].statusBarStyle  animated:YES];    //UIStatusBarStyleLightContent状态栏字体白色 UIStatusBarStyleDefault黑色  同时可指定变换动画
    
    
    
    return YES;
}



- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    return [WXApi handleOpenURL:url delegate:self];
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp{
    if([resp isKindOfClass:[SendAuthResp class]]){
        SendAuthResp *resp2 = (SendAuthResp *)resp;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"wxLogin" object:resp2];
    }else{
        NSLog(@"授权失败");
    }
}

/** UserModel检查更新 保证新增的字段能用*/
- (void)UserModelVerify
{
    [USER_INFOR updateDataField];
}


#pragma mark 自定义跳转不同的页面
// 登录页面
-(void)setupLoginViewController
{
    LoginVC *logInVc = [[LoginVC alloc]init];
    UINavigationController *loginNavigationController = [[MPBaseNavigationController alloc]
                                                         initWithRootViewController:logInVc];
    self.window.rootViewController = loginNavigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}


//首页
-(void)setupHomeViewController
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        MPHomeViewController *tabBarController = [[MPHomeViewController alloc] init];
        [self.window setRootViewController:tabBarController];
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        
    });

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
