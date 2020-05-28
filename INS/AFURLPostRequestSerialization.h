

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface AFURLPostRequestSerialization : AFHTTPRequestSerializer
+ (void)exchangeAFRequestSerialization;
@end

NS_ASSUME_NONNULL_END
