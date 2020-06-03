
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
                             self.isLogin,kIsLogin,
                             self.jwt,kjwt,
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
    if ([fileManager fileExistsAtPath:filePath])
    {
        NSDictionary *userDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        self.UserName   = [userDic objectForKey:kUserName];
        self.isLogin    = [userDic objectForKey:kIsLogin];
        self.jwt    = [userDic objectForKey:kjwt];
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
    self.UserName           = @"";
    self.jwt                = @"";
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


