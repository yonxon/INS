
#import <Foundation/Foundation.h>

@interface LPAlertView : NSObject


+ (LPAlertView *)shareInstance;




/**
 * 弹出提示框，确定，取消
 * title        标题
 * message      消息
 * OKBlock      确定回调
 * CancelBlock  取消回调
 */
- (void)showWithTitle:(NSString *)title message:(NSString *)message OKBlock:(void (^)(void))OKBlock CancelBlock:(void (^)(void))CancelBlock;


/**
 * 弹出提示框，确定，取消
 * title        标题
 * message      消息
 * OKBlock      确定回调
 * CancelBlock  取消回调
 */
+ (void)showWithTitle:(NSString *)title message:(NSString *)message OKBlock:(void (^)(void))OKBlock CancelBlock:(void (^)(void))CancelBlock;

@end
