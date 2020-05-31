
#import "MessageShow.h"

#import "INSHud.h"

#import "LPAlertView.h"

#import "ProgressShow.h"


#define kIconSuccess    @"Icon_State_Success"  //成功图标
#define kIconError      @"Icon_State_Failed"    //失败图标
// 默认返回描述字符串，当找不到对应结果时候使用
static NSString *errorDefault = @"出错啦";

// 网络不给力
static NSString *errorNetWork = @"CannotConnectNetwork";

@implementation MessageShow

+ (MessageShow *)shareInstance
{
    static MessageShow *_shareInstance;
    static dispatch_once_t onePredicate;
    
    dispatch_once(&onePredicate, ^{
        
        _shareInstance = [[MessageShow alloc] init];
    });
    
    return _shareInstance;
}

#pragma mark -  成功失败提示框- - - - - -
/**
 *  弹出错误描述：string
 */
+ (void)ShowErrorString:(NSString *)string
{
      [INSHud HubImageWithString:kIconError title:nil message:string sureBtn:NO autoDismiss:YES];
}

/**
 *  弹出成功描述：string
 */
+ (void)ShowSuccessString:(NSString *)string
{
     [INSHud HubImageWithString:kIconSuccess title:nil message:string sureBtn:NO autoDismiss:YES];
}

/**
 *  弹出文字描述
 */
+ (void)ShowString:(NSString *)string
{
    [INSHud HubWithString:string];
}

/**
 *  网络不给力!
 */
+ (void)ShowNetWorkError
{
     [INSHud HubImageWithString:kIconSuccess title:nil message:errorNetWork sureBtn:NO autoDismiss:YES];
}

#pragma mark -  风火轮提示框- - - - - -
/**
 *  显示加载
 */
+ (void)ShowLoding
{
    [INSHud HubLoading];
}
/**
 *  显示加载
 */
+ (void)show
{
    [INSHud HubLoading];
}
/**
 *  关闭加载
 */
+ (void)Dismiss
{
   [INSHud DismissLoading];
}


#pragma mark -  LPAlertView 选择框- - - - - -

/**
 * 弹出提示框，确定，取消
 * title        标题
 * message      消息
 * OKBlock      确定回调
 * CancelBlock  取消回调
 */
+ (void)showWithTitle:(NSString *)title message:(NSString *)message OKBlock:(void (^)(void))OKBlock CancelBlock:(void (^)(void))CancelBlock
{
     [LPAlertView  showWithTitle:title message:message OKBlock:OKBlock CancelBlock:CancelBlock];
}


#pragma mark -  图文提示框- - - - - -
//是否已经显示
+ (BOOL)isVisible{
    return [INSHud isVisible];
    //    return [SVProgressHUD isVisible];
}
/**
 * 弹出提示框，确定
 * image        图标
 * title        标题
 * message      消息
 * sureBtn      是否显示确定按钮
 否，自动消失
 是，点击确定消失
 */
+ (void)showImageWithString:(NSString *)image message:(NSString *)message{
    [INSHud HubImageWithString:image title:nil message:message sureBtn:NO autoDismiss:YES];
}
+ (void)showImageWithString:(NSString *)image message:(NSString *)message sureBtn:(BOOL)sureBtn{
    [INSHud HubImageWithString:image title:nil message:message sureBtn:sureBtn autoDismiss:NO];
}
+ (void)showImageWithString:(NSString *)image message:(NSString *)message sureBtn:(BOOL)sureBtn autoDismiss:(BOOL)autoDismiss{
    [INSHud HubImageWithString:image title:nil message:message sureBtn:sureBtn autoDismiss:autoDismiss];
}
+ (void)showImageWithString:(NSString *)image title:(NSAttributedString *)title message:(NSString *)message sureBtn:(BOOL)sureBtn autoDismiss:(BOOL)autoDismiss{
    [INSHud HubImageWithString:image title:title message:message sureBtn:sureBtn autoDismiss:autoDismiss];
}
/**
 * 封装好的提示框
 * message      消息
 * sureBtn      是否显示确定按钮
 * autoDismiss  是，自动消失
                否，点击确定消失
 */

//笑脸提示成功
+ (void)ShowWithSmailFace:(NSString *)message sureBtn:(BOOL)sureBtn autoDismiss:(BOOL)autoDismiss{
    //笑脸对应成功
    NSString *tip = NSLocalizedString(@"Successful", nil);
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:tip];
     UIColor *color_green = [UIColor colorWithRed:96/255.0f green:182/255.0f blue:55/255.0f alpha:1];
       [title addAttribute:NSForegroundColorAttributeName value:color_green range:NSMakeRange(0, tip.length)];
    [title addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:16] range:NSMakeRange(0, tip.length)];
    [INSHud HubImageWithString:@"Icon_Abnormal_State_Success" title:title message:message sureBtn:sureBtn autoDismiss:autoDismiss];
}
//哭脸提示失败
+ (void)ShowWithSadFace:(NSString *)message sureBtn:(BOOL)sureBtn autoDismiss:(BOOL)autoDismiss{
    //哭脸对应失败
    NSString *tip = NSLocalizedString(@"Failed", nil);
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:tip];
     UIColor *color_red = [UIColor colorWithRed:232/255.0f green:75/255.0f blue:77/255.0f alpha:1];
       [title addAttribute:NSForegroundColorAttributeName value:color_red range:NSMakeRange(0, tip.length)];
    [title addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:16] range:NSMakeRange(0, tip.length)];
    [INSHud HubImageWithString:@"Icon_Abnormal_State_Failed" title:title message:message sureBtn:sureBtn autoDismiss:autoDismiss];
}
//异常提示
+ (void)ShowWithAbnormalFace:(NSString *)message sureBtn:(BOOL)sureBtn autoDismiss:(BOOL)autoDismiss{
    //异常
    NSString *tip = NSLocalizedString(@"Abnormal", nil);
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:tip];
    UIColor *color_orgen = [UIColor colorWithRed:251/255.0f green:140/255.0f blue:95/255.0f alpha:1];
       [title addAttribute:NSForegroundColorAttributeName value:color_orgen range:NSMakeRange(0, tip.length)];
    [title addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:16] range:NSMakeRange(0, tip.length)];
    [INSHud HubImageWithString:@"Icon_Abnormal_State_Alarm" title:title message:message sureBtn:sureBtn autoDismiss:autoDismiss];
}

#pragma mark gif提示框 --------------
/**
 *  自定义显示gif图片
 *
 *  @param imgName 图片名
 *  @param type    图片格式
 *  @param tipMessage  提示信息
 *  @param warningMessage 警告信息
 */
+ (void)showHubWithGif:(NSString *)imgName andType:(NSString *)type tipMessage:(NSString*)tipMessage warningMessage:(NSString *)warningMessage{
    [INSHud HubWithGif:imgName andType:type tipMessage:tipMessage warningMessage:warningMessage];
}

/**
 *  使用默认gif图片
 *  @param tipMessage  提示信息
 *  @param warningMessage 警告信息
 */
+ (void)showStatusWithGif:(NSString*)tipMessage warningMessage:(NSString *)warningMessage{
    [INSHud HubWithGif:tipMessage warningMessage:warningMessage];
}
+ (void)showStatusWithGif:(NSString*)tipMessage{
    [INSHud HubWithGif:tipMessage warningMessage:nil];
}
+ (void)showStatus{
    [INSHud HubWithGif:nil warningMessage:nil];
}
/**
 * 关闭gif图片
 */
+ (void)DismissHubGif{
    [INSHud DismissGif];
}


@end
