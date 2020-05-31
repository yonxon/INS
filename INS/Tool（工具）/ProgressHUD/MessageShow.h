
/************************************* 文件说明****************************************

 文件说明： 提示框工具 ****************************************************************************************/

#import <Foundation/Foundation.h>

@interface MessageShow : NSObject


#pragma mark  成功失败提示框 -------
/**
 *  弹出错误描述：string
 */
+ (void)ShowErrorString:(NSString *)string;

/**
 *  弹出成功描述：string
 */
+ (void)ShowSuccessString:(NSString *)string;

/**
 *  弹出文字描述
 */
+ (void)ShowString:(NSString *)string;

/**
 *  网络不给力!
 */
+ (void)ShowNetWorkError;


#pragma mark  风火轮提示框 -------
/**
 *  显示加载
 */
+ (void)ShowLoding;

/**
 *  关闭加载
 */
+ (void)Dismiss;




#pragma mark  确认框 -------
/**
 * 弹出提示框，确定，取消
 * title        标题
 * message      消息
 * OKBlock      确定回调
 * CancelBlock  取消回调
 */
+ (void)showWithTitle:(NSString *)title message:(NSString *)message OKBlock:(void (^)(void))OKBlock CancelBlock:(void (^)(void))CancelBlock;


#pragma mark  图文提示框 -------
/**
 * 弹出提示框，确定
 * image        图标
 * message      消息
 * sureBtn      是否显示确定按钮
 * autoDismiss   是否自动消失
 */
+ (void)showImageWithString:(NSString *)image message:(NSString *)message ;
+ (void)showImageWithString:(NSString *)image message:(NSString *)message sureBtn:(BOOL)sureBtn;
+ (void)showImageWithString:(NSString *)image message:(NSString *)message sureBtn:(BOOL)sureBtn autoDismiss:(BOOL)autoDismiss;
+ (void)showImageWithString:(NSString *)image title:(NSAttributedString *)title message:(NSString *)message sureBtn:(BOOL)sureBtn autoDismiss:(BOOL)autoDismiss;

/**
 * 封装好的提示框
 * message      消息
 * sureBtn      是否显示确定按钮
 * autoDismiss  是，自动消失
 否，点击确定消失
 */

//笑脸提示成功
+ (void)ShowWithSmailFace:(NSString *)message sureBtn:(BOOL)sureBtn autoDismiss:(BOOL)autoDismiss;
//哭脸提示失败
+ (void)ShowWithSadFace:(NSString *)message sureBtn:(BOOL)sureBtn autoDismiss:(BOOL)autoDismiss;
//异常提示
+ (void)ShowWithAbnormalFace:(NSString *)message sureBtn:(BOOL)sureBtn autoDismiss:(BOOL)autoDismiss;


#pragma mark  gif -------
/**
 *  自定义显示gif图片
 *
 *  @param imgName 图片名
 *  @param type    图片格式
 *  @param tipMessage  提示信息
 *  @param warningMessage 警告信息
 */
+ (void)showHubWithGif:(NSString *)imgName andType:(NSString *)type tipMessage:(NSString*)tipMessage warningMessage:(NSString *)warningMessage;

/**
 *  自定义显示gif图片
 *  @param tipMessage  提示信息
 *  @param warningMessage 警告信息
 */
+ (void)showStatusWithGif:(NSString*)tipMessage warningMessage:(NSString *)warningMessage;

/**
 *  自定义显示gif图片
 *  @param tipMessage  提示信息
 */
+ (void)showStatusWithGif:(NSString*)tipMessage;

/**
 *  自定义显示gif图片
 */
+ (void)showStatus;
/**
 * 关闭gif图片
 */
+ (void)DismissHubGif;

//是否已经显示
+ (BOOL)isVisible;

@end
