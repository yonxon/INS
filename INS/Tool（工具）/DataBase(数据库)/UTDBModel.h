




//  结合  Runtime+FMDB 实现数据持久化
//  调用示例参考头文件底部注释代码
//  使用时，只需建立 model文件并集成UTDBModel，即可调用方法


#import <Foundation/Foundation.h>

/** SQLite五种数据类型 */
#define SQLTEXT     @"TEXT"
#define SQLINTEGER  @"INTEGER"
#define SQLREAL     @"REAL"
#define SQLBLOB     @"BLOB"
#define SQLNULL     @"NULL"
#define PrimaryKey  @"primary key"

#define primaryId   @"pk"


@interface UTDBModel : NSObject



/** 主键 id */
@property (nonatomic, assign)   int        pk;
/** 列名 */
@property (retain, readonly, nonatomic) NSMutableArray         *columeNames;
/** 列类型 */
@property (retain, readonly, nonatomic) NSMutableArray         *columeTypes;





#pragma - mark - 自定义语句
/** 自定义SQL语句执行*/
- (BOOL)customExcuteSQL:(NSString *)SQL;




#pragma - mark - 存
/** 增加或者更新*/
- (BOOL)saveOrUpdate;

/** 保存（新增）*/
- (BOOL)save;

/** 批量保存用户对象 */
+ (BOOL)saveObjects:(NSArray *)array;


#pragma - mark - 查
/** 查询全部数据 */
+ (NSArray *)findAll;

/** 查找某条数据 如：@" WHERE pk > 5 limit 10"*/
+ (instancetype)findFirstByCriteria:(NSString *)criteria;

/** 查找多条数据 如：@" WHERE pk > 5 limit 10"*/
+ (NSArray *)findByCriteria:(NSString *)criteria;

/** 通过pk健查数据*/
+ (instancetype)findByPK:(int)inPk;

/** 查找相应字段值
 *  Column：字段名
 *  value：值
 */
+ (instancetype)findByColumn:(NSString *)Column value:(id)value;


#pragma - mark - 更新
/** 更新单个对象 */
- (BOOL)update;

/** 批量更新用户对象*/
+ (BOOL)updateObjects:(NSArray *)array;


#pragma mark - 删
/** 删除单个对象 */
- (BOOL)deleteObject;

/** 根据指定字段删除单个对象
 *  column:删除相应字段
 *  value：字段对应的值
 */
- (BOOL)deleteObjectWithColumn:(NSString *)column value:(NSString *)value;

/** 批量删除用户对象 */
+ (BOOL)deleteObjects:(NSArray *)array;

/** 根据指定字段批量删除用户对象
 *  column:删除相应字段
 *  value：字段对应的值
 */
+ (BOOL)deleteObjects:(NSArray *)array Column:(NSString *)column value:(id)value;

/** 通过条件删除数据 如：@" WHERE pk > 5 limit 10"*/
+ (BOOL)deleteObjectsByCriteria:(NSString *)criteria;

/** 清空表 */
+ (BOOL)clearTable;


#pragma mark - 转换方法，model转为字典或数组数据
/** model转为字典或数组数据*/
+ (id)Covert:(id)object;










#pragma - mark - 设置存储名字、文件夹名字 根据需要调用,有需要更改文件/夹名时调用
/**
 * 设置存储名字、文件夹名字 根据需要调用,有需要更改文件/夹名时调用
 * 参数： fileName    存储文件名
 * 参数： folderName  存储文件夹名
 */
+ (void)nameSettingWithFileName:(NSString *)fileName FolderName:(NSString *)folderName;


#pragma mark - base method
/**
 * 创建表
 * 如果已经创建，返回YES
 */
+ (BOOL)createTable;


#pragma - mark - util method查字段、属性、所有表
/** 获取表所有字段
 */
+ (NSArray *)getColumns;

/** 获取数据库所有的表*/
+ (NSArray *)GetAllTable;

/** 获取数据库所有的表
 *  参数：isShowMore 是否显示更多信息
 *  是：返回更多信息
 *  否：返回数据库表列表
 */
+ (NSArray *)GetAllTableIsShowMoreInfo:(BOOL)isShowMore;




/** 获取所有属性，包含主键pk */
+ (NSDictionary *)getAllPropertiesWithSaveData:(NSDictionary *)saveData;

/**
 * 解析保存数据的字段名为表名，值的类型为表字段类型
 * 返回字典，字段名、字段类型
 */
