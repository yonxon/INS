
#define kHubScreenHeight   [UIScreen mainScreen].bounds.size.height
#define kHubScreenWidth    [UIScreen mainScreen].bounds.size.width


#define textFont [UIFont systemFontOfSize:14.0f]

#define kBgColor [UIColor colorWithRed:233/255.0f green:233/255.0f blue:233/255.0f alpha:1] //背景颜色

#define kIconHeight     60.0f           //图片高度
#define kIconWidth      60.0f           //图片宽度
#define kBtnHeight      35.0f           //确定按钮高度

#define kDefaultWidth      230.0f           //提示框宽度
#define levelSpace 65                   //水平间距
#define verticalSpace 15                   //垂直间距

#define HubShowTime 2                //停留时间

#import "INSHud.h"

@interface INSHud ()

//back view
@property (nonatomic,strong) UIView *backView;

//tip View
@property (nonatomic,strong) UIView *hubView;
@property (nonatomic,strong) NSString *stringShow;  //显示string
@property (nonatomic,strong) UIImage *hubImage;
@property (nonatomic,strong) UILabel *hubLabel;
@property (nonatomic,strong) UIButton *hubBtn;

//laoding View
@property (nonatomic,strong) UIView *loadingView;
@property (nonatomic,strong) UIImageView *loadingimg; //加载显示UIImageView
@property (nonatomic,strong) UILabel *loadingTipLabel;
@property (nonatomic,strong) UILabel *loadingWarningLabel;
@property (nonatomic,strong) UILabel *loadingTitleLabel;

//加载显示风火轮
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic,assign) float defaultWidth;    //HubView宽度
@property (nonatomic,assign) float defaultHeight;   //HubView高度
@property (nonatomic,assign) int   timerHubShow;    //HubView显示时长

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation INSHud

/**
 *  单例
 *
 *  @return ZTTmpDataStorage
 */
+ (INSHud *)shareInstance
{
    static INSHud *_shareInstance = nil;
    
    static dispatch_once_t onePredicate;
    
    dispatch_once(&onePredicate, ^{
        _shareInstance = [[INSHud alloc] init];
    });
    
    return _shareInstance;
}

#pragma publish method - - - - - - - - - - - - - - - - - - - - - - - - -
// 纯文字
+ (void)HubWithString:(NSString *)string
{
    [[self shareInstance]HubWithString:string];
}
#pragma mark --gif---
// 自定义显示gif动态图片
+ (void)HubWithGif:(NSString *)imgName andType:(NSString *)type  tipMessage:(NSString*)tipMessage warningMessage:(NSString *)warningMessage
{
    [[self shareInstance]HubWithGif:imgName andType:type tipMessage:tipMessage warningMessage:warningMessage];
}

// 显示默认gif动态图片并显示提示信息
+ (void)HubWithGif:tipMessage warningMessage:(NSString *)warningMessage
{
    [[self shareInstance]HubWithGif:@"waiting_" andType:@"png" tipMessage:tipMessage warningMessage:warningMessage];
}
+ (void)DismissGif
{
    [[self shareInstance] DismissLoadingView];
}
#pragma mark --图文提示框---
// 自定义图片+文字
+ (void)HubImageWithString:(NSString *)imgName title:(NSAttributedString *)title message:(NSString *)message sureBtn:(BOOL)sureBtn autoDismiss:(BOOL)autoDismiss
{
    [[self shareInstance]HubImageWithString:imgName title:title message:message sureBtn:sureBtn autoDismiss:autoDismiss];
}

// 关闭提示框
+ (void)Dismiss
{
    [[self shareInstance]Dismiss];
}

#pragma mark --风火轮---
/**
 * 加载风火轮
 */
+ (void)HubLoading
{
    [[self shareInstance] HubLoading];
}

// 关闭加载提示框
+ (void)DismissLoading
{
    [[self shareInstance]DismissLoading];
}

+ (BOOL)isVisible {
    return ([self shareInstance].backView.alpha == 1);
}
#pragma  mark  create method - - - - - - - - - - - - - - - - - - - - - - - - -

