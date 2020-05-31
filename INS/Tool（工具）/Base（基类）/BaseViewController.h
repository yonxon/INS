

#import <UIKit/UIKit.h>
#import "UIImage+Color.h"

@protocol  BBBaseViewControllerDataSource<NSObject>

-(NSMutableAttributedString*)setTitle;
-(UIButton*)set_leftButton;
-(UIButton*)set_rightButton;
-(UIColor*)set_colorBackground;
-(UIImage*)navBackgroundImage;
-(UIImage*)set_leftBarButtonItemWithImage;
-(UIImage*)set_rightBarButtonItemWithImage;
-(CGFloat)set_navigationHeight;
-(UIView*)set_bottomView;
@end


@protocol BBBaseViewControllerDelegate <NSObject>

@optional
-(void)left_button_event:(UIButton*)sender;
-(void)right_button_event:(UIButton*)sender;
-(void)title_click_event:(UIView*)sender;
@end

@interface BaseViewController : UIViewController<BBBaseViewControllerDataSource , BBBaseViewControllerDelegate>

-(void)setContentAlpha:(CGFloat)alpha;
-(void)changeNavigationBarHeight:(CGFloat)offset;
-(void)changeNavigationBarTranslationY:(CGFloat)translationY;
-(void)set_Title:(NSMutableAttributedString *)title;


/** 设置导航栏标题*/
- (void)titleSetting:(NSString *)title;
/** 设置导航栏右按钮图标、文字*/
- (void)initRightButtonWithIcon:(UIImage *)icon withTitle:(NSString *)titleStr;
/** 设置导航栏左按钮图标、文字*/
- (void)initLeftButtonWithIcon:(UIImage *)icon withTitle:(NSString *)titleStr;
/** 设置导航栏右按钮文字*/
- (void)initRightButtonWithTitle:(NSString *)titleStr;
/** 设置导航栏左按钮文字*/
- (void)initLeftButtonWithTitle:(NSString *)titleStr;

/** 设置导航栏返回按钮*/
- (void)initBackBar;
/** 设置导航栏返回按钮*/
- (void)initBackBarWithImage:(UIImage *)image;
/** 导航栏右按钮点击事件*/
- (void)rightAction;
/** 导航栏左按钮点击事件*/
- (void)leftAction;
/** 导航栏返回按钮事件*/
- (void)back;


@end
