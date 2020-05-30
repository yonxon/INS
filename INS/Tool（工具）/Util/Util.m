

#import "Util.h"
#import "KeychainItemWrapper.h"
#import <objc/runtime.h>


@implementation Util

/**
 *  单例
 *
 *  @return ZTOperation
 */
+ (Util *)shareInstance
{
    static Util *_shareInstance = nil;
    static dispatch_once_t onePredicate;
    
    dispatch_once(&onePredicate,^{
        _shareInstance = [[Util alloc] init];
        
    });
    return _shareInstance;
}


#pragma mark NSUserDefaults 存取 - - - - - - - - - - - - - - - - - - - - - -
/**
 *  NSUserDefaults 储存
 *
 *  @param key    key
 *  @param object vaule
 */
- (void)defaultObjectSetWithKey:(NSString *)key object:(id)object
{
    NSUserDefaults *pushJudge = [NSUserDefaults standardUserDefaults];
    [pushJudge setObject:object forKey:key];
    [pushJudge synchronize];
}

/**
 *  NSUserDefaults 储存Model类型数据
 *
 *  @param key    key
 *  @param object vaule
 */
- (void)defaultModelSetWithKey:(NSString *)key object:(id)object
{
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:myEncodedObject forKey:key];
    // [defaults synchronize];
}

/**
 *  NSUserDefaults 储存
 *
 *  @param key       key
 *  @param boolValue value
 */
- (void)defaultBoolSetWithKey:(NSString *)key boolValue:(BOOL)boolValue
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:boolValue forKey:key];
    [userDefaults synchronize];
}

/**
 *  NSUserDefaults 取值
 *
 *  @param key key
 *
 *  @return id
 */
- (id)defaultObjectGetWithKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

/**
 *  NSUserDefaults 取值
 *
 *  @param key key
 *
 *  @return Model 数据
 */
- (id)defaultModelGetWithKey:(NSString *)key
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSData *data = [user objectForKey:key];
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}


/**
 *  NSUserDefaults 取值
 *
 *  @param key key
 *
 *  @return BOOL
 */
- (BOOL)defaultBoolGetWithKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

/**
 *  NSUserDefaults 存值-webview加载完成时
 */
- (void)defaultWebViewDidFinishLoad
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  移除对象
 *
 *  @param key key
 */
- (void)defaultRemoveObjectWithKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - 创建UI - - - - - - - - - - - - - - - - - - -
/** 创建导航栏按钮 上图标+下文字*/
- (UIButton *)createNavigationItemButtonWithImage:(UIImage*)image Width:(float)width
{
    UIButton *btn = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, width, 30)];
    btn.backgroundColor = [UIColor clearColor];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.contentMode = UIViewContentModeScaleAspectFit;
    btn.titleLabel.font = [UIFont systemFontOfSize:30];
    return btn;
}


#pragma mark - 时间 - - - - - - - - - - - - - - - - - - -
/**
 *   判断传入时间对比当前系统时间是否过期，精确到“时”
 *   stringDate   待对比的时间
 *   retrurn      YES:未到期  NO:已经到期
 */
- (BOOL)timeIsInTheFuture:(NSString *)stringDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:timeZone];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date1 = [self dateByTimeString2:stringDate];
    
    NSDate *date2 = [NSDate date];
    date2 = [date2 dateByAddingTimeInterval:8*60*60];
    
    NSString *oneDayStr = [dateFormatter stringFromDate:date1];
    NSString *anotherDayStr = [dateFormatter stringFromDate:date2];
    
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    
    NSComparisonResult result = [dateA compare:dateB];
    
    NSLog(@"date1 : %@, date2 : %@", dateA, dateB);
    
    if (result == NSOrderedDescending)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/**
 *   返回当前日期 yyyy/MM/dd
 */
- (NSString *)currentDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    
    return [strDate substringWithRange:NSMakeRange(0, 10)];
}

/**
 *   返回当前日期 yyyy年MM月dd日
 */
- (NSString *)currentDateEn
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH时:mm分:ss秒"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    
    return [strDate substringWithRange:NSMakeRange(0, 11)];
}

/**
 *   返回当前时刻 HH时：mm分
 */
- (NSString *)currentTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    
    return [strDate substringWithRange:NSMakeRange(11, strDate.length - 14)];
    
}

