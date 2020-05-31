/************************************* 文件说明****************************************
 版权所有： 珠海优特电力科技股份有限公司
 版本号：   V1.0
 文件名：   UTProgressShow.h
 生成日期：  16/11/25.
 作者：     卢沛翰
 文件说明： 进度显示视图
 修改人：
 修改日期：
 ****************************************************************************************/

#import <Foundation/Foundation.h>




@interface UTProgressShow : NSObject





/** 显示视图*/
+ (void)showProgress;

/** 关闭视图*/
+ (void)dismissProgressView;

/** 显示进度视图
 *  参数text:     显示字符串
 */
//+ (void)progressViewWithText:(NSString *)text;

/**
 * 显示下载提示语
 * 参数text:     显示提示语字符串
 */
+ (void)progressViewWithNoticeText:(NSString *)text;

/** 显示进度视图
 *  参数value:     显示数值
 */
+ (void)progressViewWithFloatValue:(float)value;


/** 显示提示视图
 *  参数tips:     显示字符串
 */
+ (void)showTipsView:(NSString *)tips withTapBlock:(void (^) (void)) TapBlock;



/** 显示进度视图 取消按钮 Block*/
+ (void)showProgressWithCancelBlock:(void (^)(void))cancelBlock;

@end
