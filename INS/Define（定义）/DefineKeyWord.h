/************************************* 文件说明****************************************
 版权所有： 珠海优特电力科技股份有限公司
 版本号：   V1.0
 文件名：   DefineKeyWord.h
 生成日期：  16/11/11.
 作者：     卢沛翰
 文件说明： 项目运用到的关键词定义
 修改人：
 修改日期：
 ****************************************************************************************/


#ifndef DefineKeyWord_h
#define DefineKeyWord_h


// 操作结果 - - - - - - - - - - - - - - -
// 1 - 成功
#define Operation_Success           1
#define Operation_Success_Str       @"1"
#define Operation_Success_Desc      @"成功"
// 0 - 失败
#define Finished_Fail               0
#define Finished_Fail_Str           @"0"
#define Operation_Fail_Desc         @"失败"

// 答题题目选项分隔符号
#define AnswerSeparate @"&**&"
// 答案分隔符号
#define APPAnswerSeparate @","

// 题目类型 - 单选
#define TestItemSingle 1
// 题目类型 - 多选
#define TestItemMulti 2
// 题目类型 - 判断
#define TestItemJudge 3

// 默认答案
#define DefaultAnswer @"Z"





// 考试结果 - - - - - - - - - - - - - - -
// @0 - 未通过
#define ExamUnPass          @0
// @1 - 通过
#define ExamPass           @1



// 登录状态 - - - - - - - - - - - - - - -
// @0 - 未登录
#define LoginState_UnLogin          @0
// @1 - 用户名密码登录
#define LoginState_Name_Pwd            @1
// @2 - 扫描二维码登录
#define LoginState_Scan_QR            @2
// @3 - 离线登录
#define LoginState_OffLine            @3
// 判断二维码登录进来有没有答题
#define QRLOGIN_DID_FINISHEXAM @"QRLogin_Did_FinishExam"
// 自动登出时间
#define LOGOUT_TIME @"Logout_Time"
// 自动登出是否打开
#define LOGOUT_AUTO_STATE @"Logout_Auto_State"
// 考试状态，开始还是结束
#define EXAM_STATES @"Exam_States"
// 退出登录操作，发送通知
#define LOGOUT_NOW @"Logout_Now"
// 边考试边显示答案
#define EXAMING_ANSWER_DISPLAY @"Examing_Answer_Display"
// 上滑结束APP运行
#define EXAMING_TERMINATED @"Examing_Terminated"

// 下载路径 - - - - - - - - - - - - - - - - 
// 下载学习资料 本地保存路径
#define downLoadPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"StudyInfo"]

// 下载培训考试资料 本地保存路径
#define downLoadExamFilesPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"StudyExamInfo"]

// 取消下载培训文件
#define CANCELDOWNLOADFILE @"cancelDownLoadFile"

// 从其他APP，如微信、QQ导入本APP的文件所在的文件夹名
#define HSFolderName @"Inbox"

#endif /* DefineKeyWord_h */