/**
 *   返回当前时刻 HH时mm分
 */
- (NSString *)currentTimeEn
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH时mm分ss秒"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    
    return [strDate substringWithRange:NSMakeRange(11, strDate.length - 14)];
    
}

/**
 *  当前时间早一年：年-月-日 时:分:秒
 */
- (NSDate *)currentDateAndTimeLastYear
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate * date = [NSDate date];
    //设置时间间隔（秒）
//    NSTimeInterval time = 365 * 24 * 60 * 60;//一年的秒数
//    NSTimeInterval time = 30 * 24 * 60 * 60;//30天的秒数
//    得到一年之前的当前时间（-：表示向前的时间间隔（即去年），如果没有，则表示向后的时间间隔（即明年））
//    NSDate * lastYear = [date dateByAddingTimeInterval:-time];
//    NSString *currentTime = [formatter stringFromDate:lastYear];
    
    //获取前一个月的时间
    NSDate *monthagoData = [self getPriousorLaterDateFromDate:date withMonth:-1];
    NSString *currentTime = [formatter stringFromDate:monthagoData];
    return [self dateByTimeString2:currentTime];
}

- (NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];// NSGregorianCalendar
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}

/**
 *  当前时间：年-月-日 时:分:秒
 */
- (NSDate *)currentDateAndTime
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    
    return [self dateByTimeString2:currentTime];
}


/**
 *  当前时间：年-月-日 时:分:秒 字符串
 */
- (NSString *)currentDateAndTimeString
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    
    return currentTime;
}

/**
 *  将年月日 时分 格式字符串转成NSDate
 */
- (NSDate *)dateByTimeString:(NSString *)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH时mm分"];
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
    
}

/**
 *  将年月日 时分秒 格式字符串转成NSDate
 */
- (NSDate *)dateByTimeString2:(NSString *)string
{
    NSArray *arrayOrign = [string componentsSeparatedByString:@" "];
    
    // 只取年月日、时分秒
    NSString *stringOrign = [NSString stringWithFormat:@"%@ %@",arrayOrign[0],arrayOrign[1]];
    
    // 容错
    if(stringOrign.length < 17)
    {
        return nil;
    }
    
    NSString *stringPoint = [stringOrign substringWithRange:NSMakeRange(4, 1)];
    
    if([stringPoint isEqualToString:@"/"])
    {
        stringOrign = [stringOrign stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    }
    
    // 取时间
    NSString *timeStr = [stringOrign substringWithRange:NSMakeRange(stringOrign.length - 8, 8)];
    // 取日期
    NSString *dateStr = [stringOrign substringWithRange:NSMakeRange(0, stringOrign.length - 9)];
    
    NSArray *arrayDate = [dateStr componentsSeparatedByString:@"-"];
    
    NSMutableArray *arrayCompleteDate = [[NSMutableArray alloc] init];
    
    for(int i=0; i<arrayDate.count ;i++)
    {
        NSString *str = arrayDate[i];
        
        // 处理月份、日期仅为一位，在其前面补0
        if(str.length <2)
        {
            str = [NSString stringWithFormat:@"0%@",str];
        }
        
        [arrayCompleteDate addObject:str];
    }
    
    // 拼接成yyyy-MM-dd HH:mm:ss 格式字符串
    NSString *completeDateString = [NSString stringWithFormat:@"%@-%@-%@ %@",arrayCompleteDate[0],
                                    arrayCompleteDate[1],
                                    arrayCompleteDate[2],
                                    timeStr];
    
    
    
    
    // 容错
    if(completeDateString.length < 19)
    {
        return nil;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [dateFormatter dateFromString:completeDateString];
    
    //将转换回来的对象手动加上8小时，回到北京时间
//    NSDate *date2 = [date dateByAddingTimeInterval:8 * 60 * 60];
//
//    return date2;
    return date;
}

/**
 * 比较2个时间，精确到时 返回：YES，date1<date2   NO，date1>=date2
 */
- (BOOL)DateFullCompare:(NSString *)date1 date2:(NSString *)date2
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* Date1 = [inputFormatter dateFromString:date1];
    NSDate* Date2 = [inputFormatter dateFromString:date2];
    
    NSComparisonResult result = [Date1 compare:Date2];
    NSLog(@"date1 : %@, date2 : %@", Date1, Date2);
    if (result == NSOrderedDescending)
    {
        // Date1  is in the future
        return NO;
    }
    else
    {
        // Date1 is in the past/Both dates are the same
        return YES;
    }
}

/**
 *   返回需要转换时间的   NSString
 */
- (NSString *)dateStringFromDate:(NSDate *)date WithFormat:(NSString *)format
{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:format];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formater setTimeZone:timeZone];
    
    return [formater stringFromDate:date];
}
/**
 *   时间如果比1900年还早
 */
