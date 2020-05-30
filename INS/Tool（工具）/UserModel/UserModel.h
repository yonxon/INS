
#import <Foundation/Foundation.h>





@interface UserModel : NSObject


// 网络使用Https
@property (nonatomic, strong) NSNumber *UseHttps;


@property (nonatomic, strong) NSNumber *isLogin;//是否已登录  0:未登录  1:登录
@property (nonatomic, strong) NSNumber *IsBuilder;//是否外来人员  NO:否  YES:是
@property (nonatomic, strong) NSNumber *LimitTime;//授权天数(单位:天: -1表示永久授权)



@property (nonatomic, strong) NSString *UserName;//姓名
@property (nonatomic, strong) NSString *StaffID;//登录员工ID
@property (nonatomic, strong) NSString *Password;//登录密码
@property (nonatomic, strong) NSString *Department;//部门
@property (nonatomic, strong) NSString *DepartmentID;//部门ID
@property (nonatomic, strong) NSString *ServerIP;//服务器IP
@property (nonatomic, strong) NSString *ServerPort;//服务器端口
@property (nonatomic, strong) NSString *SocketIP;  //Socket IP
@property (nonatomic, strong) NSString *SocketPort; //Socket 端口
@property (nonatomic, strong) NSString *ShowPassword;//是否显示密码，0：否 1：是

@property (nonatomic, strong) NSString  *RoleId;//角色ID
@property (nonatomic, strong) NSString  *RoleName;//角色名
@property (nonatomic, strong) NSString  *Permissions;//角色具有的功能权限列表



// 应用模式
//1.一体化模式，同时支持锁控与防误操作模式
//2.防误操作模式
//3.锁控模式EST
//4.锁控模式JSQ
//5.1D与EST混合模式，钥匙需要注册（默认）
@property (nonatomic, strong) NSNumber *RunModel;

// 是否需要临时授权审批功能
@property (nonatomic, strong) NSNumber *isNeedAudit; // 0:不需要  1:需要（默认）


// 地理信息
@property (nonatomic, assign) float latitude;  //纬度
@property (nonatomic, assign) float longitude; //经度


// 厂站信息
@property (nonatomic, strong) NSString *StationDesc;        //站描述
@property (nonatomic, strong) NSString *StationName;        //站名称
@property (nonatomic, strong) NSString *StationShortName;   //站短名称
@property (nonatomic, strong) NSString *StationStationNo;   //站号

// 蓝牙
/** 蓝牙设备名称*/
@property (nonatomic,copy) NSString *defaultBleName;
/** 蓝牙设备UUID*/
@property (nonatomic,copy) NSString *defaultBleUUID;



//保存MD5码
@property (nonatomic,strong) NSData *MD5Data;


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
