//
//  SYYJSonSearchInterviewOrActivityResponse.h
//  SYY
//
//  Created by wlp on 2017/4/17.
//  Copyright © 2017年 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonResponse.h"
/// 搜索专访/活动转接类
@interface SYYJSonSearchInterviewOrActivityResponse : SYYJSonResponse

/// 最新专访数组
@property(nonatomic, strong) NSArray* interview_search;

///最新活动数组
@property(nonatomic, strong) NSArray* activity_search;

@end
