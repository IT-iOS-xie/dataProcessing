//
//  SYYIOAbstractOperator.h
//  SYY
//
//  Created by kuoxin on 7/16/16.
//  Copyright © 2016 cn.com.rockmobile. All rights reserved.
//

#ifndef SYYIOAbstractOperator_h
#define SYYIOAbstractOperator_h

typedef void (^BLOCK_CODE)(id);

//@interface SYYIORequest
//@property(nonatomic, assign) int userId_;
//@property(nonatomic, assign) int timestamp_;
//
//@end

@protocol SYYIOAbstractOperator

/**
 得到推荐列表
 @param type  推荐内容类型·
 @param timestamp   用户关注的其他用户的时间
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getRecommendedInfo:(int) type
                  timestamp:(int)timestamp
         getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
      getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 得到用户事件列表
 @param userId  用户id（关注发起者）
 @param timestamp   用户关注的其他用户的时间
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getMusicianUserIssueInfo:(int) userId
                        timestamp:(int)timestamp
               getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
            getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 得到圈子分类列表
 @param categoryId  分类id
 @param timestamp   用户关注的其他用户的时间
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 @param  cacheKey   圈子首页缓存的键值
 */
//- (void) getMomentsHeadList:(int) categoryId
//                  timestamp:(int)timestamp
//         getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
//      getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;
-(void) getMomentsHeadList:(int) categoryId
                 timestamp:(NSInteger)timestamp
                  cacheKey:(NSString *)cacheKey
        getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
     getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;

/**
 得到圈子详情信息
 @param momentId  圈子帖子id
 @param getInfoUseBlocking  成功后，获取的回调函数
 @param getFailureUseBlocking  失败后，获取信息回调函数
 */
- (void) getMomentDetailInfo:(int) momentId
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
                 timestamp:(int)timestamp
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
           timestamp:(int)timestamp
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
                      timestamp:(int)timestamp
             getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
          getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;


@end

#endif /* SYYIOAbstractOperator_h */
