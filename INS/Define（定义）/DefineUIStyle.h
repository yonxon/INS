/************************************* 文件说明****************************************
 版权所有： 珠海优特电力科技股份有限公司
 版本号：   V1.0
 文件名：   DefineUIStyle.h
 生成日期：  17/1/20.
 作者：     卢沛翰
 文件说明： 项目运用到的UI样式定义
 修改人：
 修改日期：
 ****************************************************************************************/
#ifndef DefineUIStyle_h
#define DefineUIStyle_h

// 导航栏以及状态栏高度
// 导航栏以及状态栏高度
#define TopBarHeight (IPHONEX ? 88.5 : 64.5)
// 底部间距：iPhoneX底部空隙34.0
#define BottomSpace (IPHONEX ? 34.0 : 8)
// Tabbar高度
#define TabBarHeight 49.0f


// 首页Cell间距
#define HomeCellSpace 10.0f
// 常见距离屏幕左边距离
#define NormalLeftLeading 10.0f
// iPad主视图控制器的宽度
#define IpadMasterViewWidth (isPad ? 110.0f : 0)
// iPad自定义导航条，高44+16
#define NavigationBarHeightIncrease 16.0f
// iPad左边头像距离顶部的距离
#define IPADLeftIconTopY 50.0f
// iPad左边按钮列表距离顶部距离
#define IPADLeftBtnListTopY 30.0f

//#define ISMainScreen @"isMainScreen"

// 按钮小圆角
#define BUTTON_CORNERRADIUS_SMALL 4.0f

// 按钮半圆角
#define BUTTON_CORNERRADIUS_HALF 20.0f

// 按钮边框
#define BUTTON_BORDERWIDTH 1.0f




#endif /* DefineUIStyle_h */