- (void)HubImageWithString:(NSString *)imgName title:(NSAttributedString *)title message:(NSString *)string sureBtn:(BOOL)sureBtn autoDismiss:(BOOL)autoDismiss
{
    if([string isKindOfClass:[NSNull class]] || !string || string.length < 1)
    {
        return;
    }
    
    self.stringShow = string;
    
    [self createHubViewWithStyle:ImageStringStyle];
    self.defaultHeight = verticalSpace;
    //self.defaultHeight 要根据显示内容动态调整
    if (title) {
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, self.defaultHeight, self.defaultWidth, kBtnHeight)];
        titleLbl.textAlignment = NSTextAlignmentCenter;
        titleLbl.attributedText = title;
        titleLbl.adjustsFontSizeToFitWidth = YES;
        [self.hubView addSubview:titleLbl];
        self.defaultHeight += kBtnHeight + verticalSpace;
    }
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake((self.defaultWidth - kIconWidth)/2, self.defaultHeight, kIconWidth, kIconHeight)];
    img.image = [UIImage imageNamed:imgName];
    [self.hubView addSubview:img];
    self.defaultHeight += kIconHeight + verticalSpace;
    
    float lblHeight = 0;
    if (string) {
        lblHeight = [self labelHeight:string font:textFont width:self.defaultWidth];
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(5, self.defaultHeight, self.defaultWidth-10 , lblHeight)];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.numberOfLines = 0;
        lbl.text = string;
        lbl.font = textFont;
        lbl.adjustsFontSizeToFitWidth = YES;
        [self.hubView addSubview:lbl];
        self.defaultHeight += lblHeight + verticalSpace;
    }
    
    if (sureBtn) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, self.defaultHeight, self.defaultWidth - 100, kBtnHeight)];
        [btn setTitle:NSLocalizedString(@"Determine", nil) forState:UIControlStateNormal];
        [btn setBackgroundColor: COLOR_MAIN];
        [btn.titleLabel setFont:textFont];
        [btn addTarget:self action:@selector(Dismiss) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 8.f;
        [self.hubView addSubview:btn];
        self.defaultHeight += verticalSpace + kBtnHeight;
    }
    
    //确定好defaultHeight后，显示
    [self HubViewShow:autoDismiss];
}




- (void)HubWithString:(NSString *)string
{
    self.stringShow = string;
    
    [self createHubViewWithStyle:StringStyle];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.defaultWidth - 30, self.defaultHeight)];
    
    lbl.text = string;
    
    lbl.textAlignment = NSTextAlignmentCenter;
    
    lbl.font = textFont;
    
    lbl.numberOfLines = 0;
    
    lbl.adjustsFontSizeToFitWidth = YES;
    
    [self.hubView addSubview:lbl];
    
    [self HubViewShow:YES];
}

/**
 * 加载风火轮
 */
- (void)HubLoading
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(!weakSelf.activityIndicator)
        {
            weakSelf.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            weakSelf.activityIndicator.center = UTkeyWindow.center;//只能设置中心，不能设置大小
            
            [UTkeyWindow addSubview:self.activityIndicator];
            weakSelf.activityIndicator.color = [UIColor grayColor];
        }
        
        [weakSelf.activityIndicator startAnimating]; // 开始旋转
        
    });
}
/**
 * 加载gif loadingView
 */

- (void)HubWithGif:(NSString *)imgName andType:(NSString *)type tipMessage:(NSString*)tipMessage warningMessage:(NSString *)warningMessage
{
    if(!self.loadingView)
    {
        self.loadingView = [[UIView alloc] init];
        self.loadingView.backgroundColor = [UIColor whiteColor];
        self.loadingView.layer.cornerRadius = 8.0f;
        self.loadingView.layer.masksToBounds = YES;
        
        self.loadingTitleLabel = [[UILabel alloc] init];
        self.loadingTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.loadingTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        self.loadingTitleLabel.numberOfLines = 0;
        self.loadingTitleLabel.textColor = COLOR_MAIN;
        self.loadingTitleLabel.adjustsFontSizeToFitWidth = YES;
        
        self.loadingimg = [[UIImageView alloc]init];
        self.loadingimg.contentMode = UIViewContentModeScaleAspectFit;
        self.loadingimg.animationDuration = 3.f;
        //    annimationImageView.animationDuration = 1.0f;
        //    annimationImageView.animationRepeatCount = 3;
        
        
        self.loadingTipLabel = [[UILabel alloc] init];
        self.loadingTipLabel.textAlignment = NSTextAlignmentCenter;
        self.loadingTipLabel.font = textFont;
        self.loadingTipLabel.numberOfLines = 0;
        self.loadingTipLabel.adjustsFontSizeToFitWidth = YES;
        
        self.loadingWarningLabel = [[UILabel alloc] init];
        self.loadingWarningLabel.textAlignment = NSTextAlignmentCenter;
        self.loadingWarningLabel.font = textFont;
        self.loadingWarningLabel.numberOfLines = 0;
        self.loadingWarningLabel.textColor = [UIColor redColor];
        self.loadingWarningLabel.adjustsFontSizeToFitWidth = YES;
        
        [self.loadingView addSubview:self.loadingTitleLabel];
        [self.loadingView addSubview:self.loadingimg];
        [self.loadingView addSubview:self.loadingTipLabel];
        [self.loadingView addSubview:self.loadingWarningLabel];

    }
    self.defaultWidth = kDefaultWidth;
    
    [self.loadingTitleLabel setText:NSLocalizedString(@"Process", nil)];
    self.loadingTitleLabel.frame = CGRectMake(5, 15, self.defaultWidth-10, kBtnHeight);
    self.defaultHeight = verticalSpace + kBtnHeight + verticalSpace;
    
    NSMutableArray * imageArray = [NSMutableArray array];
    for(int i = 1 ;i <= 5 ; i++)
    {
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d.%@",imgName,i,type]];
        [imageArray addObject:image];
    }
    
    //已存在，更新内容/frame
    self.loadingimg.animationImages = imageArray;
    self.loadingimg.frame = CGRectMake((self.defaultWidth - kIconWidth)/2, kBtnHeight + 20, kIconWidth, kIconHeight);
    [self.loadingimg startAnimating];
    
    self.defaultHeight = self.defaultHeight + verticalSpace + kIconHeight;
    
    float lblY = self.defaultHeight - 10;
    float lblHeight = 0;
    if (tipMessage) {
        lblHeight = [self labelHeight:tipMessage font:textFont width:self.defaultWidth];
        self.loadingTipLabel.text = tipMessage;
    }else{
        self.loadingTipLabel.text = @"";
    }
    self.loadingTipLabel.frame = CGRectMake(5, lblY, self.defaultWidth - 10, lblHeight);
    self.defaultHeight =  self.defaultHeight + verticalSpace + lblHeight;
    
    float warningLblHeight = 0;
    if (warningMessage) {
        warningLblHeight =  [self labelHeight:warningMessage font:textFont width:self.defaultWidth];
        self.loadingWarningLabel.text = warningMessage;
       
    }else{
        self.loadingWarningLabel.text = @"";
    }
     self.loadingWarningLabel.frame = CGRectMake(5, lblY + lblHeight + 5, self.defaultWidth - 10,warningLblHeight);
    self.defaultHeight =  self.defaultHeight + verticalSpace + warningLblHeight ;
    
    self.loadingView.frame = CGRectMake((kHubScreenWidth - self.defaultWidth)/2,kHubScreenHeight * 0.3, self.defaultWidth, self.defaultHeight);
    
    //show
    [self LoadingViewConfign];
}


