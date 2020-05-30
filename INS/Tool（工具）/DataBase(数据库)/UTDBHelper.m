

#import "UTDBHelper.h"
#define DBSaveName @"INS.sqlite"
#define DBFolderName @"INSDB"

@interface UTDBHelper()

@property (nonatomic, retain) FMDatabaseQueue *dbQueue;

/** 数据库保存文件名*/
@property (nonatomic, strong) NSString *dbSaveName;
/** 数据库保存文件夹名*/
@property (nonatomic, strong) NSString *dbFolderName;


@end

@implementation UTDBHelper

static UTDBHelper *_instance = nil;

#pragma mark - 扩展方法 - - - - - -
/** 设置数据库存储文件名*/
+ (void)dbSaveNameSetting:(NSString *)saveName
{
    [[self shareInstance] dbSaveNameSetting:saveName];
}
/** 设置数据库存储文件夹名字*/
+ (void)dbFolderNameSetting:(NSString *)folderName
{
    [[self shareInstance] dbFolderNameSetting:folderName];
}
/** 获取自定义设置的数据库存储文件名*/
+ (NSString *)selectSetSaveName
{
    return [self shareInstance].dbSaveName;
}
/** 获取自定义设置的文件夹名*/
+ (NSString *)selectSetFolderName
{
    return [self shareInstance].dbFolderName;
}


+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
    
    return _instance;
}


+ (NSString *)dbPath
{
    NSString *docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *filemanage = [NSFileManager defaultManager];
    
    // 获取自定义的文件夹名，空则使用默认名DBFolderName
    NSString *folderName = [self selectSetFolderName];
    if(folderName)
    {
        docsdir = [docsdir stringByAppendingPathComponent:folderName];
    }
    else
    {
        docsdir = [docsdir stringByAppendingPathComponent:DBFolderName];
    }
    
    BOOL isDir;
    BOOL exit =[filemanage fileExistsAtPath:docsdir isDirectory:&isDir];
    if (!exit || !isDir) {
        [filemanage createDirectoryAtPath:docsdir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *dbpath = @"";
    
    
    // 获取自定义的文件名，空则使用默认名DBSaveName
    NSString *saveName = [self selectSetSaveName];
    if(saveName)
    {
        dbpath = [docsdir stringByAppendingPathComponent:saveName];
    }else
    {
        dbpath = [docsdir stringByAppendingPathComponent:DBSaveName];
    }
    
    return dbpath;
}

- (FMDatabaseQueue *)dbQueue
{
    if (_dbQueue == nil) {
        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:[self.class dbPath]];
    }
    return _dbQueue;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [UTDBHelper shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [UTDBHelper shareInstance];
}



#pragma mark - 扩展方法 - - - - - -
- (void)dbSaveNameSetting:(NSString *)saveName
{
    self.dbSaveName = saveName;
}

- (void)dbFolderNameSetting:(NSString *)folderName
{
    self.dbFolderName = folderName;
}



#if ! __has_feature(objc_arc)
- (oneway void)release
{
    
}

- (id)autorelease
{
    return _instance;
}

- (NSUInteger)retainCount
{
    return 1;
}
#endif




@end
