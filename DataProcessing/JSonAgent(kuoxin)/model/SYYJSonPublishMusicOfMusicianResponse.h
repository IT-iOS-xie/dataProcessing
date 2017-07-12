//
//  SYYJSonPublishMusicOfMusicianResponse.h
//  SYY
//
//  Created by xjw on 16/7/28.
//  Copyright © 2016年 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonResponse.h"
///  用户发布音乐转接类
@interface SYYJSonPublishMusicOfMusicianResponse : SYYJSonResponse
@property(nonatomic, copy) NSArray *issue_musics; //SYYJSonMusicInfo
@end