#pragma create UI - - - - - - - - - - - - - - - - - - - - - - - - -

- (void)createLoadingView
{
    if(self.loadingView)
    {
        [self.loadingView removeFromSuperview];
        self.loadingView = nil;
    }
    
   // [self Dismiss];
    
    if(!self.loadingView)
    {
        self.loadingView = [[UIView alloc] init];
        
//        self.defaultWidth = 50;
//        self.defaultHeight = 70;
//
//        self.loadingView.frame = CGRectMake((kHubScreenWidth - self.defaultWidth)/2,kHubScreenHeight * 0.3, self.defaultWidth, self.defaultHeight);
        
        self.defaultWidth = 200;
        float height = 60.f;
        self.defaultHeight = [self labelHeight:self.stringShow font:textFont width:self.defaultWidth] + kIconHeight + height;
    }
}

- (void)createHubViewWithStyle:(HubStyle)style
{   
    if(self.hubView)
    {
        // 重置时间
        [self.hubView removeFromSuperview];
        self.hubView = nil;
    }
    
    self.hubView = [[UIView alloc]init];
    self.hubView.backgroundColor = [UIColor whiteColor];
    self.hubView.layer.cornerRadius = 8.0f;
    self.hubView.layer.masksToBounds = YES;
    
    [self DismissLoading];
    
    switch (style) {
        case StringStyle:
        {
            // 纯文字样式
            self.defaultWidth = kHubScreenWidth - levelSpace*2;
            self.defaultHeight = [self labelHeight:self.stringShow font:textFont width:self.defaultWidth] + 20;
           
        }
        break;
        case ImageStringStyle:
        {
            // 图片+文字
            self.defaultWidth = kDefaultWidth;
            self.defaultHeight = 0;
//            float height = 60.f;
//            self.defaultHeight = [self labelHeight:self.stringShow font:textFont width:self.defaultWidth] + kIconHeight + height;
        }
            break;
        case ImageGifStyle:
        {
            // 动态图片样式
            self.defaultWidth = 70;
            self.defaultHeight = 90;
        }
            break;
        default:
        {
            
        }
            break;
    }
}
#pragma  mark  show  method - - - - - - - - - - - - - - - - - - - - - - - - -
- (void)HubViewShow:(BOOL)autoDismiss{
    
    self.hubView.frame = CGRectMake((kHubScreenWidth - self.defaultWidth)/2,kHubScreenHeight * 0.3, self.defaultWidth, self.defaultHeight);
    
    [self HubViewConfign];
    
    // 设置时间 - 移除hubview
    if (autoDismiss) {
        if(self.timer)
        {
            [self.timer invalidate];
            self.timer = nil;
        }
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:HubShowTime target:self selector:@selector(reciprocalDismissWithTime) userInfo:nil repeats:YES];
    }
}
// 定时关闭提示框
- (void)reciprocalDismissWithTime
{
    self.timerHubShow = HubShowTime;
//    
//    self.timerHubShow --;
//    
//    if(self.timerHubShow < 1)
//    {
//         NSLog(@"%d",self.timerHubShow);
    
        [self.timer invalidate];
        self.timer = nil;
        [self Dismiss];
//    }

}

