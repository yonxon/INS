

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
    
   [[RequestTool shareInstance] GETWithURLString:URLString parameters:parameters hud:YES success:success failure:failure responseObject:nil];
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
 *  @param URLString        请求方法
 *  @param parameters        请求的参数
 *  @param hud              是否显示加载提示框
 *  @param success          请求成功的回调代码块
 *  @param failure          请求失败
 *  @param responseObj      响应的结果  id 类型
 */
- (void)GETWithURLString:(NSString *)URLString
           parameters:(id)parameters
                  hud:(BOOL)hud
              success:(void (^)(id successData))success
              failure:(void (^)(NSError *error))failure
       responseObject:(void (^)(id responseObject))responseObj
{
    NSString *fullURL = [self completeURLString:URLString];
    
    [self GETFullString:fullURL parameters:parameters hud:hud success:success failure:failure responseObject:responseObj];
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
       
        [MessageShow ShowLoding];
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
    manager.requestSerializer.timeoutInterval = RequestTimeOut;
    
    [manager.requestSerializer setValue:USER_INFOR.jwt forHTTPHeaderField:@"Authorization"];
    
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
     
    NSLog(@"\n\nGET请求地址:%@ \n\nGET请求参数:%@",FullURLString,dicRequest);
    
    [manager GET:FullURLString parameters:dicRequest progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        if(hud)
        {
            [MessageShow DismissHubGif];
        }
 
        if(responseObj)
        {
            responseObj(responseObject);
        }
            
        if(success)
        {
            NSDictionary *jsonDict = [weaksSelf resolveResult:responseObject];
            success(jsonDict);
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
        {
            failure(error);
            
            if (hud) {
                [MessageShow DismissHubGif] ;
            }
        }
    }];
}




#pragma mark - 字符串拼接 - - - - - - - - - - - - - - - - - -
/** 拼接URL,IP、端口*/
- (NSString *)completeURLString:(NSString *)url
{
   return [NSString stringWithFormat:@"%@%@:%@%@%@",rPrefix,rDefaultIP,rDefaultPort,rSuffix,url];
    
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
    __weak typeof(self) weakSelf = self;
    
    if (hud) {
        [MessageShow ShowLoding];
    }
    
   NSString *fullURL = [self completeURLString:URLString];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:fullURL parameters:nil error:nil];
    request.timeoutInterval= RequestTimeOut;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // 设置body
    NSData *body = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:body];
    
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",@"text/plain", nil];
    manager.responseSerializer = responseSerializer;
    
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {

        if (!error) {
            if (hud) {
                [MessageShow DismissHubGif];
            }
            
            NSDictionary *jsonDict = [weakSelf resolveResult:responseObject];
            
            success(jsonDict);

        } else {
            
            if (hud) {
                [MessageShow DismissHubGif];
            }
            
            if(failure)
            {
                failure(error);
            }
        }
    }] resume];

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
    manager.requestSerializer.timeoutInterval = RequestTimeOut;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
    
    [AFURLPostRequestSerialization exchangeAFRequestSerialization];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];// 请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];// 响应
    manager.requestSerializer.timeoutInterval = RequestTimeOut;
    
    
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


/** 请求结果转换为 NSDictionary*/
- (NSDictionary *)resolveResult:(id  _Nullable )responseObject
{
    NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
    
    NSData * datas = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingMutableLeaves error:nil];
    
    return jsonDict;
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
