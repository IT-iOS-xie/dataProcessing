//
//  SYYJSonMusicInfo.h
//  SYY
//
//  Created by kuoxin on 7/5/16.
//  Copyright © 2016 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonAbtractObject.h"

@interface SYYJSonMusicInfo : SYYJSonAbtractObject
@property(nonatomic,assign)NSInteger music_comment_count;

@property(nonatomic,assign)NSInteger  music_composer_id;
@property(nonatomic,copy)NSString * music_composer_name;
@property(nonatomic,assign)NSInteger  music_creative_time;

@property(nonatomic,assign)NSInteger music_description;

@property(nonatomic,copy)NSString *music_duration;

@property(nonatomic,copy)NSString *music_emotion;


@property(nonatomic,copy)NSString *music_favorite;

@property(nonatomic,assign)NSInteger music_id;


@property(nonatomic,copy)NSString *music_img;

@property(nonatomic,assign)NSInteger  music_like_count;

@property(nonatomic,copy)NSString *music_lrc_url;

@property(nonatomic,copy)NSString *music_name;

@property(nonatomic,assign)NSInteger music_play_count;

@property(nonatomic,assign)NSInteger music_share_count;


@property(nonatomic,assign)NSInteger music_singer_id;

@property(nonatomic,copy)NSString *music_singer_name;
@property(nonatomic,assign)NSInteger music_songwrite_id;


@property(nonatomic,copy)NSString *music_songwriter_name;



@property(nonatomic,copy)NSString *music_style;



@property(nonatomic,copy)NSString *music_thumbnail_img;



@property(nonatomic,copy)NSString *music_url;

@property(nonatomic,assign)NSInteger musician_id;
@property(nonatomic,copy)NSString *musician_name;

@property(nonatomic,assign)NSInteger music_favorite_count;

@end
