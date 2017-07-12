//
//  SYYLikeMusicOrMomentInfo.h
//  SYY
//
//  Created by xjw on 2017/1/3.
//  Copyright © 2017年 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonResponse.h"
/// 用户获取推送点赞接口转接类
@interface SYYLikeMusicOrMomentInfo : SYYJSonResponse
@property(nonatomic,strong)NSArray * my_liked_list;
@end
