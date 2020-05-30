
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BlockButton.h"



@interface Util : NSObject


/**
 *  单例
 *
 *  @return ZTOperation
 */
+ (Util *)shareInstance;

#pragma mark NSUserDefaults 存取 - - - - - - - - - - - - - - - - - - - - - -

/**
 *  NSUserDefaults 储存
 *
 *  @param key    key
 *  @param object vaule
 */
- (void)defaultObjectSetWithKey:(NSString *)key object:(id)object;

/**
 *  NSUserDefaults 储存Model类型数据
 *
 *  @param key    key
 *  @param object vaule
 */
- (void)defaultModelSetWithKey:(NSString *)key object:(id)object;

/**
 *  NSUserDefaults 储存
 *
 *  @param key       key
 *  @param boolValue value
 */
- (void)defaultBoolSetWithKey:(NSString *)key boolValue:(BOOL)boolValue;

/**
 *  NSUserDefaults 取值
 *
 *  @param key key
 *
 *  @return id
 */
- (id)defaultObjectGetWithKey:(NSString *)key;

/**
 *  NSUserDefaults 取值
 *
 *  @param key key
 *
 *  @return Model 数据
 */
- (id)defaultModelGetWithKey:(NSString *)key;

/**
 *  NSUserDefaults 取值
 *
 *  @param key key
 *
 *  @return BOOL
 */
- (BOOL)defaultBoolGetWithKey:(NSString *)key;

/**
 *  NSUserDefaults 存值-webview加载完成时
 */
- (void)defaultWebViewDidFinishLoad;

/**
 *  移除对象
 *
 *  @param key key
 */
- (void)defaultRemoveObjectWithKey:(NSString *)key;

#pragma mark - 创建UI - - - - - - - - - - - - - - - - - - -
/** 创建导航栏按钮*/
- (UIButton *)createNavigationItemButtonWithImage:(UIImage*)image Width:(float)width;

#pragma mark - 时间 - - - - - - - - - - - - - - - - - - -
/**
 *   判断传入时间对比当前系统时间是否过期，精确到“时”
 *   stringDate   待对比的时间
 *   retrurn      YES:未到期  NO:已经到期
 */
- (BOOL)timeIsInTheFuture:(NSString *)stringDate;

/**
 *   返回当前日期 yyyy/MM/dd
 */
- (NSString *)currentDate;

/**
 *   返回当前日期 yyyy年MM月dd日
 */
- (NSString *)currentDateEn;

/**
 *   返回当前时刻 HH时：mm分
 */
- (NSString *)currentTime;

/**
 *  将年月日 时分 格式字符串转成NSDate
 */
- (NSDate *)dateByTimeString:(NSString *)string;

/**
 *  将年月日 时分秒 格式字符串转成NSDate
 */
- (NSDate *)dateByTimeString2:(NSString *)string;

/**
 *   返回当前时刻 HH时mm分
 */
- (NSString *)currentTimeEn;

/**
 *  当前时间早一年：年-月-日 时:分:秒
 */
- (NSDate *)currentDateAndTimeLastYear;

/**
 *  当前时间：年-月-日 时:分
 */
- (NSDate *)currentDateAndTime;

/**
 *  当前时间：年-月-日 时:分:秒 字符串
 */
- (NSString *)currentDateAndTimeString;
/**
 * 比较2个时间，精确到时 返回：YES，date1<date2   NO，date1>=date2
 */
- (BOOL)DateFullCompare:(NSString *)date1 date2:(NSString *)date2;

/**
 *   返回需要转换时间的   NSString
 */
- (NSString *)dateStringFromDate:(NSDate *)date WithFormat:(NSString *)format;

/**
 避免时间选择早于1900年，避免时间选择太远的问题
 */
- (BOOL)jugeTimeIsTooOldOrTooBigWithDate:(NSDate *)date;

#pragma mark - 数据查找 - - - - - - - - - - - - - - - - - - -
#pragma mark - UUID - - - - - - - - - - - - - - - - - - -
/*
 *  函数功能:      通过 keychain 获取用户UDID
 *  若之前未存过，则生成一个并进行保存
 *
 */
