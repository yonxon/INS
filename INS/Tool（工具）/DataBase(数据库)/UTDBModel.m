


//  结合  Runtime+FMDB 实现数据持久化
//  调用示例参考头文件底部注释代码
//  使用时，只需建立 model文件并集成UTDBModel，即可调用方法




#import "UTDBModel.h"
#import "UTDBHelper.h"
#import <objc/runtime.h>

/** 调试时候可用 - 设置是否输出log日志， 1：是  0： 否*/
#define IOS_Log                                                        0

#if    IOS_Log

#define UTDBLog(...) NSLog(__VA_ARGS__)

#else

#define UTDBLog(...)

#endif


@implementation UTDBModel

// 打开日志
bool OpenLog = YES;


#pragma - mark - 自定义语句
/** 自定义SQL语句执行*/
- (BOOL)customExcuteSQL:(NSString *)SQL
{
    UTDBHelper *jkDB = [UTDBHelper shareInstance];
    __block BOOL res = NO;
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        res = [db executeUpdate:SQL];
        UTDBLog(res?@"自定义SQL语句执行操作成功":@"自定义SQL语句执行操作失败");
    }];
    return res;
}


#pragma - mark - 存
/** 增加或者更新*/
- (BOOL)saveOrUpdate
{
    id primaryValue = [self valueForKey:primaryId];
    if ([primaryValue intValue] <= 0) {
        return [self save];
    }
    
    return [self update];
}
/** 保存（新增）*/
- (BOOL)save
{
    NSString *tableName = NSStringFromClass(self.class);
    NSMutableString *keyString = [NSMutableString string];
    NSMutableString *valueString = [NSMutableString string];
    NSMutableArray *insertValues = [NSMutableArray  array];
    for (int i = 0; i < self.columeNames.count; i++) {
        NSString *proname = [self.columeNames objectAtIndex:i];
        if ([proname isEqualToString:primaryId]) {
            continue;
        }
        [keyString appendFormat:@"%@,", proname];
        [valueString appendString:@"?,"];
        id value = [self valueForKey:proname];
        if (!value) {
            value = @"";
        }
        [insertValues addObject:value];
    }
    
    [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
    [valueString deleteCharactersInRange:NSMakeRange(valueString.length - 1, 1)];
    
    UTDBHelper *lpDB = [UTDBHelper shareInstance];
    __block BOOL res = NO;
    [lpDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES (%@);", tableName, keyString, valueString];
        res = [db executeUpdate:sql withArgumentsInArray:insertValues];
        self.pk = res?[NSNumber numberWithLongLong:db.lastInsertRowId].intValue:0;
                UTDBLog(res?@"插入成功":@"插入失败");
    }];
    return res;
}


/** 批量保存用户对象 */
+ (BOOL)saveObjects:(NSArray *)array
{
    //判断是否是JKBaseModel的子类
    for (UTDBModel *model in array) {
        if (![model isKindOfClass:[UTDBModel class]]) {
            return NO;
        }
    }
    
    __block BOOL res = YES;
    UTDBHelper *jkDB = [UTDBHelper shareInstance];
    
    // 如果要支持事务
    [jkDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (UTDBModel *model in array) {
            NSString *tableName = NSStringFromClass(model.class);
            NSMutableString *keyString = [NSMutableString string];
            NSMutableString *valueString = [NSMutableString string];
            NSMutableArray *insertValues = [NSMutableArray  array];
            for (int i = 0; i < model.columeNames.count; i++) {
                NSString *proname = [model.columeNames objectAtIndex:i];
                if ([proname isEqualToString:primaryId]) {
                    continue;
                }
                [keyString appendFormat:@"%@,", proname];
                [valueString appendString:@"?,"];
                id value = [model valueForKey:proname];
                if (!value) {
                    value = @"";
                }
                [insertValues addObject:value];
            }
            [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
            [valueString deleteCharactersInRange:NSMakeRange(valueString.length - 1, 1)];
            
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES (%@);", tableName, keyString, valueString];
            BOOL flag = [db executeUpdate:sql withArgumentsInArray:insertValues];
            model.pk = flag?[NSNumber numberWithLongLong:db.lastInsertRowId].intValue:0;
                        UTDBLog(flag?@"插入成功":@"插入失败");
            if (!flag) {
                res = NO;
                *rollback = YES;
                return;
            }
        }
    }];
    return res;
}