//  提示框的样式配置、弹出动画
- (void)HubViewConfign
{
//    self.hubView.backgroundColor = kBgColor;

    for (UIView *subView in self.backView.subviews) {
        [subView removeFromSuperview];
    }
    [self.backView addSubview:self.hubView];
    [UTkeyWindow addSubview:self.backView];
    
    CGAffineTransform  transform;
    
    transform = CGAffineTransformScale(self.hubView.transform,1.2,1.2);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            
            //        self.hubView.alpha = 1;
            self.backView.alpha = 1;
            
            [self.hubView setTransform:transform];
            
        } completion:^(BOOL finished) {
            
        }];
    });
  
}

//  提示框的样式配置、弹出动画
- (void)LoadingViewConfign
{
    for (UIView *subView in self.backView.subviews) {
        [subView removeFromSuperview];
    }
//    self.loadingView.backgroundColor = [UIColor clearColor];
    UIButton *_btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width*0.8, 100, 45, 45)];
    [_btnCancel setImage:[UIImage imageNamed:@"Icon_Progress_cancel"] forState:UIControlStateNormal];
    [_btnCancel addTarget:self action:@selector(DismissLoadingView) forControlEvents:UIControlEventTouchUpInside];
   
    [self.backView addSubview:_btnCancel];
    [self.backView addSubview:self.loadingView];

    [UTkeyWindow addSubview:self.backView];
    
//    CGAffineTransform  transform;
    
//    transform = CGAffineTransformScale(self.loadingView.transform,1.2,1.2);
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            
            self.backView.alpha = 1;
            
            //        [self.loadingView setTransform:transform];
            
        } completion:^(BOOL finished) {
            
        }];
    }) ;
   

}


#pragma mark dismiss----------

// self.hubView Dismiss
- (void)Dismiss
{
    CGAffineTransform  transform;
    
    transform = CGAffineTransformScale(self.hubView.transform,0.1,0.1);
    
    CGAffineTransform newTransform = CGAffineTransformMakeScale(1.2, 1.2);
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.1 animations:^{
            
            [self.hubView setTransform:newTransform];
        }
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:0.2 animations:^{
                                 //                             [self.hubView setAlpha:0];
                                 [self.backView setAlpha:0];
                                 [self.hubView setTransform:transform];
                             } completion:^(BOOL finished){
                                 //                             [self.hubView removeFromSuperview];
                                 [self.backView removeFromSuperview];
                                 self.hubView = nil;
                                 
                             }];
                         }];
         
    });
   
}
- (void)DismissLoadingView
{
//    CGAffineTransform  transform;
    
//    transform = CGAffineTransformScale(self.loadingView.transform,0.1,0.1);
    
//    CGAffineTransform newTransform = CGAffineTransformMakeScale(1.2, 1.2);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
            
            //        [self.backView setTransform:newTransform];
        }
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:0.2 animations:^{
                                 [self.backView setAlpha:0];
                                 //                             [self.loadingView setTransform:transform];
                             } completion:^(BOOL finished){
                                 [self.backView removeFromSuperview];
                             }];
                         }];
    });
}
// activityIndicator Dismiss
- (void)DismissLoading
{
    //    if(self.loadingView)
    //    {
    //        [self.loadingView removeFromSuperview];
    //        self.loadingView = nil;
    //    }
    
    [self.activityIndicator stopAnimating];
}


#pragma logic method - - - - - - - - - - - - - - - - - - - - - - - - -

- (float)labelHeight:(NSString*)aString font:(UIFont *)font width:(float)width
{
    float defaultHeight = 20.0f;
    
    float returnHeight = 0;
    
    returnHeight = [self contentSize:aString font:font width:width].height;
    
    if(returnHeight < defaultHeight)
        return defaultHeight;
    
    return returnHeight + 20;
}

- (CGSize)contentSize:(NSString*)aString font:(UIFont *)font width:(float)width
{
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    NSDictionary * attributes = @{NSFontAttributeName : font,
                                  NSParagraphStyleAttributeName : paragraphStyle};
    
    CGSize contentSize = [aString boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                               options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                            attributes:attributes
                                               context:nil].size;
    return contentSize;
}


#pragma lazy
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kHubScreenWidth,kHubScreenHeight)];
        _backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _backView;
}
@end
