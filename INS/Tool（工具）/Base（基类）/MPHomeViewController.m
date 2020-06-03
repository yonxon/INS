

#import "MPHomeViewController.h"


@interface MPHomeViewController()

/** 首页*/
@property (nonatomic,strong) NSDictionary *IconHome;
/** 发现*/
@property (nonatomic,strong) NSDictionary *IconFind;
/** 添加*/
@property (nonatomic,strong) NSDictionary *IconAdd;
/** 动态*/
@property (nonatomic,strong) NSDictionary *IconMsg;
/** 我的*/
@property (nonatomic,strong) NSDictionary *IconMine;

@end

@implementation MPHomeViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupTabBarController];
        
        self.tabBar.tintColor = COLOR_MAIN;
        
        //显示未读
    //    UINavigationController  *discoverNav =(UINavigationController *)self.viewControllers[1];
    //   UITabBarItem *curTabBarItem=discoverNav.tabBarItem;
    //   [curTabBarItem setBadgeValue:@"2"];
    }
    return self;
}


- (void)setupTabBarController {
    /// 设置TabBar属性数组
    self.tabBarItemsAttributes = [self tabBarItemsAttributesForController];
    

    self.viewControllers = [self MyViewControllers];

    self.delegate = self;
    self.moreNavigationController.navigationBarHidden = YES;
}


- (NSArray *)MyViewControllers {
    
    HomeVC *firstViewController = [[HomeVC alloc] init];
    UINavigationController *navi1 = [[MPBaseNavigationController alloc]
                                                         initWithRootViewController:firstViewController];
  
    FindVC  *findVC = [[FindVC alloc] init];
    UINavigationController *navi2 = [[MPBaseNavigationController alloc]
                                                         initWithRootViewController:findVC];

    AddVC *addVC = [[AddVC alloc] init];
    UINavigationController *navi3 = [[MPBaseNavigationController alloc]
                                                          initWithRootViewController:addVC];
   
    MsgVC *msgVC = [[MsgVC alloc] init];
       UINavigationController *navi4 = [[MPBaseNavigationController alloc]
                                                             initWithRootViewController:msgVC];
    
    MineVC *mineVC = [[MineVC alloc] init];
       UINavigationController *navi5 = [[MPBaseNavigationController alloc]
                                                             initWithRootViewController:mineVC];
    
    NSArray *viewControllers = @[
                                 navi1,
                                 navi2,
                                 navi3,
                                 navi4,
                                 navi5
                                 ];
    
    return viewControllers;
}




//TabBar文字跟图标设置
- (NSArray *)tabBarItemsAttributesForController {
    
    return @[self.IconHome,
             self.IconFind,
             self.IconAdd,
    self.IconMsg,
    self.IconMine];
}





#pragma mark - Tabbar 图标按钮 - - - - - - - - - - - - - - - - - - - - - -
/** 首页*/
- (NSDictionary *)IconHome
{
    if(!_IconHome)
    {
        _IconHome = @{
                         CYLTabBarItemTitle : @"",
                         CYLTabBarItemImage : @"Tab_home2",
                         CYLTabBarItemSelectedImage : @"Tab_home",
                         };
    }
    
    return _IconHome;
}

/** 发现*/
- (NSDictionary *)IconFind
{
    if(!_IconFind)
    {
        _IconFind = @{
                               CYLTabBarItemTitle : @"",
                               CYLTabBarItemImage : @"Tab_find2",
                               CYLTabBarItemSelectedImage : @"Tab_find",
                               };
        
    }
    return _IconFind;
}





/** 添加*/
- (NSDictionary *)IconAdd
{
    if(!_IconAdd)
    {
        _IconAdd = @{
                           CYLTabBarItemTitle : @"",
                           CYLTabBarItemImage : @"Tab_add2",
                           CYLTabBarItemSelectedImage : @"Tab_add",
                           };
    }
    return _IconAdd;
}



/** 动态*/
- (NSDictionary *)IconMsg
{
    if(!_IconMsg)
    {
        _IconMsg = @{
                           CYLTabBarItemTitle : @"",
                           CYLTabBarItemImage : @"Tab_msg2",
                           CYLTabBarItemSelectedImage : @"Tab_msg",
                           };
    }
    return _IconMsg;
}


/** 我的*/
- (NSDictionary *)IconMine
{
    if(!_IconMine)
    {
        _IconMine = @{
                           CYLTabBarItemTitle : @"",
                           CYLTabBarItemImage : @"Tab_mine2",
                           CYLTabBarItemSelectedImage : @"Tab_mine",
                           };
    }
    return _IconMine;
}






#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController*)tabBarController shouldSelectViewController:(UINavigationController*)viewController {
    
#warning --
//    [UTMessageShow Dismiss];
    
    /// 特殊处理 - 是否需要登录
//    BOOL isBaiDuService = [viewController.topViewController isKindOfClass:[BaiDuMapViewController class]];
//    if (isBaiDuService) {
//        NSLog(@"我是百度地图，你点击了TabBar");
//    }
    
    return YES;
}


//-(void)viewWillAppear:(BOOL)animated
//{
//    [self.selectedViewController beginAppearanceTransition: YES animated: animated];
//}
//
//-(void) viewDidAppear:(BOOL)animated
//{
//    [self.selectedViewController endAppearanceTransition];
//}
//
//-(void) viewWillDisappear:(BOOL)animated
//{
//    [self.selectedViewController beginAppearanceTransition: NO animated: animated];
//}
//
//-(void) viewDidDisappear:(BOOL)animated
//{
//    [self.selectedViewController endAppearanceTransition];
//}
@end
