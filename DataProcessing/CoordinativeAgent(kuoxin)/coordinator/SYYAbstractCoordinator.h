//
//  SYYAbstractCoordinator.h
//  SYY
//
//  Created by kuoxin on 7/7/16.
//  Copyright © 2016 cn.com.rockmobile. All rights reserved.
//

#ifndef SYYAbstractCoordinator_h
#define SYYAbstractCoordinator_h
/// 枚举类 取值类型
typedef NS_ENUM(NSUInteger, SYY_RECOMMENDED_INFO_TYPE) {
    SYY_RECOMMENDED_INFO_DEFAULT = 0,   //!< 默认全取 0
    SYY_RECOMMENDED_INFO_MUSICS = 1,    //!< 推荐音乐 1
    SYY_RECOMMENDED_INFO_MUSICIANS = 2   //!< 推荐音乐人 2
};

/**
 *    提供系统协调器抽象协议
 */
@protocol SYYAbstractCoordinator


/**
 * 得到推荐列表
 * @param type  推荐内容类型·
 * @param timestamp   用户关注的其他用户的时间
 * @param getInfoUseBlocking  成功后，获取的回调函数
 * @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getRecommendedInfo:(SYY_RECOMMENDED_INFO_TYPE) type uid:(int)uid
                  timestamp:(NSInteger)timestamp
         getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
      getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;



/**
 得到圈子分类列表
 @param categoryId  分类id
 @param timestamp   用户关注的其他用户的时间
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 @param cacheKey  缓存圈子首页的键值
 */


-(void) getMomentsHeadList:(int) categoryId
                 timestamp:(NSInteger)timestamp
                  cacheKey:(NSString *)cacheKey
                   withUid:(int)userId
        getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
     getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;


/**
 得到圈子详情信息
 @param momentId  圈子帖子id
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */

-(void) getMomentDetailInfo:(int) momentId andUserId:(int)userId
         getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
      getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 得到关注用户列表
 @param userId  用户id（关注发起者）
 @param timestamp   用户关注的其他用户的时间
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getAttentionsInfo:(int) userId
                 timestamp:(NSInteger)timestamp
        getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
     getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 得到粉丝用户列表
 @param userId  用户id（被粉人）
 @param timestamp   用户关注的其他用户的时间
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getFansInfo:(int) userId
           timestamp:(NSInteger)timestamp
  getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 得到指定音乐人上传审核过的音乐列表
 @param userId  用户id
 @param timestamp   用户关注的其他用户的时间
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getMusicListOfMusician:(int) userId
      timestamp:(NSInteger)timestamp
 getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;



/**
 得到当前音乐列表
 @return 返回当前音乐列表
 */

- (id) getDefaultMusicListWithType:(int)type;

/**
 获取上传资源token
 @param type   token类型
 @param key    文件名称
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getUploadResourceToken:(int) type
                            key:(NSString*) key
             getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
          getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 上传帖子
 @param jsonString  帖子信息
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) uploadMomentInfo:(NSString*) jsonString
       getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
    getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 上传圈子、音乐评论
 @param jsonString  评论信息
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) uploadCommentInfo:(NSString*) jsonString
       getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
    getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 上传音乐评论
 @param jsonString  评论信息
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */

-(void)uploadMusicCommentInfo:(NSString*) jsonString
           getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
        getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;
/**
 得到音乐评论列表
 @param musicId musicID
 @param timestamp   用户关注的其他用户的时间
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getMusicCommentList:(int) musicId ForUid:(int)uid
              timestamp:(NSInteger)timestamp
     getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
  getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 得到圈子评论列表
 @param momentId 帖子ID
 @param timestamp   用户关注的其他用户的时间
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */

//- (void)getMomentCommentList:(int) momentId withUserId:(int)userId
//timestamp:(NSInteger)timestamp
//getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
//       getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;
- (void) getMomentCommentList:(int) momentId withUserId:(int)userId
                    timestamp:(NSInteger)timestamp
                     cacheKey:(NSString *)cacheKey
           getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
        getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;
