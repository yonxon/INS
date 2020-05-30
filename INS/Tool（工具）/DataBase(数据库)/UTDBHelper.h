
#import <Foundation/Foundation.h>
#import "FMDB.h"



@interface UTDBHelper : NSObject





@property (nonatomic, retain, readonly) FMDatabaseQueue *dbQueue;

+ (UTDBHelper *)shareInstance;

+ (NSString *)dbPath;


#pragma mark - 扩展方法 - - - - - -
/** 设置数据库存储文件名*/
+ (void)dbSaveNameSetting:(NSString *)saveName;

/** 设置数据库存储文件夹名字*/
+ (void)dbFolderNameSetting:(NSString *)folderName;

/** 获取自定义设置的数据库存储文件名*/
+ (NSString *)selectSetSaveName;

/** 获取自定义设置的文件夹名*/
+ (NSString *)selectSetFolderName;



@end
