

#import "BaseViewController.h"
#import "CenterButton.h" // 按钮文字、图标居中


@interface BaseViewController ()
{
    CGFloat navigationY;
    CGFloat navBarY;
    CGFloat verticalY;
    BOOL _isShowMenu;
    
}
@property CGFloat original_height;
@property(nonatomic ,strong)UIView *overlay;

@end

float iphoneFontSize = 17.0f;
float ipadFontSize = 20.0f;

@implementation BaseViewController

- (id)init
{
    self = [super init];
    if(self)
    {
        [self.navigationController.navigationBar setTranslucent:NO];
        [self.navigationController setNavigationBarHidden:YES];
        navBarY = 0;
        navigationY = 0;
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.extendedLayoutIncludesOpaqueBars=YES;
    //    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController setNavigationBarHidden:NO];
    
    if ([self respondsToSelector:@selector(backgroundImage)]) {
        UIImage *bgimage = [self navBackgroundImage];
        [self setNavigationBack:bgimage];
    }
    if ([self respondsToSelector:@selector(setTitle)]) {
        NSMutableAttributedString *titleAttri = [self setTitle];
        [self set_Title:titleAttri];
    }
    if (![self leftButton]) {
        [self configLeftBaritemWithImage];
    }
    
    if (![self rightButton]) {
        [self configRightBaritemWithImage];
    }
    //去掉系统自带的黑边
    //    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    // 导航栏背景颜色
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    UIImage *bgImage = [UIImage imageWithColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    
    float titleFont = iphoneFontSize;

    // 导航栏字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:titleFont],
       
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    // 设置导航栏底部线条颜色的代码
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault]; //此处使底部线条颜色为红色
    [navigationBar setShadowImage:[UIImage imageWithColor:COLOR_NAVIBAR_BOTTOM_LINE_COLOR]];
    
    self.view.backgroundColor = COLOR_BACKGROUND;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self respondsToSelector:@selector(set_colorBackground)]) {
        UIColor *backgroundColor =  [self set_colorBackground];
        UIImage *bgimage = [UIImage imageWithColor:backgroundColor];
        
        [self.navigationController.navigationBar setBackgroundImage:bgimage forBarMetrics:UIBarMetricsDefault];
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.navigationController.navigationBar.bounds) + 20)];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.navigationController.navigationBar insertSubview:self.overlay atIndex:0];
        self.overlay.backgroundColor = backgroundColor;
    }
    
    if(self.navigationController.childViewControllers.count > 1)
    {
        // 第二层视图控制器，统一修改返回按钮样式
        [self initBackBar];
        
        self.navigationController.navigationBarHidden = NO;
        
    }else
    {
        //  self.navigationController.navigationBarHidden = YES;
        // 显示导航栏左侧设置按钮
        //        [self initLeftButtonWithIcon:[UIImage imageNamed:@"IconSettWhite"] withTitle:nil];
        //
        //        self.navigationController.navigationBarHidden = YES;
    }
}


-(void)setNavigationBack:(UIImage*)image
{
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:image ];
    [self.navigationController.navigationBar setShadowImage:image];
}

#pragma mark --- NORMAl

-(void)set_Title:(NSMutableAttributedString *)title
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
    label.numberOfLines=0;//可能出现多行的标题
    [label setAttributedText:title];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleClick:)];
    [label addGestureRecognizer:tap];
    self.navigationItem.titleView = label;
    
}


-(void)titleClick:(UIGestureRecognizer*)Tap
{
    
    UIView *view = Tap.view;
    if ([self respondsToSelector:@selector(title_click_event:)]) {
        [self title_click_event:view];
    }
}

#pragma mark -- left_item
-(void)configLeftBaritemWithImage
{
    if ([self respondsToSelector:@selector(set_leftBarButtonItemWithImage)]) {
        UIImage *image = [self set_leftBarButtonItemWithImage];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self  action:@selector(left_click:)];
        self.navigationItem.backBarButtonItem = item;
    }
}

-(void)configRightBaritemWithImage
{
    if ([self respondsToSelector:@selector(set_rightBarButtonItemWithImage)]) {
        UIImage *image = [self set_rightBarButtonItemWithImage];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self  action:@selector(right_click:)];
        self.navigationItem.rightBarButtonItem = item;
    }
}


