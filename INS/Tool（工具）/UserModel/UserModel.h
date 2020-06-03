
#import <Foundation/Foundation.h>





@interface UserModel : NSObject


@property (nonatomic, strong) NSNumber *isLogin;//是否已登录  0:未登录  1:登录
@property (nonatomic, strong) NSString *UserName;//姓名

// 请求用的头
@property (nonatomic, strong) NSString *jwt;//姓名


+ (UserModel *)shareUser;

/**
 *  保存数据
 */
- (void)saveData;

/**
 *  初始化
 */
- (void)initData;


/** 清除文件*/
- (void)clear;


/** 版本兼容 - 更新文件字段，确保新增的字段可用*/
- (void)updateDataField;

@end
