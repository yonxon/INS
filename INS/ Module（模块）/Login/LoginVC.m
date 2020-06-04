//
//  LoginVC.m
//  INS
//
//  Copyright © 2020 lu peihan. All rights reserved.
//

#import "LoginVC.h"
#import "AppDelegate.h"
#import "WXApi.h"

// 临时
#import "RequestTool.h"
#import "DepartMent.h"



@interface LoginVC ()<WXApiDelegate,UIApplicationDelegate>
{
    NSString *_code;//用户换取access_token的code，仅在ErrCode为0时有效
    /*    NSString *_accessToken;//接口调用凭证
     NSString *_refreshToken;//用户刷新access_token
     NSString *_openid;//授权用户唯一标识
     NSString *_scope;//用户授权的作用域，使用逗号（,）分隔
     NSString *_unionid; //当且仅当该移动应用已获得该用户的userinfo授权时，才会出现该字段*/
}

@property (nonatomic,weak) IBOutlet UIImageView *imgWeChat;
@property (nonatomic,weak) IBOutlet UILabel *lblWechat;
@property (nonatomic,weak) IBOutlet UITextField *txtPhone;

@property (nonatomic,weak) IBOutlet UILabel *lblLogo;
@property (nonatomic,weak) IBOutlet UILabel *lblLogo2;

@property (nonatomic,weak) IBOutlet UIView *viewLogo;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loginWeChat)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.imgWeChat addGestureRecognizer:tap];
    
    [self gotoHomeView];
    

   NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"ins" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"BillabongW00-Regular" size: 100],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    self.lblLogo.attributedText = string;

    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:@"instranger" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"BillabongW00-Regular" size: 30],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    self.lblLogo2.attributedText = string2;
    
    
}