#pragma mark -- left_button
-(BOOL)leftButton
{
    BOOL isleft =  [self respondsToSelector:@selector(set_leftButton)];
    if (isleft) {
        UIButton *leftbutton = [self set_leftButton];
        [leftbutton addTarget:self action:@selector(left_click:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
        self.navigationItem.leftBarButtonItem = item;
    }
    return isleft;
}

#pragma mark -- right_button
-(BOOL)rightButton
{
    BOOL isright = [self respondsToSelector:@selector(set_rightButton)];
    if (isright) {
        UIButton *right_button = [self set_rightButton];
        [right_button addTarget:self action:@selector(right_click:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:right_button];
        self.navigationItem.rightBarButtonItem = item;
    }
    return isright;
}


-(void)left_click:(id)sender
{
    if ([self respondsToSelector:@selector(left_button_event:)]) {
        [self left_button_event:sender];
    }
}

-(void)right_click:(id)sender
{
    if ([self respondsToSelector:@selector(right_button_event:)]) {
        [self right_button_event:sender];
    }
}

-(void)changeNavigationBarHeight:(CGFloat)offset
{
    [UIView animateWithDuration:0.3f animations:^{
        self.navigationController.navigationBar.frame  = CGRectMake(
                                                                    self.navigationController.navigationBar.frame.origin.x,
                                                                    navigationY,
                                                                    self.navigationController.navigationBar.frame.size.width,
                                                                    self.navigationController.navigationBar.frame.size.height-offset
                                                                    );
        verticalY = verticalY+offset;
        [self.navigationItem.leftBarButtonItem setBackgroundVerticalPositionAdjustment:verticalY forBarMetrics:UIBarMetricsDefault];
        [self.navigationItem.rightBarButtonItem setBackgroundVerticalPositionAdjustment:verticalY forBarMetrics:UIBarMetricsDefault];
        
    }];
}

-(void)changeNavigationBarTranslationY:(CGFloat)translationY
{
    self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(0, translationY);
}

-(void)setContentAlpha:(CGFloat)alpha
{
    for (UIView *subview in self.navigationController.navigationBar.subviews) {
        subview.alpha = alpha;
    }
}

#pragma mark - 导航栏标题、按钮、点击事件
- (void)titleSetting:(NSString *)title
{
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    lbl.text = title;
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont systemFontOfSize:16.0f];
    lbl.textColor = [UIColor colorWithRed:91/255.0f green:197/255.0f blue:232/255.0f alpha:1];
    self.navigationItem.titleView = lbl;
}

- (void)initBackBar
{
    UIButton *btn = [[UIButton alloc] init];
    
    btn.frame = CGRectMake(0, 0, 80, 44);
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"Nav_Left_Item_Back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor colorWithRed:31/255.0f green:140/255.0f blue:224/255.0f alpha:1] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    if(isPad)
    {
        btn.frame = CGRectMake(0, 0, 120, 44);
        btn.titleLabel.font = [UIFont systemFontOfSize:ipadFontSize];
    }else
    {
        btn.titleLabel.font = [UIFont systemFontOfSize:iphoneFontSize];
    }
}

- (void)initRightButtonWithIcon:(UIImage *)icon withTitle:(NSString *)titleStr
{
    
    CenterButton *btn = [self navigationButtonWithIcon:icon withTitle:titleStr];
    
    [btn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)initRightButtonWithTitle:(NSString *)titleStr
{
    
    UIButton *btn = [self navigationButtonWithTitle:titleStr];
    
    [btn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)initBackBarWithImage:(UIImage *)image{
    if (image == nil) {
        self.navigationItem.leftBarButtonItem = nil;
    }else{
        
        CenterButton *btn = [self navigationButtonWithIcon:image withTitle:nil];
        
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
}

- (void)initLeftButtonWithIcon:(UIImage *)icon withTitle:(NSString *)titleStr
{
    CenterButton *btn = [self navigationButtonWithIcon:icon withTitle:titleStr];
    
    [btn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (CenterButton *)navigationButtonWithIcon:(UIImage *)icon withTitle:(NSString *)titleStr
{
    CenterButton * btn = [CenterButton new];
    if (titleStr) {
        btn.frame = CGRectMake(0, 0, icon.size.width + 20, icon.size.height + 20);
    }else{
        btn.frame = CGRectMake(0, 0, icon.size.width , icon.size.height );
    }
    
    float fontSize = iphoneFontSize;
    if(isPad)
    {
        fontSize = ipadFontSize;
    }
    
    // 纯文字情况
    if(!icon)
    {
        btn.frame = CGRectMake(0, 0, [[Util shareInstance] calculateRowWidth:titleStr fontSize:fontSize height:icon.size.height] , icon.size.height );
    }
    
    btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [btn setImage:icon forState:UIControlStateNormal];
    [btn setTitle:titleStr forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return btn;
}

- (void)rightAction
{
}

- (void)leftAction
{
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}




- (UIButton *)navigationButtonWithTitle:(NSString *)titleStr
{
    UIButton * btn = [UIButton new];
    btn.frame = CGRectMake(0, 0, 80 ,44);
    btn.titleLabel.font = [UIFont systemFontOfSize:17.];
    [btn setTitle:titleStr forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return btn;
}

@end

