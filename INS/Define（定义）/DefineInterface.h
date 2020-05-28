
#ifndef DefineInterface_h
#define DefineInterface_h




// 请求成功响应数据的 KEY(服务器写错单词，这里做统一KEY使用)
static NSString *const KeySuccess = @"IsSucess";
// 请求数据成功
static NSInteger const RequestSuccess = 1;
// 请求数据失败
static NSInteger const RequestFail    = 0;
// 包数据量(默认)
static NSString *const PacketCount    = @"5000";


// 公网IP
static NSString *const rDefaultIP                = @"00.00.00.00";
// 公网端口
static NSString *const rDefaultPort              = @"8041";
// 前缀
static NSString *const rPrefix                   = @"http://";
// 后缀
static NSString *const rSuffix                   = @"/UTAPPService/JOYOD";

// 接口文档地址
// https://www.showdoc.cc/Instranger?page_id=4533897334201300


// - -
// 1.登录 POST
// 微信登录接口
//weixin_openId      是    String    微信标识
//weixin_nickname    否    String    微信昵称
//weixin_icon        否    String    微信头像地址
//weixin_gender      否    int       微信性别，1为男，0为女
static NSString *const rLoginWeixin = @"/login/weixin";

//2.手机号一键登录接口 POST
//user_phone    是    String    手机号
static NSString *const rLoginOnekey = @"/login/onekey";

//3.获取手机号接口 POST
//token    是    String    ⽤户确认授权后的token
static NSString *const rLoginGetphone = @"/login/getphone";


// - -
// 首页 GET
//1.关注人列表接口
//openPage      否    int    是否开启分页，默认不分页
//pageSize      否    int    页面个数 默认20
//pageIndex     否    int    第几页 默认第一页
//key           否    String    搜索关键字
//dic_id        否    String    标签标识
static NSString *const rFocus_tos = @"/focus_tos";


//2.关注人帖子列表/推荐帖子列表接口 GET
//openPage    否    int    是否开启分页，默认不分页
//pageSize    否    int    页面个数 默认5
//pageIndex   否    int    第几页 默认第一页
//topic_id    否    String    帖子标识
static NSString *const rTopics = @"/topics";


//3.帖子点赞操作接口 POST
//topic_id    是    String    帖子标识
static NSString *const rLikes = @"/likes";


//4.帖子取消点赞操作接口 DELETE
//topic_id    是    String    帖子标识
//user_id     是    String    (当前登录)取消点赞用户标识
static NSString *const rLikesDelete = @"/likes";


//5. 帖子收藏操作接口 POST
//topic_id    是    String    帖子标识
static NSString *const rCollects = @"/collects";

//6. 帖子取消收藏操作接口 DELETE
//topic_id    是    String    帖子标识
static NSString *const rCollectsDELETE = @"/collects";


//7. 帖子评论列表接口 GET
//openPage    否    int    是否开启分页，默认不分页
//pageSize    否    int    页面个数 默认20
//pageIndex   否    int    第几页 默认第一页
//topic_id    是    String    帖子标识
static NSString *const rCommentsDELETE = @"/comments";

//8. 私信用户列表接口 GET
//openPage    否    int    是否开启分页，默认不分页
//pageSize    否    int    页面个数 默认10
//pageIndex    否    int    第几页 默认第一页
static NSString *const rMsgsUsers = @"/msgs/users";

//9. 帖子转发操作接口 POST
//topic_id    是    String    帖子标识
//user_ids    是    String    选择的互关用户标识，用逗号隔开
//msg_content    否    String    私信文字内容
static NSString *const rMsgsTopic = @"/msgs/topic";


//10. 帖子发布操作 POST
//topic_type      是    String    帖子类型：PIC、VIDEO
//topic_at        否    String    帖子艾特的用户标识，用逗号隔开
//topic_desc      否    String    帖子说明
//topic_location  否    String    帖子定位
//topic_labels    否    String    帖子标签标识，多个，用逗号隔开
//topic_image1    是    String    图像文件1 base64格式
//topic_image1_suffix    是    String    图像文件1 的后缀，比如 png、jpg 等等
static NSString *const rMsgsTopic = @"/msgs/topic";

//11. 帖子评论发布操作 POST
//topic_id      是    String    帖子标识
//comment       是    String    用户评论
//at_user_id    否    String    艾特用户标识
static NSString *const rMsgsTopic = @"/comments";


// - -
// 发现
//1. 标签列表接口 GET
//openPage    是    int    0：不分页
static NSString *const rDicsLabel = @"/dics/label";

//2. 视频推荐接口 GET
//video_num    否    int    视频数量 默认1
//dic_id       否    String    标签标识
static NSString *const rDicsLabel = @"/topics/video";


//3. 图片推荐列表接口
//pic_num    否    int    图片数量 默认9
//dic_id     否    String    标签标识
static NSString *const rTopicsPic = @"/topics/pic";

//4. 热门搜索用户列表接口 GET
//openPage     否    int    是否开启分页，默认不分页
//pageSize     否    int    页面个数 默认10
//pageIndex    否    int    第几页 默认第一页
//key          否    String    搜索关键字
static NSString *const rUsersHot = @"/users/hot";

//5. 搜索用户列表接口 GET
//openPage    否    int    是否开启分页，默认不分页
//pageSize    否    int    页面个数 默认10
//pageIndex   否    int    第几页 默认第一页
//key         否    String    搜索关键字
static NSString *const rUsers = @"/users";