- (void)showWeChatLogin
{
    if([WXApi isWXAppInstalled])
    {
        self.imgWeChat.userInteractionEnabled = YES;
        self.imgWeChat.hidden = NO;
        self.lblWechat.hidden = NO;
    }else
    {
        self.imgWeChat.hidden = YES;
        self.lblWechat.hidden = YES;
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    [self showWeChatLogin];
}

// 直接进入首页
- (void)gotoHomeView
{
    NSNumber *isLogin = USER_INFOR.isLogin;
    if([isLogin isEqual:@1])
    {
         [((AppDelegate*) AppDelegateInstance) setupHomeViewController];
    }
  
}


// 登录
- (IBAction)login:(id)sender
{
    // 登录请求代码 已调通
    [RequestTool POST:rLoginOnekey
           parameters:@{@"user_phone":self.txtPhone.text}
              success:^(id responseObject)
     {

         NSDictionary *dic = responseObject;
         if([dic[KeySuccess] integerValue] == RequestSuccess)
         {
             NSString *jwt = dic[@"object"];
             USER_INFOR.jwt = jwt;
             USER_INFOR.isLogin = @1;
             [USER_INFOR saveData];
              [((AppDelegate*) AppDelegateInstance) setupHomeViewController];
         }
         
     } failure:^(NSError *error) {

         [MessageShow ShowSuccessString:@"登录成功"];
     }];
}

// 帮助
- (IBAction)btnHelp:(id)sender
{
     [MessageShow ShowString:@"帮助"];
}

// 退出
- (IBAction)btnQuit:(id)sender
{
    [UIView animateWithDuration:1.0f animations:^{
        INSkeyWindow.alpha = 0;
        INSkeyWindow.frame = CGRectMake(0, INSkeyWindow.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
}


// 用户协议
- (IBAction)btnYHXY:(id)sender
{
    [MessageShow ShowString:@"用户协议"];
}

// 隐私政策
- (IBAction)btnYSTK:(id)sender
{
    [MessageShow ShowString:@"隐私政策"];
}

// 中国移动认证服务条款
- (IBAction)btnZGYD:(id)sender
{
    [MessageShow ShowString:@"中国移动认证服务条款"];
}


#warning 临时参考调用代码
// 数据请求
- (void)requestTest
{
//    [RequestTool POST:rLoginOnekey
//          parameters:@{@"user_phone":@"15918708414" }
//             success:^(id responseObject)
//    {
//
//    } failure:^(NSError *error) {
//
//    }];
   
//    NSString *url = @"/users/info/c9c4756847584a999cfc91b8e2a78c89";
//    
////    rUsersInfo
//    [RequestTool GET:rUsersInfo parameters:nil success:^(id responseObject) {
//
//    } failure:^(NSError *error) {
//
//    }];
    
}

/** 弹出框调用示例*/
- (void)messageShow
{
    [MessageShow ShowSuccessString:@"成功"];
    
    [MessageShow ShowErrorString:@"失败"];
    
    [MessageShow showWithTitle:@"标题" message:@"消息内容" OKBlock:^{
        
    } CancelBlock:^{
        
    }];
}

// 数据库调用示例
- (void)DBTest
{
    //  批量保存
    NSMutableArray *arrayData = [[NSMutableArray alloc] init];
    NSDictionary *dicDepartMent = @{@"Dept":@"123459789"};
    NSDictionary *dicDepartMent2 = @{@"Dept":@"呵呵"};
    DepartMent *model1 = [DepartMent modelWithDict:dicDepartMent];
    DepartMent *model2 = [DepartMent modelWithDict:dicDepartMent2];
    [arrayData addObject:model1];
    [arrayData addObject:model2];
    [DepartMent saveObjects:arrayData];
    
    //  单个保存
    // 字典转model
   NSDictionary *dicDepartMent3 = @{@"Dept":@"字典转model"};
    DepartMent *model3 = [DepartMent modelWithDict:dicDepartMent3];
    [model3 save];

    // 更新
    model3.Dept = @"0000";
    [model3 update];
    
    // 查询
    NSArray *arrayDB = [DepartMent findByCriteria:[NSString stringWithFormat:@"WHERE Dept=%@",@"123459789"]];
    
    // 查询
    NSArray *arr = [DepartMent findAll];
    
    // 删除 方式一
    //     [DepartMent deleteObjectsByCriteria:[NSString stringWithFormat:@"Where Dept = '%@'",@"0000"]];
    // 删除 方式二
    [DepartMent deleteObjects:arr Column:@"Dept" value:@"0000"];
    
        // 清空
    [DepartMent clearTable];
}







#pragma mark - 微信登录
- (void)loginWeChat{
    //判断微信是否安装
    if([WXApi isWXAppInstalled]){
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"App";
        [WXApi sendAuthReq:req viewController:self delegate:self];
    }else{
        [self setupAlertController];
    }
}

- (void)setupAlertController{
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfim = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [vc addAction:actionConfim];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)wxLogin:(NSNotification*)noti{
    //获取到code
    SendAuthResp *resp = noti.object;
    NSLog(@"%@",resp.code);
    _code = resp.code;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=%@",appId,appSecret,_code,@"authorization_code"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"text/html; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableSet *mgrSet = [NSMutableSet set];
    mgrSet.set = manager.responseSerializer.acceptableContentTypes;
    [mgrSet addObject:@"text/html"];
    //因为微信返回的参数是text/plain 必须加上 会进入fail方法
    [mgrSet addObject:@"text/plain"];
    [mgrSet addObject:@"application/json"];
    manager.responseSerializer.acceptableContentTypes = mgrSet;
    
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
        NSDictionary *resp = (NSDictionary*)responseObject;
        NSString *openid = resp[@"openid"];
        NSString *unionid = resp[@"unionid"];
        NSString *accessToken = resp[@"access_token"];
        NSString *refreshToken = resp[@"refresh_token"];
        if(accessToken && ![accessToken isEqualToString:@""] && openid && ![openid isEqualToString:@""]){
            [[NSUserDefaults standardUserDefaults] setObject:openid forKey:WX_OPEN_ID];
            [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:WX_ACCESS_TOKEN];
            [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:WX_REFRESH_TOKEN];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [self getUserInfo];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
}

- (void)authAccessToken{
    //验证accessToken是否是成功
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:WX_ACCESS_TOKEN];
    NSString *openid = [[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID];
    if(!accessToken || [accessToken isEqualToString:@""] || !openid || [openid isEqualToString:@""]){
        //如果没登陆过，则登陆
        [self loginWeChat];
    }else{
        //否则验证access token 是否还有效
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/auth?access_token=%@&openid=%@",accessToken,openid];
        
        NSMutableSet *mgrSet = [NSMutableSet set];
        mgrSet.set = manager.responseSerializer.acceptableContentTypes;
        [mgrSet addObject:@"text/html"];
        //因为微信返回的参数是text/plain 必须加上 会进入fail方法
        [mgrSet addObject:@"text/plain"];
        [mgrSet addObject:@"application/json"];
        manager.responseSerializer.acceptableContentTypes = mgrSet;
        
        [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"success");
            NSDictionary *resp = (NSDictionary*)responseObject;
            if([resp[@"errcode"] intValue] == 0){
                //有效则直接获取信息
                [self getUserInfo];
            }else{
                //否则使用refreshtoken来刷新accesstoken
                [self refreshAccessToken];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"fail");
            NSLog(@"%@",task.response);
        }];
    }
    
    
}

- (IBAction)refreshAccessToken:(UIButton *)sender {
    
    [self refreshAccessToken];
    
}

- (void)refreshAccessToken{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&refresh_token=%@&grant_type=%@",[[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID],[[NSUserDefaults standardUserDefaults] objectForKey:WX_REFRESH_TOKEN],@"REFRESH_TOKEN"];
    
    NSMutableSet *mgrSet = [NSMutableSet set];
    mgrSet.set = manager.responseSerializer.acceptableContentTypes;
    [mgrSet addObject:@"text/html"];
    //因为微信返回的参数是text/plain 必须加上 会进入fail方法
    [mgrSet addObject:@"text/plain"];
    [mgrSet addObject:@"application/json"];
    manager.responseSerializer.acceptableContentTypes = mgrSet;
    
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
        NSDictionary *resp = (NSDictionary*)responseObject;
        NSString *openid = resp[@"openid"];
        NSString *accessToken = resp[@"access_token"];
        NSString *refreshToken = resp[@"refresh_token"];
        if(refreshToken){
            if(accessToken && ![accessToken isEqualToString:@""] && openid && ![openid isEqualToString:@""]){
                [[NSUserDefaults standardUserDefaults] setObject:openid forKey:WX_OPEN_ID];
                [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:WX_ACCESS_TOKEN];
                [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:WX_REFRESH_TOKEN];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }else{
            //如果refreshToken为空，说明refreshToken也过期了，需要重新登陆
            [self loginWeChat];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"fail");
        NSLog(@"%@",task.response);
    }];
}


- (void)getUserInfo{
    //获取个人信息
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",[[NSUserDefaults standardUserDefaults] objectForKey:WX_ACCESS_TOKEN],[[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID]];
    
    NSMutableSet *mgrSet = [NSMutableSet set];
    mgrSet.set = manager.responseSerializer.acceptableContentTypes;
    [mgrSet addObject:@"text/html"];
    //因为微信返回的参数是text/plain 必须加上 会进入fail方法
    [mgrSet addObject:@"text/plain"];
    [mgrSet addObject:@"application/json"];
    manager.responseSerializer.acceptableContentTypes = mgrSet;
    
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
        
        NSLog(@"%@",responseObject);
        NSDictionary *resp = (NSDictionary*)responseObject;
        //        self->_nicknameLabel.text = resp[@"nickname"];
        //        self->_sexLabel.text = [resp[@"sex"] intValue] == 1 ? @"男" : @"女";
        //        self->_addressLabel.text = [NSString stringWithFormat:@"%@%@%@",resp[@"country"],resp[@"province"],resp[@"city"]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"fail");
        NSLog(@"%@",task.response);
    }];
}

@end