/**
 得到热搜列表  七个
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getHotSearchList:(void (^)(id response))getInfoUseBlocking withUid:(int)uid cacheKey:(NSString *)cacheKey
        getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 查询结果
 @param condition 查询条件（音乐&音乐人）
 @param timestamp   用户关注的其他用户的时间
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getSearchMusicOrMusicianList:(NSString*) condition WithUid:(NSInteger)userId
                    timestamp:(int)timestamp
           getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
        getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 得到发布音乐列表
 @param userId  用户ID
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getPublishMusicList:(int) userId  timestamp:(NSInteger)timestamp  getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
     getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;
/**
 删除音乐
 @param userId  用户ID
  @param mcid  音乐ID
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getPublishMusicList:(int) userId  mcid:(int)musicId  getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
       getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 得到收藏音乐列表
 @param userId  用户ID
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getFavouriteMusicList:(int) userId  timestamp:(NSInteger)timestamp getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
       getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 用户关注
 @param userId  用户ID
 @parm   aid    关注用户id
  @parm   type    0为关注  / 1为取消关注
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
//-(void)getAttentions:(int)userId to:(int)aid  withType:(int)type
//  getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
//getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

- (void) getAttentionInfo:(NSString*) jsonString        getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
           getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;
/**
 音乐点赞
 @param mcid  音乐ID
  @parm   type    0为点赞  / 1为取消点赞
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) uploadLikeMusic:(NSString*) jsonString
              getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
           getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;


/**
 音乐评论点赞
 @param cmid  音乐评论ID
  @parm   type    0为点赞  / 1为取消点赞
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */

- (void) uploadLikeMusicComment:(NSString*) jsonString
      getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
   getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 帖子评论点赞
 @param cmid  圈子评论ID
  @parm   type    0为点赞  / 1为取消点赞
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */


- (void) uploadMomentCommentLike:(NSString*) jsonString
       getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
    getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 帖子点赞
 @param mid  帖子ID
 @parm   type    0为点赞 / 1为取消点赞

 */

- (void) uploadMomentLike:(NSString*) jsonString
              getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
           getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;


/**
 上传个人信息接口
 @param jsonString  个人信息
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) uploadMusicianInfo:(NSString*) jsonString to:(int)userId
       getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
    getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;


/**
 获取推荐关注/热门音乐人接口   十个列表
 @param tm  时间戳 （最后一个user注册时间）
 */


-(void)getHotORSuggestMusicianList:(NSInteger)timestamp  withUserId:(int)userId  cacheKey:(NSString *)cacheKey getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
             getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 收藏音乐
 @param userId  用户ID
 @parm   mcid    收藏音乐id
 @parm   type    0为关注  / 1为取消关注

 */
//-(void)getMusicAttention:(int)userId to:(int)mcid withType:(int)type;

- (void) getMusicAttentionInfo:(NSString*) jsonString
             getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
          getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;
/**
 上传用户意见反馈
 @param jsonString  意见反馈信息
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) uploadUserFeedbackInfo:(NSString*) jsonString
       getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
    getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 上传用户咨询信息
 @param jsonString  意见反馈信息
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) uploadUserConsultInfo:(NSString*) jsonString
            getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
         getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 用户注册接口
 @param jsonString  用户注册信息
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) uploadUserRegisterInfo:(NSString*) jsonString
            getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
         getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;
/**
 用户登录接口
 @param jsonString  用户
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getUserLogininInfo:(NSString*) jsonString
             getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
          getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 用户第三方登录接口
 @param jsonString  用户
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getUserThirdLogininInfo:(NSString*) jsonString
         getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
      getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;


/**
 用户登录后获取信息接口(获取音乐人全信息接口)
 @param userId  用户id
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getUserInformationInfoWithUid:(NSInteger) userId
         getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
      getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;


/*
 分享圈子接口
 @param mid  圈子id
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数

 
 */
- (void)getUserShareInformation:(int)momentId
             getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
          getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;


/*
 分享音乐接口
 @param mid  musicId
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 
 
 */
