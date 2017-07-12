//
//  SYYJPushMusicInfo.h
//  SYY
//
//  Created by xjw on 16/9/8.
//  Copyright © 2016年 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonResponse.h"
@class  SYYMusicModel;
/// 根据musicid获取音乐全信息接口转接类
@interface SYYJPushMusicInfo : SYYJSonResponse

@property(nonatomic,strong)SYYMusicModel * musics;
@end