- (BOOL)dateIsTooOld:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy"];
    NSInteger year=[[formatter stringFromDate:date] integerValue];
    
    if (year < 1900) {
        return YES;
    }
    
    return NO;
}

/**
 *   时间如果超过70年服务器返回不正确，设置不超过70年
 */
- (BOOL)dateIsTooBig:(NSDate *)date
{
    NSDate *currentDate =[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:currentDate] integerValue];
    
    NSInteger dateYear =[[formatter stringFromDate:date] integerValue];
    
    if (dateYear - currentYear > 60) {
        return YES;
    }
    
    return NO;
}

/**
 避免时间选择早于1900年，避免时间选择太远的问题
 */
- (BOOL)jugeTimeIsTooOldOrTooBigWithDate:(NSDate *)date
{
    // 避免时间选择早于1900年
    if ([[Util shareInstance] dateIsTooOld:date]) {
        return YES;
    }
    // 避免时间选择太远的问题
    if ([[Util shareInstance] dateIsTooBig:date]) {
        return YES;
    }
    return NO;
}

#pragma mark - 数据查找 - - - - - - - - - - - - - - - - - - -
#pragma mark - UUID - - - - - - - - - - - - - - - - - - -
/*
 *  函数功能:      通过 keychain 获取用户UDID
 *  若之前未存过，则生成一个并进行保存
 *
 */
- (NSString *)selectUUID
{
    NSString *resultUDIDString = @"";
    
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *accessGroup = [infoDict objectForKey:@"CFBundleIdentifier"];
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:accessGroup accessGroup:nil];
    
    NSString *UDID = [keychain objectForKey:(__bridge id)kSecValueData];
    
    if(UDID.length == 0)
    {
        CFUUIDRef puuid = CFUUIDCreate( nil );
        CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
        NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
        CFRelease(puuid);
        CFRelease(uuidString);
        
        [keychain setObject:result forKey:(id)CFBridgingRelease(kSecValueData)];
        resultUDIDString = result;
        
    }else
    {
        resultUDIDString = UDID;
    }
    return resultUDIDString;
}

/**
 *  生成GUID
 */
- (NSString*)stringWithUUID {
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString    *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return uuidString ;
}



#pragma mark - 获取系统信息 - - - - - - - - - - - - - - - - - - - -
/** 获取当前VC*/
- (UIViewController *)getCurrentVC
{
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
/** 获取APP版本号*/
- (NSString *)getAPPVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    return app_Version;
}

/** 获取APP测试版本号*/
- (NSString *)getAPPBetaVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    return app_Version;
}

/** 密码：年+月*2+日*3 */
- (NSString *)getUTPassword
{
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay | kCFCalendarUnitHour | kCFCalendarUnitMinute | kCFCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    NSInteger year = [dateComponent year];
    NSInteger month = [dateComponent month];
    NSInteger day = [dateComponent day];
    
    NSString *pwd = [NSString stringWithFormat:@"%ld",year+month*2+day*3];
    
    return pwd;
}




#pragma mark - 文件管理 - - - - - - - - - - - - - - - - - - - -
/** 字符串转图片保存*/
//- (void)saveMatrielPhoto:(NSString *)imageStr fileName:(NSString *)fileName SuccessBlock:(void (^)(void))SuccessBlock FailBlock:(void (^)(void))FailBlock
//{
//    if([imageStr isKindOfClass:[NSNull class]] || imageStr.length < 1)
//    {
//        if(FailBlock)
//        {
//            FailBlock();
//        }
//        return ;
//    }
//
//    NSData *_decodedImageData   = [[NSData alloc] initWithBase64EncodedString:imageStr options:0 ];
//    if(!_decodedImageData)
//    {
//        if(FailBlock)
//        {
//            FailBlock();
//        }
//        return ;
//    }
//
//    UIImage *_decodedImage  = [UIImage imageWithData:_decodedImageData];
//
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//
//    if(![fileManager fileExistsAtPath:downLoadTypeImagePath])
//    {
//        [fileManager createDirectoryAtPath:downLoadTypeImagePath withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//
//    NSString *filePath = [NSString stringWithFormat:@"%@/%@.png",downLoadTypeImagePath,fileName];
//
//
//    if ([UIImagePNGRepresentation(_decodedImage) writeToFile:filePath atomically:YES]) {
//
//        if(SuccessBlock)
//        {
//            SuccessBlock();
//        }
//    }else{
//        if(FailBlock)
//        {
//            FailBlock();
//        }
//    }
//}