- (NSString *)selectUUID;

/**
 *  生成GUID
 */
- (NSString*)stringWithUUID;

#pragma mark - 获取系统信息 - - - - - - - - - - - - - - - - - - - -
/** 获取当前VC*/
- (UIViewController *)getCurrentVC;

- (UIViewController *)_topViewController:(UIViewController *)vc;
/** 获取APP版本号*/
- (NSString *)getAPPVersion;

/** 获取APP测试版本号*/
- (NSString *)getAPPBetaVersion;

/** 密码：年+月*2+日*3 */
- (NSString *)getUTPassword;




#pragma mark - 文件管理 - - - - - - - - - - - - - - - - - - - -
/** 字符串转图片保存*/
//- (void)saveMatrielPhoto:(NSString *)imageStr fileName:(NSString *)fileName SuccessBlock:(void (^)(void))SuccessBlock FailBlock:(void (^)(void))FailBlock;
/** 创建文件夹*/
- (void)createFolder:(NSString *)path;

/** 判断文件是否存在
 *  name: 文件名
 */
-(BOOL) isFileExist:(NSString *)fileName;

/** 判断培训考试下载文件是否存在
 *  name: 文件名
 */
-(BOOL) isExamMediaFileExist:(NSString *)fileName;

#pragma mark - 查找数据 - - - - - - - - - - - - - - - - - - -
/** 通过文件名获取图片*/
//- (UIImage *)selectTypeImage:(NSString *)imgName;


#pragma mark - UI控件 - - - - - - - - - - - - - - - - - - -
/** UITableView section标题*/
- (UILabel *)tableViewSectionTitle:(NSString *)text;

/** 导航栏按钮创建
 *  参数： title 按钮标题
 *  参数： block 点击回调
 */
- (NSArray *)navigationButton:(NSString *)title1
                  clickBlock1:(void(^)(UIButton *btn1))block1
                       title2:(NSString *)title2
                  clickBlock2:(void(^)(UIButton *btn2))block2;





#pragma mark - 计算数据、数据处理 - - - - - - - - - - - - - - - -
/**
 * 计算字符串宽度
 *
 * fontSize 字体大小
 * height   高度
 */
- (CGFloat)calculateRowWidth:(NSString *)string fontSize:(float)fontSize height:(float)height;



/** 数据处理，转为字典*/
- (NSDictionary *)AnalyDataWithJsonString:(NSString *)jsonString;

/** 数据处理，转为数组*/
- (NSArray *)AnalyDataWithJSONString:(NSString *)jsonString;

/** 数据处理，转为数组+字典*/
- (NSMutableArray *)AnalyDataWithResponseString:(NSString *)responseString;

/**
 * 数组转JSON字符串
 */
- (NSString *)arrayToJSONString:(NSArray *)array;

/** model转化为字典*/
- (NSDictionary *)dicFromObject:(NSObject *)object;

//将可能存在model数组转化为普通数组
- (id)arrayOrDicWithObject:(id)origin;


/** model数组转字典数组*/
- (NSMutableArray *)arrayModel_Dictionary:(NSArray *)array;

#pragma - mark - HEX string 与 NSData 互转
/** HEX string 转data*/
- (NSData*)dataFormHexString:(NSString*)hexString;

/** data 转 hex string*/
- (NSString *)hexStringFromData:(NSData*)data;

/** 转换字典为json字符串*/
-(NSString *)convertToJsonData:(NSDictionary *)dict;



#pragma mark - 时间处理
/**
 * 比较2个时间 返回：YES，date1<=date2   NO，date1>date2
 */
- (BOOL)DateCompare:(NSString *)date1 date2:(NSString *)date2 WithFormat:(NSString *)Format;

/**
 * 比较2个时间 返回：YES，date1<=date2   NO，date1>date2
 */
- (BOOL)DateCompare:(NSString *)date1 date2:(NSString *)date2;

/**
 *   返回   NSString XXXX-XX-XX
 */
- (NSString *)stringTimeByDateY_M_D:(NSDate *)date;





@end
