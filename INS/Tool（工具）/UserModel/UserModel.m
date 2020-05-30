
#import "UserModel.h"
#import "DefineUserModelKey.h"
#define UserModelFileName @"user.dat"

@implementation UserModel

- (id)init
{
    self = [super init];
    if (self) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:[self documentPath:UserModelFileName]])
        {
            [self readData];
        }
        else
        {
            [self initData];
        }
    }
    return self;
}

+ (UserModel *)shareUser
{
    static UserModel *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once (&oncePredicate,^{
        _sharedInstance = [[UserModel alloc] init];
    });
    return _sharedInstance;
}

- (void)saveData
{
    NSDictionary *userDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             self.UserName,kUserName,
                             self.StaffID,kStaffID,
                             self.ServerIP,kServerIP,
                             self.ServerPort,kServerPort,
                             self.SocketIP,kSocketIP,
                             self.SocketPort,kSocketPort,
                             self.Password,kPassword,
                             self.Department,kDepartment,
                             self.DepartmentID,kDepartmentID,
                             self.isLogin,kIsLogin,
                             self.IsBuilder,kIsBuilder,
                             self.LimitTime,kLimitTime,
                             self.StationName,kStationName,
                             self.StationDesc,kStationDesc,
                             self.StationShortName,kStationShortName,
                             self.StationStationNo,kStationStationNo,
                             self.RoleId,kRoleId,
                             self.RoleName,kRoleName,
                             self.Permissions,kPermissions,
                             self.Permissions,kPermissions,
                             [NSString stringWithFormat:@"%ld",(long)self.latitude],kLatitude,
                             [NSString stringWithFormat:@"%ld",(long)self.longitude],kLongitude,
                             self.defaultBleName,kDefaultBleName,
                             self.defaultBleUUID,kDefaultBleUUID,
                             self.ShowPassword,kShowPassword,
                             self.MD5Data,kDefaultMD5Data,
                             self.UseHttps,kUseHttps,
                             self.RunModel ,kRunModel,
                              self.isNeedAudit, kIsNeedAudit,
                             nil];
    
    
    BOOL isWrite = [userDic writeToFile:[self documentPath:UserModelFileName] atomically:YES];
    if (!isWrite) {
        NSLog(@"##############error!");
    }
}


- (void)readData
{
    NSString *filePath = [self documentPath:UserModelFileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSDictionary *userDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
        self.UserName           = [userDic objectForKey:kUserName];
        self.StaffID            = [userDic objectForKey:kStaffID];
        self.ServerIP           = [userDic objectForKey:kServerIP];
        self.ServerPort         = [userDic objectForKey:kServerPort];
        self.SocketIP           = [userDic objectForKey:kSocketIP];
        self.SocketPort         = [userDic objectForKey:kSocketPort];
        self.Password           = [userDic objectForKey:kPassword];
        self.Department         = [userDic objectForKey:kDepartment];
        self.DepartmentID       = [userDic objectForKey:kDepartmentID];
        self.isLogin            = [userDic objectForKey:kIsLogin];
        self.IsBuilder          = [userDic objectForKey:kIsBuilder];
        self.LimitTime          = [userDic objectForKey:kLimitTime];
        self.StationStationNo   = [userDic objectForKey:kStationStationNo];
        self.StationName        = [userDic objectForKey:kStationName];
        self.StationShortName   = [userDic objectForKey:kStationShortName];
        self.StationDesc        = [userDic objectForKey:kStationDesc];
        self.RoleId             = [userDic objectForKey:kRoleId];
        self.RoleName           = [userDic objectForKey:kRoleName];
        self.Permissions        = [userDic objectForKey:kPermissions];
        self.Permissions        = [userDic objectForKey:kPermissions];
        self.latitude           = [[userDic objectForKey:kLatitude]floatValue];
        self.longitude          = [[userDic objectForKey:kLongitude]floatValue];
        self.defaultBleName     = [userDic objectForKey:kDefaultBleName];
        self.defaultBleUUID     = [userDic objectForKey:kDefaultBleUUID];
        self.ShowPassword       = [userDic objectForKey:kShowPassword];
        self.MD5Data            = [userDic objectForKey:kDefaultMD5Data];
        self.UseHttps           = [userDic objectForKey:kUseHttps];
        self.RunModel           = [userDic objectForKey:kRunModel];
        self.isNeedAudit        = [userDic objectForKey:kIsNeedAudit];
        
    }
    
}

- (NSString*) documentPath: (NSString*) fileName
{
    if(fileName == nil)
        return nil;
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex: 0];
    NSString* documentsPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    return documentsPath;
}

/** 清除文件*/
- (void)clear
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex: 0];
    NSString* documentsPath = [documentsDirectory stringByAppendingPathComponent:UserModelFileName];
    BOOL bRet = [fileManager fileExistsAtPath:documentsPath];
    if (bRet) {
        NSError *err;
        [fileManager removeItemAtPath:documentsPath error:&err];
    }
}

- (void)initData
{
    self.isLogin            = @0;
    self.IsBuilder          = @0;
    self.LimitTime          = @0;
    self.ShowPassword       = @"";
    self.RoleId             = @"0";
    self.RoleName           = @"";
    self.Permissions        = @"";
    self.UserName           = @"";
    self.StaffID            = @"";
    self.ServerIP           = @"";
    self.ServerPort         = @"";
    self.SocketIP           = @"";
    self.SocketPort         = @"";
    self.Password           = @"";
    self.Department         = @"";
    self.DepartmentID       = @"";
    self.StationDesc        = @"";
    self.StationName        = @"";
    self.StationShortName   = @"";
    self.StationStationNo   = @"";
    self.latitude           = 0;
    self.longitude          = 0;
    self.defaultBleName     = @"";
    self.defaultBleUUID     = @"";
    self.MD5Data            = [[NSData alloc] init];
    self.UseHttps = @0;
    self.RunModel = @0;
    self.isNeedAudit = @1;
}

/** 版本兼容 - 更新文件字段，确保新增的字段可用*/
- (void)updateDataField
{
    NSString *filePath = [self documentPath:UserModelFileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        return;
    }
    // 已经存有的数据
    NSDictionary *userDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSArray *keyList = [userDic allKeys];
    NSInteger keyCount = keyList.count;
    
    
    // 重新初始化，重新保存
    [[UserModel shareUser] initData];
    [[UserModel shareUser] saveData];
    
    // 初始化之后的字典
    NSMutableDictionary *userDic_init = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    
    // 将原来旧数据保存进来
    for(NSInteger i=0;i<keyCount;i++)
    {
        NSString *KEY = keyList[i];
        [userDic_init setObject:userDic[KEY] forKey:KEY];
    }
    
    
    // 将处理好的数据，重新写入文件
    BOOL isWrite = [userDic_init writeToFile:[self documentPath:UserModelFileName] atomically:YES];
    if (!isWrite) {
        NSLog(@"##############error!");
    }
    
    // 重新读一次到内存
    [[UserModel shareUser] readData];
}



@end


