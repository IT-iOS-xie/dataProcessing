//
//  SYYJsonInterviewCommentInfo.h
//  SYY
//
//  Created by wlp on 2017/4/25.
//  Copyright © 2017年 cn.com.rockmobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYYJsonInterviewCommentInfo : NSObject

//评论id
@property(nonatomic,assign)NSInteger comment_id;

//活动id
@property(nonatomic,assign)NSInteger activity_id;

//评论者
@property(nonatomic,copy)NSString* comment_owner_name;

//评论者id
@property(nonatomic,assign)NSInteger comment_owner_id;

//评论者头像
@property(nonatomic,copy)NSString* comment_owner_avatar_url;

//评论创建时间
@property(nonatomic,assign)NSInteger comment_creative_time;

//评论点赞数
@property(nonatomic,assign)NSInteger comment_like_count;

//评论的类型 1：图片2：音乐3：文字
@property(nonatomic, copy)NSMutableArray *resource_info;

//是否点赞
@property(nonatomic,assign)BOOL is_like;

//专访id
@property(nonatomic,assign)NSInteger interview_id;

@end
