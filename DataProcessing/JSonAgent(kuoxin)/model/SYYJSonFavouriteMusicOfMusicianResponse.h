//
//  SYYJSonFavouriteMusicOfMusicianResponse.h
//  SYY
//
//  Created by xjw on 16/7/28.
//  Copyright © 2016年 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonResponse.h"
/// 用户收藏列表转接类
@interface SYYJSonFavouriteMusicOfMusicianResponse : SYYJSonResponse
@property(nonatomic, copy) NSArray *favorite_list; //SYYJSonMusicInfo

@end
