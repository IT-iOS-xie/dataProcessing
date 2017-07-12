//
//  SYYRecommendMusicListDetailResponse.h
//  SYY
//
//  Created by wlp on 2017/4/20.
//  Copyright © 2017年 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonResponse.h"
#import "SYYJsonSongListInfo.h"

@interface SYYRecommendMusicListDetailResponse : SYYJSonResponse

@property(nonatomic, strong) SYYJsonSongListInfo *song_list_info; 
@end
