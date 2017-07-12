//
//  SYYJSonSearchMusicOrMusicianInfo.h
//  SYY
//
//  Created by kuoxin on 7/24/16.
//  Copyright © 2016 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonAbtractObject.h"

@class SYYJSonMusicianInfo;
@class SYYMusicModel;
///  搜索内容类
@interface SYYJSonSearchMusicOrMusicianInfo : SYYJSonAbtractObject
/**
 * 搜索结果类型
 *  > type = 0  代表音乐人
 *  > type = 1  代表音乐
 */
@property(nonatomic,assign)NSInteger type;
///音乐人成员属性
@property(nonatomic, strong)SYYJSonMusicianInfo *musicians;
/// 音乐成员属性
@property(nonatomic, strong)SYYMusicModel *music;
@end
