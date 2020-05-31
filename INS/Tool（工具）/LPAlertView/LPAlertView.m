

#import "LPAlertView.h"
#import "SnailAlertView.h"
#import "SnailPopupController.h"

#define LineColor [UIColor colorWithRed:92/255.0f green:207/255.0f blue:224/255.0f alpha:1]

#define CancelBtnColor [UIColor darkGrayColor]

#define OKBtnColor [UIColor colorWithRed:76/255.0f green:119/255.0f blue:190/255.0f alpha:1]

@implementation LPAlertView




/**
 * 弹出提示框，确定，取消
 * title        标题
 * message      消息
 * OKBlock      确定回调
 * CancelBlock  取消回调
 */
+ (void)showWithTitle:(NSString *)title message:(NSString *)message OKBlock:(void (^)(void))OKBlock CancelBlock:(void (^)(void))CancelBlock
{
    SnailPopupController *sl_popupController = [SnailPopupController new];
    
    SnailAlertView *alert = [[SnailAlertView alloc] initWithTitle:title message:message fixedWidth:300];
    alert.linesColor = LineColor;
    
    SnailAlertButton *cancelButton = [SnailAlertButton buttonWithTitle:NSLocalizedString(@"Cancel", nil) handler:^(SnailAlertButton * _Nonnull button) {
        
        
        [sl_popupController dismiss];
        
        if(CancelBlock)
        {
            CancelBlock();
        }
        
    }];
    SnailAlertButton *okButton = [SnailAlertButton buttonWithTitle:NSLocalizedString(@"Determine", nil) handler:^(SnailAlertButton * _Nonnull button) {
        [sl_popupController dismiss];
        if(OKBlock)
        {
            OKBlock();
        }
        
    }];
    [cancelButton setTitleColor:CancelBtnColor forState:UIControlStateNormal];
    [okButton setTitleColor:OKBtnColor forState:UIControlStateNormal];
    [alert addAdjoinWithCancelAction:cancelButton okAction:okButton];
    
    
    
    sl_popupController.transitStyle = PopupTransitStyleFromTop;
    sl_popupController.isDropTransitionAnimated = YES;
    [sl_popupController presentContentView:alert duration:0.75 elasticAnimated:YES];
}









+ (LPAlertView *)shareInstance
{
    static LPAlertView *_shareInstance;
    static dispatch_once_t onePredicate;
    
    dispatch_once(&onePredicate, ^{
        
        _shareInstance = [[LPAlertView alloc] init];
    });
    
    return _shareInstance;
}
// 由于出现多个弹框时候，取消功能有问题，不能dismiss掉弹框，所以改为类方法，去掉之前的单例
/**
 * 弹出提示框，确定，取消
 * title        标题
 * message      消息
 * OKBlock      确定回调
 * CancelBlock  取消回调
 */
- (void)showWithTitle:(NSString *)title message:(NSString *)message OKBlock:(void (^)(void))OKBlock CancelBlock:(void (^)(void))CancelBlock
{
    SnailAlertView *alert = [[SnailAlertView alloc] initWithTitle:title message:message fixedWidth:300];
    alert.linesColor = LineColor;
    
    SnailAlertButton *cancelButton = [SnailAlertButton buttonWithTitle:@"取消" handler:^(SnailAlertButton * _Nonnull button) {
        
        
        [self.sl_popupController dismiss];
        
        if(CancelBlock)
        {
            CancelBlock();
        }
        
    }];
    SnailAlertButton *okButton = [SnailAlertButton buttonWithTitle:@"确定" handler:^(SnailAlertButton * _Nonnull button) {
        [self.sl_popupController dismiss];
        if(OKBlock)
        {
            OKBlock();
        }
        
    }];
    [cancelButton setTitleColor:CancelBtnColor forState:UIControlStateNormal];
    [okButton setTitleColor:OKBtnColor forState:UIControlStateNormal];
    [alert addAdjoinWithCancelAction:cancelButton okAction:okButton];
    
 
    self.sl_popupController = [SnailPopupController new];
    self.sl_popupController.transitStyle = PopupTransitStyleFromTop;
    self.sl_popupController.isDropTransitionAnimated = YES;
    [self.sl_popupController presentContentView:alert duration:0.75 elasticAnimated:YES];
}


@end
