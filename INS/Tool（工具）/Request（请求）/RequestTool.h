
#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "AFURLPostRequestSerialization.h"

@interface RequestTool : NSObject


+ (RequestTool *)shareInstance;




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
     failure:(void (^)(NSError *error))failure;


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
    failure:(void (^)(NSError *error))failure;


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
       failure:(void (^)(NSError *error))failure;


/** 下载文件
 *  requestPath   下载地址
 *  successBlock  成功回调
 */
- (void)DownLoadFile:(NSString *)requestPath
        SuccessBlock:(void (^)(void))SuccessBlock;


@end
