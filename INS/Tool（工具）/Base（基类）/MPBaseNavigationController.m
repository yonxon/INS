

#import "MPBaseNavigationController.h"

@interface MPBaseNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation MPBaseNavigationController

//自定义了leftBarButtonItem 侧滑返回失效
- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate =  self;
    
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1 ) {
        return NO;
    }
    
    return YES;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        //第二级则隐藏底部Tab
        viewController.hidesBottomBarWhenPushed = YES;
        // 关闭加载提示框
#warning 
//        [UTMessageShow Dismiss];
    }
    [super pushViewController:viewController animated:animated];
}

@end
