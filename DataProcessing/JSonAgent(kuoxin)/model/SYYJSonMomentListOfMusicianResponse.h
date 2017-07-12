//
//  SYYJSonMomentListOfMusicianResponse.h
//  SYY
//
//  Created by xjw on 16/12/21.
//  Copyright © 2016年 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonResponse.h"
///获取音乐人发布的帖子转接类
@interface SYYJSonMomentListOfMusicianResponse : SYYJSonResponse
@property(nonatomic, copy) NSArray * my_moments_list; //SYYJSonMomentInfo
@end
