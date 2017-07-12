//
//  SYYGetMoreSongLIstInfo.h
//  SYY
//
//  Created by xjw on 2017/4/18.
//  Copyright © 2017年 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonResponse.h"

@interface SYYGetMoreSongLIstInfo : SYYJSonResponse

@property(nonatomic,strong)NSArray *song_list; //SYYHomeSongListModel
@end