#pragma - mark - 查
/** 查询全部数据 */
+ (NSArray *)findAll
{
    UTDBLog(@"db---%s",__func__);
    UTDBHelper *jkDB = [UTDBHelper shareInstance];
    NSMutableArray *users = [NSMutableArray array];
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            UTDBModel *model = [[self.class alloc] init];
            for (int i=0; i< model.columeNames.count; i++) {
                NSString *columeName = [model.columeNames objectAtIndex:i];
                NSString *columeType = [model.columeTypes objectAtIndex:i];
                if ([columeType isEqualToString:SQLTEXT]) {
                    [model setValue:[resultSet stringForColumn:columeName] forKey:columeName];
                } else {
                    [model setValue:[NSNumber numberWithLongLong:[resultSet longLongIntForColumn:columeName]] forKey:columeName];
                }
            }
            [users addObject:model];
            FMDBRelease(model);
        }
    }];
    
    return users;
}

/** 查找某条数据 如：@" WHERE pk > 5 limit 10"*/
+ (instancetype)findFirstByCriteria:(NSString *)criteria
{
    NSArray *results = [self.class findByCriteria:criteria];
    if (results.count < 1) {
        return nil;
    }
    
    return [results firstObject];
}

/** 查找多条数据 如：@" WHERE pk > 5 limit 10"*/
+ (NSArray *)findByCriteria:(NSString *)criteria
{
    UTDBHelper *jkDB = [UTDBHelper shareInstance];
    NSMutableArray *users = [NSMutableArray array];
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ %@",tableName,criteria];
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            UTDBModel *model = [[self.class alloc] init];
            for (int i=0; i< model.columeNames.count; i++) {
                NSString *columeName = [model.columeNames objectAtIndex:i];
                NSString *columeType = [model.columeTypes objectAtIndex:i];
                if ([columeType isEqualToString:SQLTEXT]) {
                    [model setValue:[resultSet stringForColumn:columeName] forKey:columeName];
                } else {
                    [model setValue:[NSNumber numberWithLongLong:[resultSet longLongIntForColumn:columeName]] forKey:columeName];
                }
            }
            [users addObject:model];
            FMDBRelease(model);
        }
    }];
    
    return users;
}

/** 通过pk健查数据*/
+ (instancetype)findByPK:(int)inPk
{
    NSString *condition = [NSString stringWithFormat:@"WHERE %@=%d",primaryId,inPk];
    return [self findFirstByCriteria:condition];
}

/** 查找相应字段值
 *  Column：字段名
 *  value：值
 */
+ (instancetype)findByColumn:(NSString *)Column value:(id)value
{
    NSString *condition = [NSString stringWithFormat:@"WHERE %@=%@",Column,value];
    return [self findFirstByCriteria:condition];
}







#pragma - mark - 更新
/** 更新单个对象 */
- (BOOL)update
{
    UTDBHelper *jkDB = [UTDBHelper shareInstance];
    __block BOOL res = NO;
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        id primaryValue = [self valueForKey:primaryId];
        if (!primaryValue || primaryValue <= 0) {
            return ;
        }
        NSMutableString *keyString = [NSMutableString string];
        NSMutableArray *updateValues = [NSMutableArray  array];
        for (int i = 0; i < self.columeNames.count; i++) {
            NSString *proname = [self.columeNames objectAtIndex:i];
            if ([proname isEqualToString:primaryId]) {
                continue;
            }
            [keyString appendFormat:@" %@=?,", proname];
            id value = [self valueForKey:proname];
            if (!value) {
                value = @"";
            }
            [updateValues addObject:value];
        }
        
        //删除最后那个逗号
        [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@ = ?;", tableName, keyString, primaryId];
        [updateValues addObject:primaryValue];
        res = [db executeUpdate:sql withArgumentsInArray:updateValues];
        UTDBLog(res?@"更新成功":@"更新失败");
    }];
    return res;
}