/** 创建文件夹*/
- (void)createFolder:(NSString *)path
{
    //建立文件夹
    BOOL isDir =NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if ( !(isDir ==YES && existed == YES) ){
        //如果没有文件夹则创建
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

/** 判断文件是否存在
 *  name: 文件名
 */
-(BOOL) isFileExist:(NSString *)fileName
{
    // 避免文件名为@""的情况
    if(!fileName || fileName.length == 0)
    {
        return NO;
    }
    NSString *filePath = [downLoadPath stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //2.获取文件大小
    NSDictionary * attributes = [fileManager attributesOfItemAtPath:filePath error:NULL];
    //利用分类方法获取文件大小,如果文件大小为0，就返回文件不存在
    if ([attributes fileSize] == 0) {
        return NO;
    }
    BOOL result = [fileManager fileExistsAtPath:filePath];
    return result;
}

/** 判断培训考试下载文件是否存在
 *  name: 文件名
 */
-(BOOL) isExamMediaFileExist:(NSString *)fileName
{
    // 避免文件名为@""的情况
    if(!fileName || fileName.length == 0)
    {
        return NO;
    }
    NSString *filePath = [downLoadExamFilesPath stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //利用分类方法获取文件大小,如果文件大小为0，就返回文件不存在
    NSDictionary * attributes = [fileManager attributesOfItemAtPath:filePath error:NULL];
    //利用分类方法获取文件大小
    if ([attributes fileSize] == 0) {
        return NO;
    }
    BOOL result = [fileManager fileExistsAtPath:filePath];
    return result;
}


#pragma mark - 查找数据 - - - - - - - - - - - - - - - - - - -
/** 通过文件名获取图片*/
//- (UIImage *)selectTypeImage:(NSString *)imgName
//{
//    if(imgName.length < 1)
//    {
//        return nil;
//    }
//
//
//    NSString *imageName = [NSString stringWithFormat:@"%@.png",imgName];
//    NSString *filePath = [downLoadTypeImagePath stringByAppendingPathComponent:imageName];
//
//    NSFileManager* fm = [NSFileManager defaultManager];
//    NSData* data = [[NSData alloc] init];
//    data = [fm contentsAtPath:filePath];
//    NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//
//    UIImage *_decodedImage  = [UIImage imageWithData:data];
//
//    return _decodedImage;
//}


#pragma mark - UI控件 - - - - - - - - - - - - - - - - - - -
/** UITableView section标题*/
- (UILabel *)tableViewSectionTitle:(NSString *)text
{
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Main_Screen_Width - 10, 50)];
    lbl.text = text;
    lbl.font = [UIFont boldSystemFontOfSize:20.0f];
    return lbl;
}

/** 导航栏按钮创建
 *  参数： title 按钮标题
 *  参数： block 点击回调
 */
- (NSArray *)navigationButton:(NSString *)title1 
                  clickBlock1:(void(^)(UIButton *btn1))block1
                       title2:(NSString *)title2
                  clickBlock2:(void(^)(UIButton *btn2))block2

{
    BlockButton *btn1 = [BlockButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:title1 forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 sizeToFit];
    btn1.block = block1;
    UIBarButtonItem *Item1 = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    
    
    UIBarButtonItem *ItemSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    ItemSpace.width = 15;
    
    
    BlockButton *btn2 = [BlockButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:title2 forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 sizeToFit];
    btn2.block = block2;
    
    UIBarButtonItem *Item2 = [[UIBarButtonItem alloc] initWithCustomView:btn2];
    
    
    return @[Item2,ItemSpace, Item1];
}









#pragma mark - 计算数据、数据处理 - - - - - - - - - - - - - - - -
/**
 * 计算字符串宽度
 *
 * fontSize 字体大小
 * height   高度
 */
- (CGFloat)calculateRowWidth:(NSString *)string fontSize:(float)fontSize height:(float)height
{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};  //指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, height)/*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}




/** 数据处理，转为字典*/
- (NSDictionary *)AnalyDataWithJsonString:(NSString *)jsonString
{
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    return dic;
}


/** 数据处理，转为数组*/
- (NSArray *)AnalyDataWithJSONString:(NSString *)jsonString
{
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                   options:NSJSONReadingMutableContainers
                                                     error:&err];
    return arr;
}

/** 数据处理，转为数组+字典*/
- (NSMutableArray *)AnalyDataWithResponseString:(NSString *)responseString
{
    NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
    
    NSString *jsonString = responseString;
    // 1.处理冗余字符
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"{" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"[" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"]" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    // 2.取数组，按照 “},” 分隔;获取每一张票的数据
    NSArray *arrString = [jsonString componentsSeparatedByString:@"},"];
    NSInteger count = arrString.count;
    
    // 3.遍历，逐个将票数据转为字典保存起来
    for(NSInteger i=0;i<count;i++)
    {
        NSMutableDictionary *dicData = [[NSMutableDictionary alloc] init];
        NSString *string = arrString[i];
        
        // 分解键值对字符串
        NSArray *arrKV = [string componentsSeparatedByString:@","];
        NSInteger KVCount = arrKV.count;
        // 分解字符串，设置键值对
        for(NSInteger j=0;j<KVCount;j++)
        {
            NSString *strKV_j = arrKV[j];
            
            if(!strKV_j || strKV_j.length < 1 || ![strKV_j containsString:@":"])
            {
                continue;
            }
            
            NSArray *arrK_V = [strKV_j componentsSeparatedByString:@":"];
            if(!arrK_V || arrK_V.count < 2)
            {
                continue;
            }
            
            // KEY:VALUE，截取KEY，以及KEY之后的数据作为VALUE
            // 不使用数组第一个为key，第二个为value。因为存在时间字符串的影响，2017-08-24 16:10:32
            NSString *KEY = [NSString stringWithFormat:@"%@",arrK_V[0]];
            //            NSString *VALUE = [NSString stringWithFormat:@"%@",arrK_V[1]];
            
            NSString *VALUE = [strKV_j substringWithRange:NSMakeRange(KEY.length + 1, strKV_j.length - KEY.length - 1)];
            [dicData setObject:VALUE forKey:KEY];
        }
        
        [arrReturn addObject:dicData];
    }
    
    
    return arrReturn;
}

/**
 * 数组转JSON字符串
 */
- (NSString *)arrayToJSONString:(NSArray *)array
{
    __block NSString *jsonString = @"";
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDictionary *dic = obj;
        NSString *DataName = dic[@"DataName"]?dic[@"DataName"]:@"";
        NSString *Value = dic[@"Value"]?dic[@"Value"]:@"";
        NSString *dicJsonString = [NSString stringWithFormat:@"{\"DataName\":\"%@\",\"Value\":\"%@\"}",DataName,Value];
        
        jsonString = [NSString stringWithFormat:@"%@,%@",jsonString,dicJsonString];
    }];
    // 去掉第一个 ,
    if(jsonString.length > 0)
    {
        jsonString = [jsonString substringWithRange:NSMakeRange(1, jsonString.length - 1)];
    }
    
    jsonString = [NSString stringWithFormat:@"[%@]",jsonString];
    
    return jsonString;
}


