//
//  SYYOfficialPushInfo.h
//  SYY
//
//  Created by xjw on 2017/1/3.
//  Copyright © 2017年 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonResponse.h"
/// 推送接口转接类
@interface SYYOfficialPushInfo : SYYJSonResponse
@property(nonatomic,strong)NSArray * my_messaged_list;
@end