/** 批量更新用户对象*/
+ (BOOL)updateObjects:(NSArray *)array
{
    for (UTDBModel *model in array) {
        if (![model isKindOfClass:[UTDBModel class]]) {
            return NO;
        }
    }
    __block BOOL res = YES;
    UTDBHelper *jkDB = [UTDBHelper shareInstance];
    // 如果要支持事务
    [jkDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (UTDBModel *model in array) {
            NSString *tableName = NSStringFromClass(model.class);
            id primaryValue = [model valueForKey:primaryId];
            if (!primaryValue || primaryValue <= 0) {
                res = NO;
                *rollback = YES;
                return;
            }
            
            NSMutableString *keyString = [NSMutableString string];
            NSMutableArray *updateValues = [NSMutableArray  array];
            for (int i = 0; i < model.columeNames.count; i++) {
                NSString *proname = [model.columeNames objectAtIndex:i];
                if ([proname isEqualToString:primaryId]) {
                    continue;
                }
                [keyString appendFormat:@" %@=?,", proname];
                id value = [model valueForKey:proname];
                if (!value) {
                    value = @"";
                }
                [updateValues addObject:value];
            }
            
            //删除最后那个逗号
            [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
            NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@=?;", tableName, keyString, primaryId];
            [updateValues addObject:primaryValue];
            BOOL flag = [db executeUpdate:sql withArgumentsInArray:updateValues];
            NSLog(flag?@"更新成功":@"更新失败");
            if (!flag) {
                res = NO;
                *rollback = YES;
                return;
            }
        }
    }];
    
    return res;
}





#pragma mark - 删
/** 删除单个对象 */
- (BOOL)deleteObject
{
    return [self deleteObjectWithColumn:primaryId value:@""];
}

/** 根据指定字段删除单个对象
 *  column:删除相应字段
 *  value：字段对应的值
 */
- (BOOL)deleteObjectWithColumn:(NSString *)column value:(NSString *)value
{
    UTDBHelper *lpDB = [UTDBHelper shareInstance];
    __block BOOL res = NO;
    [lpDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        NSString *sql;
        __block BOOL res = NO;
        if([column isEqualToString:primaryId])
        {
            id primaryValue = [self valueForKey:primaryId];
            if (!primaryValue || primaryValue <= 0) {
                return ;
            }
            sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",tableName,primaryId];
            res = [db executeUpdate:sql withArgumentsInArray:@[primaryValue]];
        }else
        {
            sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",tableName,column];
            res = [db executeUpdate:sql withArgumentsInArray:@[value]];
        }
        
        UTDBLog(res?@"删除成功":@"删除失败");
    }];
    return res;
}

/** 批量删除用户对象 */
+ (BOOL)deleteObjects:(NSArray *)array
{
    return [self deleteObjects:array Column:primaryId value:@""];
}

/** 根据指定字段批量删除用户对象
 *  column:删除相应字段
 *  value：字段对应的值
 */
+ (BOOL)deleteObjects:(NSArray *)array Column:(NSString *)column value:(id)value
{
    for (UTDBModel *model in array) {
        if (![model isKindOfClass:[UTDBModel class]]) {
            return NO;
        }
    }
    
    __block BOOL res = YES;
    UTDBHelper *jkDB = [UTDBHelper shareInstance];
    // 如果要支持事务
    [jkDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (UTDBModel *model in array) {
            NSString *tableName = NSStringFromClass(model.class);
            NSString *sql;
            BOOL flag;
            if([column isEqualToString:primaryId])
            {
                id primaryValue = [model valueForKey:primaryId];
                if (!primaryValue || primaryValue <= 0) {
                    return ;
                }
                sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",tableName,primaryId];
                flag = [db executeUpdate:sql withArgumentsInArray:@[primaryValue]];
            }else
            {
                sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",tableName,column];
                flag = [db executeUpdate:sql withArgumentsInArray:@[value]];
            }
            
            UTDBLog(flag?@"删除成功":@"删除失败");
            if (!flag) {
                res = NO;
                *rollback = YES;
                return;
            }
        }
    }];
    return res;
}

/** 通过条件删除数据 如：@" WHERE pk > 5 limit 10"*/
+ (BOOL)deleteObjectsByCriteria:(NSString *)criteria
{
    UTDBHelper *jkDB = [UTDBHelper shareInstance];
    __block BOOL res = NO;
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ %@ ",tableName,criteria];
        res = [db executeUpdate:sql];
        UTDBLog(res?@"删除成功":@"删除失败");
    }];
    return res;
}