/** model转化为字典*/
- (NSDictionary *)dicFromObject:(NSObject *)object {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([object class], &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithUTF8String:cName];
        NSObject *value = [object valueForKey:name];//valueForKey返回的数字和字符串都是对象
        
        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
            //string , bool, int ,NSinteger
            [dic setObject:value forKey:name];
            
        } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
            //字典或字典
            [dic setObject:[self arrayOrDicWithObject:(NSArray*)value] forKey:name];
            
        } else if (value == nil) {
            //null
            //[dic setObject:[NSNull null] forKey:name];//这行可以注释掉?????
            
        } else {
            //model
            [dic setObject:[self dicFromObject:value] forKey:name];
        }
    }
    
    return [dic copy];
}



//将可能存在model数组转化为普通数组
- (id)arrayOrDicWithObject:(id)origin {
    if ([origin isKindOfClass:[NSArray class]]) {
        //数组
        NSMutableArray *array = [NSMutableArray array];
        for (NSObject *object in origin) {
            if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
                //string , bool, int ,NSinteger
                [array addObject:object];
                
            } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
                //数组或字典
                [array addObject:[self arrayOrDicWithObject:(NSArray *)object]];
                
            } else {
                //model
                [array addObject:[self dicFromObject:object]];
            }
        }
        
        return [array copy];
        
    } else if ([origin isKindOfClass:[NSDictionary class]]) {
        //字典
        NSDictionary *originDic = (NSDictionary *)origin;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (NSString *key in originDic.allKeys) {
            id object = [originDic objectForKey:key];
            
            if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
                //string , bool, int ,NSinteger
                [dic setObject:object forKey:key];
                
            } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
                //数组或字典
                [dic setObject:[self arrayOrDicWithObject:object] forKey:key];
                
            } else {
                //model
                [dic setObject:[self dicFromObject:object] forKey:key];
            }
        }
        
        return [dic copy];
    }
    
    return [NSNull null];
}


