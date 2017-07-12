//
//  SYYJsonHotORSuggestMusicianResponse.h
//  SYY
//
//  Created by xjw on 16/8/12.
//  Copyright © 2016年 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonResponse.h"
/// 获取推荐关注/热门音乐人接口转接类
@interface SYYJsonHotORSuggestMusicianResponse : SYYJSonResponse
@property(nonatomic, copy) NSMutableArray* musicians;//SYYJSonMusicianInfo
@end