/** 清空表 */
+ (BOOL)clearTable
{
    UTDBHelper *jkDB = [UTDBHelper shareInstance];
    __block BOOL res = NO;
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",tableName];
        res = [db executeUpdate:sql];
        UTDBLog(res?@"清空成功":@"清空失败");
    }];
    return res;
}




#pragma - mark - 设置存储名字、文件夹名字 根据需要调用,有需要更改文件/夹名时调用
/**
 * 设置存储名字、文件夹名字 根据需要调用,有需要更改文件/夹名时调用
 * 参数： fileName    存储文件名
 * 参数： folderName  存储文件夹名
 */
+ (void)nameSettingWithFileName:(NSString *)fileName FolderName:(NSString *)folderName
{
    [UTDBHelper dbSaveNameSetting:fileName];
    [UTDBHelper dbFolderNameSetting:folderName];
}




#pragma mark - override method
+ (void)initialize
{
    if (self != [UTDBModel self]) {
        [self createTable];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSDictionary *dic = [self.class getAllProperties];
        _columeNames = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"name"]];
        _columeTypes = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"type"]];
    }
    
    return self;
}

#pragma mark - base method
/**
 * 创建表
 * 如果已经创建，返回YES
 */
+ (BOOL)createTable
{
    FMDatabase *db = [FMDatabase databaseWithPath:[UTDBHelper dbPath]];
    if (![db open]) {
        UTDBLog(@"数据库打开失败!");
        return NO;
    }
    
    NSString *tableName = NSStringFromClass(self.class);
    NSString *columeAndType = [self.class getColumeAndTypeString];
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@);",tableName,columeAndType];
    if (![db executeUpdate:sql]) {
        return NO;
    }
    
    NSMutableArray *columns = [NSMutableArray array];
    FMResultSet *resultSet = [db getTableSchema:tableName];
    while ([resultSet next]) {
        NSString *column = [resultSet stringForColumn:@"name"];
        [columns addObject:column];
    }
    NSDictionary *dict = [self.class getAllProperties];
    NSArray *properties = [dict objectForKey:@"name"];
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",columns];
    //过滤数组
    NSArray *resultArray = [properties filteredArrayUsingPredicate:filterPredicate];
    
    for (NSString *column in resultArray) {
        NSUInteger index = [properties indexOfObject:column];
        NSString *proType = [[dict objectForKey:@"type"] objectAtIndex:index];
        NSString *fieldSql = [NSString stringWithFormat:@"%@ %@",column,proType];
        NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ ",NSStringFromClass(self.class),fieldSql];
        if (![db executeUpdate:sql]) {
            return NO;
        }
    }
    [db close];
    return YES;
}



#pragma - mark - 查字段、属性、所有表
/** 获取表所有字段
 */
+ (NSArray *)getColumns
{
    UTDBHelper *lpDB = [UTDBHelper shareInstance];
    NSMutableArray *columns = [NSMutableArray array];
    [lpDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        FMResultSet *resultSet = [db getTableSchema:tableName];
        while ([resultSet next]) {
            NSString *column = [resultSet stringForColumn:@"name"];
            [columns addObject:column];
        }
    }];
    return [columns copy];
}

/** 获取数据库所有的表*/
+ (NSArray *)GetAllTable
{
    return [self GetAllTableIsShowMoreInfo:NO];
}

/** 获取数据库所有的表
 *  参数：isShowMore 是否显示更多信息
 *  是：返回更多信息
 *  否：返回数据库表列表
 */
+ (NSArray *)GetAllTableIsShowMoreInfo:(BOOL)isShowMore
{
    UTDBHelper *jkDB = [UTDBHelper shareInstance];
    NSMutableArray *tables = [NSMutableArray array];
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"SELECT * FROM sqlite_master where type='table'";
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            
            NSString *str1 = [resultSet stringForColumnIndex:1];
            
            if(isShowMore)
            {
                [tables addObject:resultSet.resultDictionary];
            }else
            {
                [tables addObject:str1];
            }
            FMDBRelease(dicResult);
        }
    }];
    
    return tables;
}


