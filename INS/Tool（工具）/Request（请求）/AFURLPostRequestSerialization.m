

#import "AFURLPostRequestSerialization.h"

@implementation AFURLPostRequestSerialization

+ (void)exchangeAFRequestSerialization
{
    static dispatch_once_t disOnce;
    
    dispatch_once(&disOnce,^ {
        //只执行一次的代码
        // 1.获取系统URLWithString方法
        Method URLWithStr = class_getInstanceMethod([AFHTTPRequestSerializer class], @selector(requestBySerializingRequest:withParameters:error:));
        
        // 2.获取自定义的SHURLWithString方法
        Method SHURLWithStr = class_getInstanceMethod([AFURLPostRequestSerialization class], @selector(postRequestBySerializingRequest:withParameters:error:));
        
        // runtime方法之一：交换两个方法的实现。
        method_exchangeImplementations(URLWithStr, SHURLWithStr);
        
    });
   
}

- (NSURLRequest *)postRequestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(request);
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    [self.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (![request valueForHTTPHeaderField:field]) {
            [mutableRequest setValue:value forHTTPHeaderField:field];
        }
    }];
    
    NSString *query = nil;
    if (parameters) {
        query = AFQueryStringFromParameters(parameters);
    }
    
    if ([self.HTTPMethodsEncodingParametersInURI containsObject:[[request HTTPMethod] uppercaseString]]) {
        if (query && query.length > 0) {
            mutableRequest.URL = [NSURL URLWithString:[[mutableRequest.URL absoluteString] stringByAppendingFormat:mutableRequest.URL.query ? @"&%@" : @"?%@", query]];
        }
    } else {
        // #2864: an empty string is a valid x-www-form-urlencoded payload
        if (!query) {
            query = @"";
        }
        if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
            [mutableRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        }
        //增加对参数为字符串类型的支持 2018-8-15王芳
        if ([parameters isKindOfClass:[NSString class]]) {
            [mutableRequest setHTTPBody:[parameters dataUsingEncoding:self.stringEncoding]];
        }else{
            [mutableRequest setHTTPBody:[query dataUsingEncoding:self.stringEncoding]];
        }
    }
    
    return mutableRequest;
}
@end
