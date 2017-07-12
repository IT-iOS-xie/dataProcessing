//
//  SYYJSonMusicianInfo.h
//  SYY
//
//  Created by kuoxin on 7/7/16.
//  Copyright © 2016 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonAbtractObject.h"

/// 音乐人类
@interface SYYJSonMusicianInfo : SYYJSonAbtractObject

///关注数
@property(nonatomic,assign)NSInteger musician_attention_count;

///头像地址
@property(nonatomic,copy)NSString * musician_avatar_img_url;

///小头像地址
@property(nonatomic,copy)NSString * musician_avatar_thumbnail_url;

///歌手简介
@property(nonatomic,copy)NSString * musician_brief;

///粉丝数
@property(nonatomic,assign)NSInteger musician_fans_count;

///歌手id
@property(nonatomic,assign)NSInteger musician_id;
///歌手位置
@property(nonatomic,copy)NSString * musician_location;

///歌手姓名
@property(nonatomic,copy)NSString * musician_name;

//歌手性别
@property(nonatomic,assign)NSInteger musician_sex;

///歌手签名
@property(nonatomic,copy)NSString * musician_signature;


///音乐人注册时间

@property(nonatomic,assign)NSInteger musician_creative_time;

///是否被user关注
@property(nonatomic,assign)BOOL  is_attention;

///用户手机号
@property(nonatomic,copy)NSString *  musician_mobile_number;
// qq_id
@property(nonatomic,copy)NSString * musician_qq_id;
///weChat_id
@property(nonatomic,copy)NSString * musician_wechat_id;
/// weibo/id
@property(nonatomic,copy)NSString * musician_weibo_id;

//@property(nonatomic,copy)NSString * musician_password;
/// 音乐人email
@property(nonatomic,copy)NSString * musician_email;

/// 用户是否注册  0 未入驻 1 入驻  2 审核
@property(nonatomic,assign)NSInteger is_auth_user;


/// 音乐人风格
@property(nonatomic,copy)NSString * musician_style;

/// 用户等级
@property(nonatomic,assign)NSInteger auth_user_level;

///主页背景图片url
@property (nonatomic, strong)NSString *home_background_url;

///成长值
@property (nonatomic, assign) NSInteger auth_user_points;

///原创音乐数量
@property (nonatomic, assign) NSInteger musician_music_count;

/// 音乐人身份
@property(nonatomic,copy) NSString * musician_identity;



@end
