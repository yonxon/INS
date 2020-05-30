

#import "RequestTool.h"

@implementation RequestTool




+ (RequestTool *)shareInstance
{
    static RequestTool *_shareInstance;
    static dispatch_once_t onePredicate;
    
    dispatch_once(&onePredicate, ^{
        
        _shareInstance = [[RequestTool alloc] init];
    });
    
    return _shareInstance;
}

/**
 *  GET方法请求
 *
 *  @param URLString 请求的URL地址
 *  @param parameters 请求的参数
 *  @param success   请求成功的回调代码块
 *  @param failure   请求失败
 */
+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure
{
    
   [[RequestTool shareInstance] GETFullString:URLString parameters:parameters hud:YES success:success failure:failure responseObject:nil];
}


/**
 *  发送post请求
 *
 *  @param URLString  请求的基本的url
 *  @param parameters 请求的参数字典
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure
{
    [[RequestTool shareInstance]POST:URLString parameters:parameters hud:YES success:success failure:failure];

}


/**
 *  发送delete请求
 *
 *  @param URLString  请求的基本的url
 *  @param parameters 请求的参数字典
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)DELETE:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure
{
    [[RequestTool shareInstance]Delete:URLString parameters:parameters hud:YES success:success failure:failure];
}





/**
 *  GET方法请求、是否加密
 *
 *  @param FullURLString    完整请求的URL地址
 *  @param parameters        请求的参数
 *  @param hud              是否显示加载提示框
 *  @param success          请求成功的回调代码块
 *  @param failure          请求失败
 *  @param responseObj      响应的结果  id 类型
 */