+ (NSDictionary *)getAllType:(NSDictionary *)saveData;


/**
 *  获取该类的所有属性
 */
+ (NSDictionary *)getPropertys;

/** 获取所有属性，包含主键pk */
+ (NSDictionary *)getAllProperties;


/** 获取字段和类型描述*/
+ (NSString *)getColumeAndTypeString;
/** 获取字典数据字段和类型描述*/
+ (NSString *)getColumeAndTypeStringWithSaveData:(NSDictionary *)saveData;

/** 表描述*/
- (NSString *)description;


#pragma mark - must be override method
/** 如果子类中有一些property不需要创建数据库字段，那么这个方法必须在子类中重写
 */
+ (NSArray *)transients;


@end






#pragma mark - 调用demo
#pragma mark - 插入数据
/** 创建多条子线程 */
//- (IBAction)insertData:(id)sender {
//    for (int i = 0; i < 1; i++) {
//        User *user = [[User alloc] init];
//        user.name = @"用户一";
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            [user save];
//        });
//    }
//}

/** 子线程一:插入多条用户数据 */
//- (IBAction)insertData2:(id)sender {
//
//    dispatch_queue_t q1 = dispatch_queue_create("queue1", NULL);
//    dispatch_async(q1, ^{
//        for (int i = 0; i < 5; ++i) {
//            User *user = [[User alloc] init];
//            user.name = @"赵五";
//            [user save];
//        }
//    });
//}
//
//- (IBAction)insertData3:(id)sender {
//    for (int i = 0; i < 1000; ++i) {
//        User *user = [[User alloc] init];
//        user.name = @"张三";
//        [user save];
//    }
//}

/** 子线程三：事务插入数据 */
//- (IBAction)insertData4:(id)sender {
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSMutableArray *array = [NSMutableArray array];
//        for (int i = 0; i < 500; i++) {
//            User *user = [[User alloc] init];
//            user.name = [NSString stringWithFormat:@"李四%d",i];
//            [array addObject:user];
//        }
//        [User saveObjects:array];
//    });
//}

#pragma mark - 删除数据
/** 通过条件删除数据 */
//- (IBAction)deleteData:(id)sender {
//    [User deleteObjectsByCriteria:@" WHERE pk < 10"];
//}

/** 创建多个线程删除数据 */
//- (IBAction)deleteData2:(id)sender {
//    for (int i = 0; i < 5; i++) {
//        User *user = [[User alloc] init];
//        user.pk = 1+i;
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            [user deleteObject];
//        });
//    }
//}

/** 子线程用事务删除数据 */
//- (IBAction)deleteData3:(id)sender {
//
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSMutableArray *array = [NSMutableArray array];
//        for (int i = 0; i < 500; i++) {
//            User *user = [[User alloc] init];
//            user.pk = 501+i;
//            [array addObject:user];
//        }
//        [User deleteObjects:array];
//    });
//}

#pragma mark - 修改数据
/** 创建多个线程更新数据 */
//- (IBAction)updateData1:(id)sender {
//    for (int i = 0; i < 5; i++) {
//        User *user = [[User alloc] init];
//        user.name = [NSString stringWithFormat:@"更新%d",i];
//        user.age = 120+i;
//        user.pk = 5+i;
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            [user update];
//        });
//    }
//}

/**单个子线程批量更新数据，利用事务 */
//- (IBAction)updateData:(id)sender {
//    dispatch_queue_t q3 = dispatch_queue_create("queue3", NULL);
//    dispatch_async(q3, ^{
//        NSMutableArray *array = [NSMutableArray array];
//        for (int i = 0; i < 500; i++) {
//            User *user = [[User alloc] init];
//            user.name = [NSString stringWithFormat:@"啊我哦%d",i];
//            user.age = 88+i;
//            user.pk = 10+i;
//            [array addObject:user];
//        }
//        [User updateObjects:array];
//    });
//
//}

#pragma mark - 查询
/** 查询单条记录 */
//- (IBAction)queryData1:(id)sender {
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"第一条:%@",[User findFirstByCriteria:@" WHERE age = 20 "]);
//    });
//}

/**  条件查询多条记录 */
//- (IBAction)queryData2:(id)sender {
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"小于20岁:%@",[User findByCriteria:@" WHERE age < 20 "]);
//    });
//}

/** 查询全部数据 */
//- (IBAction)queryData3:(id)sender {
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"全部:%@",[User findAll]);
//    });
//}