/** 获取所有属性，包含主键pk */
+ (NSDictionary *)getAllPropertiesWithSaveData:(NSDictionary *)saveData
{
    NSDictionary *dict = [self.class getAllType:saveData];
    
    NSMutableArray *proNames = [NSMutableArray array];
    NSMutableArray *proTypes = [NSMutableArray array];
    [proNames addObject:primaryId];
    [proTypes addObject:[NSString stringWithFormat:@"%@ %@ AUTOINCREMENT",SQLINTEGER,PrimaryKey]];
    [proNames addObjectsFromArray:[dict objectForKey:@"name"]];
    [proTypes addObjectsFromArray:[dict objectForKey:@"type"]];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:proNames,@"name",proTypes,@"type",nil];
}

/**
 * 解析保存数据的字段名为表名，值的类型为表字段类型
 * 返回字典，字段名、字段类型
 */
+ (NSDictionary *)getAllType:(NSDictionary *)saveData
{
    // 字段名
    NSArray *proNames = [saveData allKeys];
    
    // 字段类型
    NSInteger dataCount = proNames.count;
    // 字段数组
    NSMutableArray *proTypes = [NSMutableArray array];
    
    // 获取字段类型
    for(NSInteger i=0; i< dataCount; i++)
    {
        id tempObj = [saveData objectForKey:proNames[i]];
        
        if([tempObj isKindOfClass:[NSString class]])
        {
            [proTypes addObject:SQLTEXT];
            
        }else if([tempObj isKindOfClass:[NSNumber class]])
        {
            [proTypes addObject:SQLINTEGER];
        }else if([tempObj isKindOfClass:[NSNull class]])
        {
            [proTypes addObject:SQLNULL];
        }else
        {
            [proTypes addObject:SQLREAL];
        }
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:proNames,@"name",proTypes,@"type",nil];
}



/**
 *  获取该类的所有属性
 */
+ (NSDictionary *)getPropertys
{
    NSMutableArray *proNames = [NSMutableArray array];
    NSMutableArray *proTypes = [NSMutableArray array];
    NSArray *theTransients = [[self class] transients];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        //获取属性名
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        if ([theTransients containsObject:propertyName]) {
            continue;
        }
        [proNames addObject:propertyName];
        //获取属性类型等参数
        NSString *propertyType = [NSString stringWithCString: property_getAttributes(property) encoding:NSUTF8StringEncoding];
        /*
         c char         C unsigned char
         i int          I unsigned int
         l long         L unsigned long
         s short        S unsigned short
         d double       D unsigned double
         f float        F unsigned float
         q long long    Q unsigned long long
         B BOOL
         @ 对象类型 //指针 对象类型 如NSString 是@“NSString”
         
         
         64位下long 和long long 都是Tq
         SQLite 默认支持五种数据类型TEXT、INTEGER、REAL、BLOB、NULL
         */
        if ([propertyType hasPrefix:@"T@"]) {
            [proTypes addObject:SQLTEXT];
        } else if ([propertyType hasPrefix:@"Ti"]||[propertyType hasPrefix:@"TI"]||[propertyType hasPrefix:@"Ts"]||[propertyType hasPrefix:@"TS"]||[propertyType hasPrefix:@"TB"]) {
            [proTypes addObject:SQLINTEGER];
        } else {
            [proTypes addObject:SQLREAL];
        }
        
    }
    free(properties);
    
    return [NSDictionary dictionaryWithObjectsAndKeys:proNames,@"name",proTypes,@"type",nil];
}

/** 获取所有属性，包含主键pk */
+ (NSDictionary *)getAllProperties
{
    NSDictionary *dict = [self.class getPropertys];
    
    NSMutableArray *proNames = [NSMutableArray array];
    NSMutableArray *proTypes = [NSMutableArray array];
    [proNames addObject:primaryId];
    [proTypes addObject:[NSString stringWithFormat:@"%@ %@",SQLINTEGER,PrimaryKey]];
    [proNames addObjectsFromArray:[dict objectForKey:@"name"]];
    [proTypes addObjectsFromArray:[dict objectForKey:@"type"]];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:proNames,@"name",proTypes,@"type",nil];
}