- (void)GETFullString:(NSString *)FullURLString
           parameters:(id)parameters
                  hud:(BOOL)hud
              success:(void (^)(id successData))success
              failure:(void (^)(NSError *error))failure
       responseObject:(void (^)(id responseObject))responseObj
{
    
    NSMutableDictionary *dicRequest = [[NSMutableDictionary alloc] init];
    
    if([parameters isKindOfClass:[NSDictionary class]] ||
       [parameters isKindOfClass:[NSMutableDictionary class]])
    {
        [dicRequest setDictionary:parameters];
    }
    
    __weak typeof(self) weaksSelf = self;
    if (hud) {
    }
    
    if(!parameters)
    {
        parameters = [[NSDictionary alloc] init];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];// 请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];// 响应
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
     
    NSLog(@"\n\nGET请求地址:%@ \n\nGET请求参数:%@",FullURLString,dicRequest);
    
    [manager GET:FullURLString parameters:dicRequest progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if(responseObj)
        {
            responseObj(responseObject);
        }
        
        if (success) {
            
            NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            
            // 截掉前后 双引号
               
              NSString  * string = [str substringWithRange:NSMakeRange(1, str.length - 2)];
               
            // 去掉反斜杠
          string = [string stringByReplacingOccurrencesOfString:@"\\" withString:@""];
            // 将上面处理结果JSON字符串转换成 NSDictionary
            NSDictionary *dic = [self dictionaryWithJsonString:string];
       
            success(dic);
            if (hud) {
//                [weaksSelf dismissShow];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
        {
            failure(error);
            
            if (hud) {
//                [weaksSelf dismissShow] ;
            }
        }
    }];
}







/**
 *  发送post请求
 *
 *  @param URLString  请求的基本的url
 *  @param parameters 请求的参数字典/字符串
 *  @param hud        是否显示加载提示框
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
- (void)POST:(NSString *)URLString
      parameters:(id)parameters
             hud:(BOOL)hud
         success:(void (^)(id responseObject))success
         failure:(void (^)(NSError *error))failure
{
//    if (hud) {
//        [SVProgressHUD show];
//    }
//
////URLString =  @"http://192.168.80.22:8789/UTAPPService/CLDYG/SaveWorkingExamByPost/646565D8-F260-482E-87FA-7C7CC96C450D&3";
//
//    // 如果是扫码答题，URL样式为 http://192.168.80.62:8789/UTAPPService/CLDYG/SaveWorkingExamChuQin/B32AD8B4-3D04-4FA8-AFE6-DDD5E04B64DC&2&1
//    if ([URLString containsString:rSaveWorkingExamChuQinPost]) {
//        URLString = [[RequestUtil shareInstance] completeURLString:URLString];
//    }
//    // 非扫码答题，仍旧采用之前的方式
//    else {
//        URLString = [[RequestUtil shareInstance] completeURLString:headString];
//    }
//
//
//
    NSLog(@"请求地址  %@",URLString);
    NSLog(@"请求参数  %@",parameters);
    // 请求字符串
//    NSString *requestString = [RequestParameter POSTRequestData:parameters];

    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10.f;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [AFURLPostRequestSerialization exchangeAFRequestSerialization];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];// 请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];// 响应
    manager.requestSerializer.timeoutInterval = 10.f;
    
    
    NSDictionary *parameters11 = @{@"username":@"1",
                                     @"account":@"1",
                                     @"password":@"1"
                                     };

    
    [manager  POST:URLString parameters:parameters11 progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        
          NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
         NSDictionary *dicResponse = [self dictionaryWithJsonString:aString];

       
        if(!dicResponse)
        {
            return ;
        }

        if(success)
        {
            success(dicResponse);
        }

        if (hud) {
//            [self dismissShow];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure)
        {
            failure(error);

            if (hud) {
//                [self dismissShow] ;
            }
        }
    }];
    
    
    
    
//    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        }];
}







/**
 *  发送Delete请求
 *
 *  @param URLString  请求的基本的url
 *  @param parameters 请求的参数字典/字符串
 *  @param hud        是否显示加载提示框
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
- (void)Delete:(NSString *)URLString
      parameters:(id)parameters
             hud:(BOOL)hud
         success:(void (^)(id responseObject))success
         failure:(void (^)(NSError *error))failure
{
    NSLog(@"请求地址  %@",URLString);
    NSLog(@"请求参数  %@",parameters);


    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10.f;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
    
    [AFURLPostRequestSerialization exchangeAFRequestSerialization];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];// 请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];// 响应
    manager.requestSerializer.timeoutInterval = 10.f;
    
    
    NSDictionary *parameters11 = @{@"username":@"1",
                                     @"account":@"1",
                                     @"password":@"1"
                                     };

    
    [manager  POST:URLString parameters:parameters11 progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        
          NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
         NSDictionary *dicResponse = [self dictionaryWithJsonString:aString];

       
        if(!dicResponse)
        {
            return ;
        }

        if(success)
        {
            success(dicResponse);
        }

        if (hud) {
//            [self dismissShow];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure)
        {
            failure(error);

            if (hud) {
//                [self dismissShow] ;
            }
        }
    }];
}







/** 下载文件
 *  requestPath   下载地址
 *  successBlock  成功回调
 */
- (void)DownLoadFile:(NSString *)requestPath
        SuccessBlock:(void (^)(void))SuccessBlock
{
    // 文件默认下载到 downLoadPath 里面
//    [[RequestFile shareInstance] DownLoadFile:requestPath savePath:downLoadPath SuccessBlock:SuccessBlock];
}



/** JSON字符串转换成 NSDictionary*/
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}



@end


#pragma mark - Session 下载
//- (void)sessionDownload
//{
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:config];
//
//  NSString *urlString = @"http://localhost/itcast/images/head1.png";
//  urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//    NSURL *url = [NSURL URLWithString:urlString];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//
//    NSURLSessionDataTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//         // 指定下载文件保存的路径
//         // NSLog(@"%@ %@", targetPath, response.suggestedFilename);
//         // 将下载文件保存在缓存路径中
//
//        NSString *cacheDir =  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//
//        NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
//
//         // URLWithString返回的是网络的URL,如果使用本地URL,需要注意
//        NSURL *fileURL1 = [NSURL URLWithString:path];
//        NSURL *fileURL = [NSURL fileURLWithPath:path];
//
//        NSLog(@"== %@ |||| %@", fileURL1, fileURL);
//
//        return fileURL;
//    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//        NSLog(@"%@ %@", filePath, error);
//    }];
//[task resume];
//
//
//}
