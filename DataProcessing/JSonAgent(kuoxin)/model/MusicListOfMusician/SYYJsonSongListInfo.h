//
//  SYYJsonSongListInfo.h
//  SYY
//
//  Created by wlp on 2017/4/20.
//  Copyright © 2017年 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonAbtractObject.h"

@interface SYYJsonSongListInfo : SYYJSonAbtractObject

///歌单数组
@property (nonatomic, strong) NSMutableArray *music_list;

//歌单id
@property(nonatomic,assign)NSInteger song_list_id;

//歌单图
@property(nonatomic,strong)NSString * song_list_img_url;

//歌单缩略图
@property(nonatomic,strong)NSString * song_list_thumbnail_url;

//歌单标题
@property(nonatomic,strong)NSString * song_list_title;

//歌单的风格
@property(nonatomic,strong)NSString * song_list_style;

//歌单详情主题
@property(nonatomic,strong) NSString *song_list_theme;


@end
