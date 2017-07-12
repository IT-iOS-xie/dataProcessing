//
//  SYYJSonMomentsDetailInfoData.h
//  SYY
//
//  Created by kuoxin on 16/7/1.
//  Copyright © 2016年 cn.com.rockmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYYJSonAbtractObject.h"
/// 帖子类
@interface SYYJSonMomentInfo : SYYJSonAbtractObject

///帖子id
@property(nonatomic,assign)NSInteger moments_id;

///帖子创建&修改时间
@property(nonatomic,assign)NSInteger moments_creative_time;

///帖子简述
@property(nonatomic,copy)NSString *moments_brief;


///帖子标题
@property(nonatomic,copy)NSString *moments_title;

///帖子作者位置
@property(nonatomic,copy)NSString *moments_owner_location;

///帖子点赞数
@property(nonatomic,assign)NSInteger moments_like_count;

///帖子评论
@property(nonatomic,assign)NSInteger moments_comment_count;

///帖子缩略图
@property(nonatomic,copy)NSString *moments_thumbnail_img_url;

///帖子作者头像
@property(nonatomic,copy)NSString *moments_owner_avatar_url;

///帖子作者名
@property(nonatomic,copy)NSString *moments_owner_name;

///帖子用户id
@property(nonatomic,assign)NSInteger moments_owner_id;

///帖子分类id
@property(nonatomic,assign)NSInteger category_id;

//帖子修改时间
@property(nonatomic,assign)NSInteger moments_modified_time;

///帖子分类名称
@property(nonatomic,copy)NSString *category_name;

///帖子分类图片
@property(nonatomic,copy)NSString *category_img_url;

///帖子内容资源
@property(nonatomic, copy)NSMutableArray *resource_info;

///头像缩略图地址
@property (nonatomic, copy)NSString *moments_owner_avatar_thumbnail_url;

///是否喜欢
@property(nonatomic,assign)BOOL is_like;

/// 是否关注
@property(nonatomic,assign)BOOL is_attention;


@end
