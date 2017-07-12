//
//  SYYMusicModel.h
//  SYY
//
//  Created by xjw on 2017/2/22.
//  Copyright © 2017年 cn.com.rockmobile. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "SYYJSonAbtractObject.h"

@interface SYYMusicModel : SYYJSonAbtractObject


/// 评论数
@property(nonatomic,assign)NSInteger music_comment_count;

/// 作曲者id
@property(nonatomic,assign)NSInteger  music_composer_id;

/// 作曲者name
@property(nonatomic,copy)NSString * music_composer_name;

/// 创作时间
@property(nonatomic,assign)NSInteger  music_creative_time;

/// 音乐描述
@property(nonatomic,copy)NSString *music_description;

/// 音乐时长
@property(nonatomic,assign)NSInteger music_duration;

//@property(nonatomic,copy)NSString * music_emotion;

// 是否喜欢
@property(nonatomic,assign)BOOL music_favorite;

// 音乐id
@property(nonatomic,assign)NSInteger music_id;

// 音乐配图
@property(nonatomic,copy)NSString *music_img;

// 点赞数
@property(nonatomic,assign)NSInteger  music_like_count;

// 歌词url路径
@property(nonatomic,copy)NSString *music_lrc_url;

// 音乐name
@property(nonatomic,copy)NSString *music_name;

// 播放数
@property(nonatomic,assign)NSInteger music_play_count;

// 分享数
@property(nonatomic,assign)NSInteger music_share_count;

//歌手id
@property(nonatomic,assign)NSInteger music_singer_id;

// 歌手
@property(nonatomic,copy)NSString *music_singer_name;

// 作曲人id
@property(nonatomic,assign)NSInteger music_songwrite_id;

// 作曲
@property(nonatomic,copy)NSString *music_songwriter_name;

// 音乐缩略图
@property(nonatomic,copy)NSString *music_thumbnail_img;

// 音乐url
@property(nonatomic,copy)NSString *music_url;

// 音乐人id
@property(nonatomic,assign)NSInteger musician_id;

// 音乐人
@property(nonatomic,copy)NSString *musician_name;

// 点赞数
@property(nonatomic,assign)NSInteger music_favorite_count;

// 修改时间
@property(nonatomic,assign)NSInteger music_modified_time;

// 是否点赞
@property(nonatomic,assign)BOOL is_like;

// 音乐心情
@property(nonatomic,copy)NSArray * music_emotion;

// 音乐风格
@property(nonatomic,copy)NSString * music_style;

/// 是否允许下载
@property(nonatomic,assign)BOOL allow_download;

///是否删除
@property(nonatomic,assign)BOOL is_delete;


- (NSArray *)getMusicProperties;
@end
