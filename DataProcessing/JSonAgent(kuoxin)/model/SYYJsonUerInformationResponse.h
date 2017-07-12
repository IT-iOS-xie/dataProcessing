//
//  SYYJsonUerInformationResponse.h
//  SYY
//
//  Created by xjw on 16/8/17.
//  Copyright © 2016年 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonResponse.h"
@class SYYJSonMusicianInfo;

/// 用户登录后获取信息接口转接类
@interface SYYJsonUerInformationResponse : SYYJSonResponse

/// 音乐人成员属性
@property(nonatomic, retain)SYYJSonMusicianInfo *ownerinfo;
@end
