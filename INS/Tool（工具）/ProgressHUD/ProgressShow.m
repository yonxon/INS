
#import "ProgressShow.h"
#import "LXWaveProgressView.h"

typedef void(^voidBlock)(void);

// 取消block
typedef void(^CancelBlock)(void);

@interface UTProgressShow()

// 背景View
@property (nonatomic,copy) UIVisualEffectView *viewBG;

// 提示语
@property (nonatomic,strong) UILabel *lblNotice;

// 取消按钮
@property (nonatomic,strong) UIButton *btnCancel;
@property (nonatomic,copy) CancelBlock cancelBlock;


@property (nonatomic,assign) float progressValue;

@property (nonatomic,strong)LXWaveProgressView *waveProgressView;



@property (nonatomic,strong) UIView *tipsView;
@property (nonatomic,strong) UILabel *tipsViewLabel;

@property (nonatomic,copy) voidBlock tapBlock;




@end

@implementation UTProgressShow



/**
 *  单例
 *
 *  @return ZTTmpDataStorage
 */
+ (UTProgressShow *)shareInstance
{
    static UTProgressShow *_shareInstance = nil;
    
    static dispatch_once_t onePredicate;
    
    dispatch_once(&onePredicate, ^{
        _shareInstance = [[UTProgressShow alloc] init];
    });
    
    return _shareInstance;
}

/**
 * 显示下载进度视图
 */
+ (void)showProgress
{
    [[self shareInstance] showProgress];
}

/**
 * 关闭下载进度视图
 */
+ (void)dismissProgressView
{
    [[self shareInstance] dismissProgressView];
}

/**
 * 显示下载进度百分比
 */
+ (void)progressViewWithFloatValue:(float)value
{
    [[self shareInstance] progressViewWithFloatValue:value];
}

/**
 * 显示下载提示语
 */
+ (void)progressViewWithNoticeText:(NSString *)text
{
    [[self shareInstance] progressViewWithNoticeText:text];
}

+ (void)showTipsView:(NSString *)tips withTapBlock:(void (^) (void)) TapBlock
{
    [[self shareInstance] showTipsView:tips withTapBlock:TapBlock];
}


/** 显示进度视图 取消按钮 Block*/
+ (void)showProgressWithCancelBlock:(void (^)(void))cancelBlock
{
    [[self shareInstance] showProgressWithCancelBlock:cancelBlock];
}



- (void)showProgress
{
    [self showProgressWithIsShowCancel:NO CancelBlock:nil];
    
}


/** 显示进度视图 取消按钮 Block*/
- (void)showProgressWithCancelBlock:(void (^)(void))cancelBlock
{
    [self showProgressWithIsShowCancel:YES CancelBlock:cancelBlock];
}



/** 显示进度视图 是否显示取消按钮*/
- (void)showProgressWithIsShowCancel:(BOOL)isShowCancel CancelBlock:(void (^)(void))cancelBlock
{
    if(!_viewBG)
    {
        //毛玻璃视图
        UIBlurEffect *blurEffrct =[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        
        _viewBG = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];
        _viewBG.frame = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height);
        _viewBG.alpha = 0.8;
        
        [UTkeyWindow addSubview:_viewBG];
    }
    
    if(!_lblNotice)
    {
        _lblNotice = [[UILabel alloc] initWithFrame:CGRectMake(0, 450, Main_Screen_Width, 40)];
        _lblNotice.backgroundColor = [UIColor clearColor];
        _lblNotice.textColor = COLOR_MAIN;
        _lblNotice.textAlignment = NSTextAlignmentCenter;
        _lblNotice.font = [UIFont boldSystemFontOfSize:20.0f];
        _lblNotice.adjustsFontSizeToFitWidth = YES;
        [UTkeyWindow addSubview:_lblNotice];
    }
    
    if(!_waveProgressView)
    {
        _waveProgressView = [[LXWaveProgressView alloc] initWithFrame:CGRectMake(Main_Screen_Width/2 - 50, 300, 100, 100)];
        _waveProgressView.progress = 0;
        _waveProgressView.speed = 0.8;
        _waveProgressView.firstWaveColor =  COLOR_MAIN_Wave;
        _waveProgressView.secondWaveColor =  COLOR_MAIN;
        
        [UTkeyWindow addSubview:_waveProgressView];
    }

    
    if(!_btnCancel)
    {
        _btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width*0.8, 100, 50, 50)];
        [_btnCancel setImage:[UIImage imageNamed:@"Icon_Progress_cancel"] forState:UIControlStateNormal];
        [_btnCancel addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [UTkeyWindow addSubview:_btnCancel];
    }
    
    _cancelBlock = cancelBlock;
    _btnCancel.hidden = !isShowCancel;
}

/** 取消按钮事件*/
- (void)cancelBtnAction
{
    [self dismissProgressView];
    
    if(_cancelBlock)
    {
        _cancelBlock();
        _cancelBlock = nil;
    }
}

- (void)progressViewWithNoticeText:(NSString *)text
{
    self.lblNotice.text = text;
}

- (void)progressViewWithFloatValue:(float)value
{
 self.waveProgressView.progress = value;
}

- (void)showProgressValue
{
    self.waveProgressView.progress = self.progressValue;
}

/** 关闭界面*/
- (void)dismissProgressView
{
    __weak typeof(self) weakSelf = self;
    if(_viewBG)
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.viewBG removeFromSuperview];
            weakSelf.viewBG = nil;
        });
        
    }
    
    if(_waveProgressView)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.waveProgressView removeFromSuperview];
            weakSelf.waveProgressView = nil;
        });
        
    }
    
    if(_lblNotice)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.lblNotice removeFromSuperview];
            weakSelf.lblNotice = nil;
        });
    }
    
    if(_btnCancel)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.btnCancel removeFromSuperview];
            weakSelf.btnCancel = nil;
        });
    }
}



- (void)showTipsView:(NSString *)tips withTapBlock:(void (^) (void)) TapBlock
{
    if (!self.tipsView)
    {
        self.tipsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0)];
        self.tipsView.backgroundColor = [UIColor colorWithRed:125/255.0f green:125/255.0f blue:125/255.0f alpha:1];
        self.tipsView.alpha = 1;
        
        self.tipsViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, Main_Screen_Width-40, 44)];
        self.tipsViewLabel.font = [UIFont systemFontOfSize:14];
        self.tipsViewLabel.textColor = [UIColor whiteColor];
        self.tipsViewLabel.textAlignment = NSTextAlignmentCenter;
        [self.tipsView addSubview:self.tipsViewLabel];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        
        [self.tipsView addGestureRecognizer:gesture];
        
        [UTkeyWindow addSubview:self.tipsView];
        
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect rect = self.tipsView.frame;
            rect.size.height += 64;
            [self.tipsView setFrame:rect];;
            
        } completion:^(BOOL finished) {
         
        }];
    }
    self.tipsViewLabel.text = tips;
    self.tapBlock = TapBlock;
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(removeTipsView) userInfo:nil repeats:NO];
}

- (void)tap
{
    [self removeTipsView];
    if (self.tapBlock)
    {
        self.tapBlock();
    }
}

- (void)removeTipsView
{
    if (self.tipsView)
    {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect rect = self.tipsView.frame;
            rect.size.height -= 64;
            [self.tipsView setFrame:rect];;
            
        } completion:^(BOOL finished) {
            [self.tipsView removeFromSuperview];
            self.tipsView = nil;
        }];
       
    }
}


@end
