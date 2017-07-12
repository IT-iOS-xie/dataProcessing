//
//  SYYHomeHOT_NEWMusicList.h
//  SYY
//
//  Created by xjw on 2017/4/18.
//  Copyright © 2017年 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonResponse.h"

@interface SYYHomeHOT_NEWMusicList : SYYJSonResponse
///最新
@property(nonatomic, strong) NSArray * recommended_newest_music_list;

///最热
@property(nonatomic,strong)NSArray * recommended_hottest_music_list;
@end
