//
//  SYYRecommendMusicInfo.h
//  SYY
//
//  Created by wlp on 2017/4/20.
//  Copyright © 2017年 cn.com.rockmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYYJSonAbtractObject.h"

@interface SYYRecommendMusicInfo : SYYJSonAbtractObject

// 音乐id
@property(nonatomic,assign)NSInteger music_id;

// 音乐人
@property(nonatomic,copy)NSString *musician_name;

// 音乐人id
@property(nonatomic,assign)NSInteger musician_id;

// 音乐url
@property(nonatomic,copy)NSString *music_url;

// 音乐配图
@property(nonatomic,copy)NSString *music_img;
// 音乐缩略图
@property(nonatomic,copy)NSString *music_thumbnail_img;

// 歌词url路径
@property(nonatomic,copy)NSString *music_lrc_url;

// 音乐风格
@property(nonatomic,copy)NSString * music_style;

// 音乐心情
@property(nonatomic,copy)NSArray * music_emotion;

// 是否喜欢
@property(nonatomic,assign)BOOL music_favorite;

// 音乐时长
@property(nonatomic,assign)NSInteger music_duration;

// 音乐描述
@property(nonatomic,copy)NSString *music_description;

// 创作时间
@property(nonatomic,assign)NSInteger  music_creative_time;

// 修改时间
@property(nonatomic,assign)NSInteger music_modified_time;

// 点赞数
@property(nonatomic,assign)NSInteger  music_like_count;

// 评论数
@property(nonatomic,assign)NSInteger music_comment_count;

// 播放数
@property(nonatomic,assign)NSInteger music_play_count;

// 歌手
@property(nonatomic,copy)NSString *music_singer_name;

//歌手id
@property(nonatomic,assign)NSInteger music_singer_id;

// 词作者
@property(nonatomic,copy)NSString *music_songwriter_name;

//  词作者id
@property(nonatomic,assign)NSInteger music_songwrite_id;

// 曲作者
@property(nonatomic,copy)NSString * music_composer_name;

/// 曲作者id
@property(nonatomic,assign)NSInteger  music_composer_id;

// 分享数
@property(nonatomic,assign)NSInteger music_share_count;

// 收藏数量
@property(nonatomic,assign)NSInteger music_favorite_count;

// 是否点赞
@property(nonatomic,assign)BOOL is_like;

// 音乐name
@property(nonatomic,copy)NSString *music_name;

// 是否允许下载
@property(nonatomic,assign)BOOL allow_download;

//是否删除
@property(nonatomic,assign)BOOL is_delete;

//乐手名称
@property(nonatomic,copy)NSString * music_player;

//录音师
@property(nonatomic,copy)NSString * music_sound_engineer;

//混音师
@property(nonatomic,copy)NSString * music_mixing_engineer;

//制作人名称
@property(nonatomic,copy)NSString * music_producer_name;

//编曲者名称
@property(nonatomic,copy)NSString * music_arrangement_name;

//是否推荐
//@property(nonatomic,assign)int recommand;

//播放状态
//music_playing_status	Enum

//审核状态
//music_check_status	Enum		

//审核的状态
//check_status	Int		审核的状态




@end