/** model数组转字典数组*/
- (NSMutableArray *)arrayModel_Dictionary:(NSArray *)array
{
    NSMutableArray *arrayResult = [[NSMutableArray alloc] init];
    
    if(array.count < 1)
    {
        return arrayResult;
    }
    
    __weak typeof(self)weakSelf = self;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDictionary *dic = [weakSelf dicFromObject:obj];
        [arrayResult addObject:dic];
    }];
    
    return arrayResult.copy;
}



/** 转换字典为json字符串*/
-(NSString *)convertToJsonData:(NSDictionary *)dict{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}



#pragma - mark - HEX string 与 NSData 互转
/** HEX string 转data*/
- (NSData*)dataFormHexString:(NSString*)hexString{
    
    hexString=[hexString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    hexString=[hexString stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!(hexString && [hexString length] > 0 && [hexString length]%2 == 0)) {
        return nil;
    }
    Byte tempbyt[1]={0};
    NSMutableData* bytes=[NSMutableData data];
    for(int i=0;i<[hexString length];i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            return nil;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            return nil;
        
        tempbyt[0] = int_ch1+int_ch2;  ///将转化后的数放入Byte数组里
        [bytes appendBytes:tempbyt length:1];
    }
    return bytes;
}




/** data 转 hex string*/
- (NSString *)hexStringFromData:(NSData*)data{
    
    if(!data)
        return @"";
    
    return [[[[NSString stringWithFormat:@"%@",data]
              stringByReplacingOccurrencesOfString: @"<" withString: @""]
             stringByReplacingOccurrencesOfString: @">" withString: @""]
            stringByReplacingOccurrencesOfString: @" " withString: @""];
}




#pragma mark - 时间处理
/**
 * 比较2个时间 返回：YES，date1<=date2   NO，date1>date2
 */
- (BOOL)DateCompare:(NSString *)date1 date2:(NSString *)date2 WithFormat:(NSString *)Format
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:Format];
    NSDate* Date1 = [inputFormatter dateFromString:date1];
    NSDate* Date2 = [inputFormatter dateFromString:date2];
    
    NSComparisonResult result = [Date1 compare:Date2];
    NSLog(@"date1 : %@, date2 : %@", Date1, Date2);
    if (result == NSOrderedDescending)
    {
        // Date1  is in the future
        return NO;
    }
    else
    {
        // Date1 is in the past/Both dates are the same
        return YES;
    }
}

/**
 * 比较2个时间 返回：YES，date1<=date2   NO，date1>date2
 */
- (BOOL)DateCompare:(NSString *)date1 date2:(NSString *)date2
{
    // 这里写中文年月日返回不正确，改为-
    return [self DateCompare:date1 date2:date2 WithFormat:@"yyyy-MM-dd"];
}


/**
 *   返回   NSString XXXX-XX-XX
 */
- (NSString *)stringTimeByDateY_M_D:(NSDate *)date
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString *str = [formatter stringFromDate:date];
    return  str;
}









@end