#pragma mark - util method
+ (NSString *)getColumeAndTypeString
{
    NSMutableString* pars = [NSMutableString string];
    NSDictionary *dict = [self.class getAllProperties];
    
    NSMutableArray *proNames = [dict objectForKey:@"name"];
    NSMutableArray *proTypes = [dict objectForKey:@"type"];
    
    for (int i=0; i< proNames.count; i++) {
        [pars appendFormat:@"%@ %@",[proNames objectAtIndex:i],[proTypes objectAtIndex:i]];
        if(i+1 != proNames.count)
        {
            [pars appendString:@","];
        }
    }
    return pars;
}

+ (NSString *)getColumeAndTypeStringWithSaveData:(NSDictionary *)saveData
{
    NSMutableString* pars = [NSMutableString string];
    NSDictionary *dict = [self.class getAllPropertiesWithSaveData:saveData];
    
    NSMutableArray *proNames = [dict objectForKey:@"name"];
    NSMutableArray *proTypes = [dict objectForKey:@"type"];
    
    for (int i=0; i< proNames.count; i++) {
        [pars appendFormat:@"%@ %@",[proNames objectAtIndex:i],[proTypes objectAtIndex:i]];
        if(i+1 != proNames.count)
        {
            [pars appendString:@","];
        }
    }
    return pars;
}


- (NSString *)description
{
    NSString *result = @"";
    NSDictionary *dict = [self.class getAllProperties];
    NSMutableArray *proNames = [dict objectForKey:@"name"];
    for (int i = 0; i < proNames.count; i++) {
        NSString *proName = [proNames objectAtIndex:i];
        id  proValue = [self valueForKey:proName];
        result = [result stringByAppendingFormat:@"%@:%@\n",proName,proValue];
    }
    return result;
}

#pragma mark - must be override method
/** 如果子类中有一些property不需要创建数据库字段，那么这个方法必须在子类中重写
 */
+ (NSArray *)transients
{
    return [NSArray array];
}






#pragma mark - 转换方法，model转为字典或数组数据
/** model转为字典或数组数据*/
+ (id)Covert:(id)object
{
    if([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]])
    {
        __block NSMutableArray *arrayDic = [[NSMutableArray alloc] init];
        NSArray *array = object;
        __weak typeof(self) weakSelf = self;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [arrayDic addObject:[weakSelf dicFromObject:obj]];
            
        }];
        
        return arrayDic;
    }
    
    return [self dicFromObject:object];
}


//model转化为字典
+ (NSDictionary *)dicFromObject:(NSObject *)object
{    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([object class], &count);
    
    for (int i = 0; i < count; i++)
    {
        objc_property_t property = propertyList[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithUTF8String:cName];
        NSObject *value = [object valueForKey:name];
        //valueForKey返回的数字和字符串都是对象
        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
        {
            //string , bool, int ,NSinteger
            [dic setObject:value forKey:name];
            
        } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]])
        {            //字典或字典
            [dic setObject:[self arrayOrDicWithObject:(NSArray*)value] forKey:name];
            
        } else if (value == nil)
        {
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
+ (id)arrayOrDicWithObject:(id)origin
{
    if ([origin isKindOfClass:[NSArray class]])
    {
        //数组
        NSMutableArray *array = [NSMutableArray array];
        for (NSObject *object in origin)
        {
            if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]])
            {
                //string , bool, int ,NSinteger
                [array addObject:object];
                
            } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]])
            {
                //数组或字典
                [array addObject:[self arrayOrDicWithObject:(NSArray *)object]];
                
            } else {
                //model
                [array addObject:[self dicFromObject:object]];
                
            }
            
        }
        return [array copy];
    } else if ([origin isKindOfClass:[NSDictionary class]])
    {
        //字典
        NSDictionary *originDic = (NSDictionary *)origin;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (NSString *key in originDic.allKeys)
        {
            id object = [originDic objectForKey:key];
            if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]])
            {
                //string , bool, int ,NSinteger
                [dic setObject:object forKey:key];
                
            } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]])
            {
                //数组或字典
                [dic setObject:[self arrayOrDicWithObject:object] forKey:key];
                
            } else {
                //model
                [dic setObject:[self dicFromObject:object] forKey:key];
                
            }
            
        }
        return [dic copy];
        
    }     return [NSNull null];
    
}


@end
