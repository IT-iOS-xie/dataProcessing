//
//  SYYJSonMomentsResponse.h
//  SYY
//
//  Created by kuoxin on 7/4/16.
//  Copyright © 2016 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonResponse.h"
#import "SYYJSonMomentInfo.h"
 ///  得到圈子详情接口转接类
@interface SYYJSonMomentsResponse : SYYJSonResponse

/// 帖子对象属性
@property(nonatomic, strong)SYYJSonMomentInfo *moment_info;

@end