- (void)getUserShareMusicInformation:(int)musicId
             getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
          getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 验证手机是否注册通道
 @param jsonString  用户手机号信息
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) verifyUserPhoneNumberInfo:(NSString*) jsonString
                getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
             getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 用户更改密码接口
 @param jsonString  用户账号和新密码
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) uploadUserNewPasswordInfo:(NSString*) jsonString
             getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
          getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 用户获取短信验证码接口
 @param jsonString  用户手机信息
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getSMSMessageInfo:(NSString*) jsonString
             getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
          getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 用户短信通道验证接口
 @param jsonString  用户验证信息
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getSMSMessageVerifyInfo:(NSString*) jsonString
        getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
     getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 用户账号绑定第三方
 @param jsonString  用户账号信息
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getUserAccountBlindInfo:(NSString*) jsonString        getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
           getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;
/**
 用户手机号绑定
 @param jsonString  用户手机号信息
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getUserTelephoneNumberBlindInfo:(NSString*) jsonString        getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
           getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 根据musicId获取music
 @param jsonString  用户手机号信息
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */

- (void)getPushMusicModel:(int)musicId
                  getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
               getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 获得歌曲播放数
 @param  musicId 音乐id
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */

- (void) getPlayingWithMusicId:(NSInteger)musicId
            getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
         getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;



/**
 
 @param  jsonString 发送设备信息 ,获得版本号
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */



- (void) getVersionAndTokenWith:(NSString*) jsonString         getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
          getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;



/**
 上传用户举报信息
 @param jsonString  举报信息
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) uploadUserReportInfo:(NSString*) jsonString
            getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
        getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;




/**
 音乐人入驻资料上传
 @param jsonString  入驻音乐人信息
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) uploadAuthMusicianInformation:(NSString*) jsonString
       getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
    getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 获取音乐人发布的音乐列表
 @param   uid  当前用户id
         aid  被查看用户id
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getMusicianMusicListWith:(int)userId  and:(int)aid withTimestamp:(NSInteger)timestamp
           getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
        getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;
/**
 获取音乐人发布的音乐列表
 @param   uid  当前用户id  aid  被查看用户id
 aid  被查看用户id   aid  被查看用户id   tm时间
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getMusicianInformationInfoWithUid:(NSInteger) userId and:(NSInteger)aid withTimestamp:(NSInteger)timestamp
                    getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
                     getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;


/**
 获取音乐人发布的帖子列表
 @param   uid  当前用户id
  tm时间
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getMusicianMomentListWithUid:(NSInteger) userId withTimestamp:(NSInteger)timestamp
                        getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
                     getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 获取音乐人发布的帖子列表
 @param   uid  当前用户id
 aid  被查看用户id   aid  被查看用户id   tm时间
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getMusicianMomentListWithUid:(NSInteger) userId  andaid:(NSInteger)aid withTimestamp:(NSInteger)timestamp
                   getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
                getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;
/**
 设备启动调用接口
 @param   uid  当前用户id

 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 
 */

- (void) getVersionInformation:(NSString*) jsonString
        getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
        getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 用户获取短信验证码接口（调用java接口）
 @param jsonString  用户手机信息
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getVerificationCode:(NSString*) jsonString
        getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
     getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 用户获取推送评论接口
 @param uid 用户id
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getCommentPushListWithUid:(NSInteger) userId withTimestamp:(NSInteger)timestamp
                   getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
                getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 用户获取推送点赞接口
 @param uid 用户id
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getMusicOrMomentPushListWithUid:(NSInteger) userId withTimestamp:(NSInteger)timestamp
                getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
             getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 推送消息
 @param uid 用户id
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getPushListWithUid:(NSInteger) userId withTimestamp:(NSInteger)timestamp
                      getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
                   getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
更细版本信息
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getAPPVersiongetInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
      getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;
/**
删除帖子
 
 @param token 认证token
 @param   s_id 会话id
 @param   mid  帖子id
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) deleteMomentInfoWithMid:(NSInteger)mid  andUid:(NSInteger)uid getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
                   getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;
/**
 轮询获取推送消息
@param token 认证token
@param   s_id 会话id
@param   uid 用户id
@param getInfoUseBlocking  成功后，获取的回调函数
@param getFailureUseBlocking  失败后，获取信息回调函数
*/
- (void)getNotifyInformationWithUid:(NSInteger)uid getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
           getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
音乐删除接口

