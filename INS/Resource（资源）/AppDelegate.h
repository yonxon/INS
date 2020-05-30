

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;



#pragma mark 自定义跳转不同的页面
// 登录页面
-(void)setupLoginViewController;

//首页
-(void)setupHomeViewController;



@end

