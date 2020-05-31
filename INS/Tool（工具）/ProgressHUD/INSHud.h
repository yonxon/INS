

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HubStyle) {
    
    StringStyle = 0,  // 纯文字
    
    ImageStringStyle = 1,  // 图片+文字
    
    ImageGifStyle = 2 // 动态图片
    
};

@interface INSHud : UIView

@property (nonatomic) HubStyle type;


+ (INSHud *)shareInstance;


/**
 *  显示纯文字
 *
 *  @param string 文字内容
 */
+ (void)HubWithString:(NSString *)string;


/**
 *  自定义显示gif图片
 *
 *  @param imgName 图片名
 *  @param type    图片格式
 *  @param tipMessage  提示信息
 *  @param warningMessage 警告信息
 */
+ (void)HubWithGif:(NSString *)imgName andType:(NSString *)type tipMessage:(NSString*)tipMessage warningMessage:(NSString *)warningMessage;

+ (void)HubWithGif:tipMessage warningMessage:(NSString *)warningMessage;
// 关闭gif
+ (void)DismissGif;


/**
 *  自定义图片+文字
 *
 *  @param imgName 图片名字
 *  @param title 标题
 *  @param message  消息
 *  @param sureBtn 是否增加确认按钮
 *  @param autoDismiss 是否自动消失
 */
+ (void)HubImageWithString:(NSString *)imgName title:(NSAttributedString *)title message:(NSString *)message sureBtn:(BOOL)sureBtn autoDismiss:(BOOL)autoDismiss;

/**
 *  取消hub
 */
+ (void)Dismiss;


/**
 * 加载风火轮
 */
+ (void)HubLoading;

// 关闭加载提示框
+ (void)DismissLoading;



//是否已经显示
+ (BOOL)isVisible;


@end