@param   mcid 音乐id
@param    uid 用户id
@param getInfoUseBlocking  成功后，获取的回调函数
@param getFailureUseBlocking  失败后，获取信息回调函数
*/
- (void) deleteMusicWithMcid:(NSInteger)mcid  andUid:(NSInteger)uid getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
           getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 发现页首页接口

 @param    uid 用户id
 @param   type default: 0 首页 1 专访列表 2 活动列表

 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
//- (void)getActivityRelativeDataWithUid:(NSInteger)uid withActivityType:(NSInteger)tpye  withTimestamp:(NSInteger)timestamp getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
//                 getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

- (void)getActivityRelativeDataWithUid:(NSInteger)uid withActivityType:(NSInteger)tpye  withTimestamp:(NSInteger)timestamp withCacheKey:(NSString *)cacheKey getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
                 getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 首页最新最热音乐接口
 
 @param    uid 用户id
 @param    tm 时间戳
  @param    sz 获取长度
 @param   type default: tp:0 最新音乐列表 tp:1 最热音乐列表
 
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void)getNewestORHotestMusicListWithUid:(NSInteger)uid withMusicType:(NSInteger)tpye   AndKey:(NSString *)key withTimestamp:(NSInteger)timestamp getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
                 getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 首页获取更多歌单接口
 
 @param    tm 时间戳
 @param    sz 获取长度
 
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void)getMoreMusicListwithTimestamp:(NSInteger)timestamp getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;
/**
 发现页专访、活动搜索接口
 @param search 根据标题搜索
 @param tp   搜索类型  Int	0  专访搜索   1 活动搜索

 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getSearchInterviewOrActivityList:(NSString*) condition
                         withActivityType:(NSInteger)tpye
                       getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking

                    getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
  获取搜索音乐人信息接口
 @param search 根据标题搜索

 
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void)getMusicianListWith:(NSString *)searchStr  WithUid:(NSInteger) uid
                     andTimestamp:(NSInteger)timestamp
                       getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking

                    getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 获取音乐人信息接口
 @param uid 用户id
 @param tp   搜索类型  Int	0  最新音乐人   1 最热音乐人
 
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void)getHotOrNewMusicianListWithUid:(NSInteger) uid
                          andTimestamp:(NSInteger)timestamp withTP:(NSInteger)type
         getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking

      getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;


/**
 获取推荐歌单详情的音乐列表
 @param   uid  当前用户id
 @param   songlistId 歌单id
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getRecommendMusicListWith:(int)userId  withSongListId:(NSInteger)songlistId
               getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
            getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;


/**
 得到专访详情相关评论列表
 @param interviewId 专访ID
 @param timestamp   时间戳
 @param    sz 获取长度
 
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */

- (void) getInterviewRelativeCommentList:(int) interviewId withUserId:(int)userId withSize:(int)size
                    timestamp:(NSInteger)timestamp
           getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
        getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 上传专访发布评论
 @param jsonString  评论信息
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void)uploadInterViewCommentInfo:(NSString*) jsonString
        getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
     getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 上传活动发布评论
 @param jsonString  评论信息
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) uploadActivityDetailCommentInfo:(NSString*) jsonString
                      getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
                   getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;
/**
得到活动评论列表
 @param interviewId 专访ID
 @param timestamp   时间戳
 @param    sz 获取长度
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */

- (void) getAcitivityRelativeCommentList:(int)activityId  withUserId:(int)userId withSize:(int)size
                               timestamp:(NSInteger)timestamp
                      getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
                   getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 专访评论点赞
 @param cmid  评论ID
 @parm   type    0为点赞  / 1为取消点赞
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */

- (void) uploadInterviewCommentLike:(NSString*) jsonString
              getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
           getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 活动评论点赞
 @param cmid  评论ID
 @parm   type    0为点赞  / 1为取消点赞
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */

- (void) uploadActivityCommentLike:(NSString*) jsonString
                 getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
              getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;


/**
 获取搜索默认值接口
 @param tpye  0->首页搜索默认值  1->专访搜索默认值  2->活动搜索默认值
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
-(void) getDefaultSearchValue:(int) tpye
           getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
        getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;



@end


#endif /* SYYAbstractCoordinator */
