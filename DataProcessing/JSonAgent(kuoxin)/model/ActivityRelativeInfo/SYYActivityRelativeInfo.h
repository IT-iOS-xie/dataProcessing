//
//  SYYActivityRelativeInfo.h
//  SYY
//
//  Created by xjw on 2017/4/12.
//  Copyright © 2017年 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonResponse.h"

@interface SYYActivityRelativeInfo : SYYJSonResponse

///最新活动数组
@property(nonatomic, strong) NSArray * newest_activity;//SYYActivityInfo

///最新专访数组
@property(nonatomic,strong)NSArray * newest_interview;  // SYYInterviewInfo

@end