//6. 标签搜索用户列表接口 GET
//openPage    否    int    是否开启分页，默认不分页
//pageSize    否    int    页面个数 默认10
//pageIndex    否    int    第几页 默认第一页
//label_ids    否    String    便签标识，多个，用逗号隔开
static NSString *const rUsersLabel = @"/users/label";

//7. 地点搜索用户列表接口 GET
//openPage    否    int    是否开启分页，默认不分页
//pageSize    否    int    页面个数 默认10
//pageIndex   否    int    第几页 默认第一页
//key         否    String    搜索关键字
static NSString *const rUsersRegion = @"/users/region";

// - -
// 私信
//1. 私信详情接口 GET
//msg_user_id  是    String    对话者标识
//pageSize     否    int    页面个数 默认10
//pageIndex    否    int    第几页 默认第一页
//msg_time     是    String    时间点，格式为 yyyy-mm-dd HH:mm:ss 例子：2020-05-20 14:05:05
//is_before    是    int    1为查询此时间点前的记录，0为查询此时间点后的记录
static NSString *const rUsersRegion = @"/users/region";

//2. 私信读操作接口 POST
//msg_user_id    是    String    对话者标识
static NSString *const rMsgsRead = @"/msgs/read";

//3. 私信写操作接口 POST
//msg_id       否    String    私信标识
//msg_user_id  是    String    消息接受者标识
//msg_type     是    int    1为文字类型；2为表情类型；3为图片类型；4为视频类型；5为帖子类型
//msg_content  是    String    文字类型、表情类型的消息时，为文字内容；图片类型、视频类型的消息时，为Base64编码的字符串
//msg_suffix   否    String    图像文件1 的后缀，比如 png、jpg 等等
static NSString *const rMsgsWrite = @"/msgs/write";


// - -
// 动态（消息）
//1. 动态消息列表接口 GET
//pageSize       否    int    页面个数 默认10
//pageIndex      否    int    第几页 默认第一页
//action_type    否    int    动态消息类型：0为所有动态消息；1为粉丝；2为喜欢；3为@我的；4为评论
static NSString *const rMsgsAction = @"/msgs/action";

//2. 读-被用户关注操作接口 POST
//user_id    是    String    关注登陆者的用户标识
static NSString *const rFocussRead = @"/focuss/read";

//3. 读-关注用户帖子操作接口 POST
//user_id    是    String    关注登陆者的用户标识
static NSString *const rTopicsRead = @"/topics/read";

//4. 读-被艾特帖子操作接口 POST
//topic_id    是    String    艾特登陆者的帖子标识
static NSString *const rTopicsAtRead = @"/topics/at/read";

//5. 读-帖子评论操作接口 POST
//topic_id    是    String    帖子标识
static NSString *const rTopicsCommentRead = @"/topics/comment/read";

//6. 未读系统消息数量接口 GET
//code       Int    返回码 0代表成功 -1 代表失败
//message    String    返回成功或者失败的提示信息
//success    boolean    成功：true, 失败 ： false
//object.count    int    当前登录者未读系统消息数量
static NSString *const rSysmsgsCount = @"/sysmsgs/count";

//7. 第一条最新系统消息内容接口  GET
static NSString *const rSysmsgsFirst = @"/sysmsgs/first";

//8. 系统消息列表接口 GET
//pageSize     否    int    页面个数 默认10
//pageIndex    否    int    第几页 默认第一页
static NSString *const rSysmsgs = @"/sysmsgs";

//9. 系统消息读参照接口 POST
static NSString *const rSysmsgsRead = @"/sysmsgs/read";

//10. 推荐用户列表接口 GET
//openPage    否    int    是否开启分页，默认不分页
//pageSize    否    int    页面个数 默认10
//pageIndex   否    int    第几页 默认第一页
static NSString *const rUsersRecommend = @"/users/recommend";


// - -
//个人主页
//1. 查询用户简介接口 GET
static NSString *const rUsersInfo = @"/users/info/{user_id}";

//2. 查询个人资料接口 GET
static NSString *const rUsersDetail_info = @"/user/detail_info";

//3. 提交个人资料接口 POST
//user_name           是    String    用户名字
//user_desc           否    String    用户简介
//user_school         否    String    用户学校
//user_gender         否    int    用户性别
//user_birthday       否    String    用户生日，格式为 yyyy-mm-dd
//user_region         否    String    用户地区
//user_icon           否    String    图片文件 base64格式
//user_icon_suffix    否    String    图片文件 后缀
static NSString *const rUsersDetail_info = @"/users";

//4. 个人便签列表接口 GET
static NSString *const rUsersLabels = @"/users/labels";

//5. 提交个人标签接口 POST
//dic_ids    是    String    标签标识，多个，用逗号隔开
static NSString *const rUsersLabelsPost = @"/users/labels";

//6. 个人帖子列表列表接口 GET
//pageSize    否    int    页面个数 默认5
//pageIndex    否    int    第几页 默认第一页
static NSString *const rTopicsUser_id = @"/topics/{user_id}";


//7. 用户关注操作接口 POST
//user_id    是    String    被关注用户标识
static NSString *const rFocuss = @"/focuss";

//8. 用户取消关注操作接口 POST
//user_id    是    String    被取消关注用户标识
static NSString *const rUnfocuss = @"/unfocuss";

//9. 个人收藏帖子列表接口 GET
//pageSize     否    int    页面个数 默认9
//pageIndex    否    int    第几页 默认第一页
static NSString *const rCollects = @"/collects";

//10. 单个帖子详情接口
static NSString *const rTopicsDetailTopic_id = @"/topics/detail/{topic_id}";




#endif /* DefineInterface_h */
