//
//  SYYJSonCommentInfo.h
//  SYY
//
//  Created by kuoxin on 7/7/16.
//  Copyright © 2016 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonAbtractObject.h"

@interface SYYJSonCommentInfo : NSObject

//评论id
@property(nonatomic,assign)NSInteger comment_id;

//音乐id
@property(nonatomic,assign)NSInteger music_id;

//评论者
@property(nonatomic,copy)NSString* comment_owner_name;

//评论者id
@property(nonatomic,assign)NSInteger comment_owner_id;

//评论者头像
@property(nonatomic,copy)NSString* comment_owner_avatar_url;

//评论者头像缩略图
@property(nonatomic,copy)NSString* comment_owner_avatar_thumbnail_url;

//评论创建时间
@property(nonatomic,assign)NSInteger comment_creative_time;

//评论点赞数
@property(nonatomic,assign)NSInteger comment_like_count;

//评论的类型 1：图片2：音乐3：文字
@property(nonatomic, copy)NSMutableArray *resource_info;

//是否点赞
@property(nonatomic,assign)BOOL is_like;
@end
