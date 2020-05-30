/************************************* 文件说明****************************************
 版权所有： 珠海优特电力科技股份有限公司
 版本号：   V1.0
 文件名：   DefineUserModelKey.h
 生成日期：  16/11/11.
 作者：     卢沛翰
 文件说明： 用户模型model key的定义
 修改人：
 修改日期：
 ****************************************************************************************/
#ifndef DefineUserModelKey_h
#define DefineUserModelKey_h


#define kUserName               @"UserName"
#define kStaffID                @"StaffID"
#define kPassword               @"Password"
#define kDepartment             @"Department"
#define kDepartmentID           @"DepartmentID"
#define kServerIP               @"ServerIP"
#define kServerPort             @"ServerPort"
#define kSocketIP               @"SocketIP"
#define kSocketPort             @"SocketPort"
#define kIsLogin                @"IsLogin"
#define kIsBuilder              @"IsBuilder"
#define kLimitTime              @"LimitTime"
#define kUserLevel              @"UserLevel"
#define kLoginModelType         @"LoginModelType"
#define kStatuteType            @"StatuteType"
#define kPermissions            @"Permissions"

// 地理信息
#define kLatitude               @"Latitude"
#define kLongitude              @"Longitude"



// 厂站信息
#define kStationDesc        @"StationDesc"      //厂站描述
#define kStationName        @"StationName"      //厂站名
#define kStationShortName   @"StationShortName" //厂站别称
#define kStationStationNo   @"StationStationNo" //厂站号

// 角色权限
#define kRoleId          @"RoleId" //角色ID
#define kRoleName        @"RoleName" //角色名
#define kPermissions     @"Permissions" //角色具有的功能权限列表



#define kShowPassword @"ShowPassword" // 是否显示密码

// 蓝牙
/** 蓝牙设备名称*/
#define kDefaultBleName         @"DefaultBleName" 
/** 蓝牙设备UUID*/
#define kDefaultBleUUID         @"DefaultBleUUID"
/** 蓝牙外设对象*/
#define kDefaultBlePeripheral   @"DefaultBlePeripheral"

#define kDefaultMD5Data        @"DefaultMD5Data"


#define kUseHttps                     @"UseHttps"
// 应用运行模式
#define kRunModel                     @"RunModel"
// 是否需要授权审批功能
#define kIsNeedAudit                  @"isNeedAudit"




#endif /* DefineUserModelKey_h */
