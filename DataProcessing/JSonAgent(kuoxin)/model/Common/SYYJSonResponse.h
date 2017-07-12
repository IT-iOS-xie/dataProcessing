//
//  SYYNetworkResponse.h
//  SYY
//
//  Created by kuoxin on 16/7/1.
//  Copyright © 2016年 cn.com.rockmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYYJSonAbtractObject.h"
/// 网络请求的基础类
@interface SYYJSonResponse : SYYJSonAbtractObject

//总共记录数
//@property(nonatomic,assign)NSInteger total_size;

//总页数
//@property(nonatomic,assign)NSInteger total_page_size;

///请求单页记录数
@property(nonatomic,assign)NSInteger current_page_size;

//当前页索引从1开始
//@property(nonatomic,assign)NSInteger page_index;

/// 时间【必须提供】
@property(nonatomic,assign)NSInteger datetime;

/// 返回消息【必须提供】
@property(nonatomic,copy)NSString *message;

/// 返回错误信息【必须提供】
@property(nonatomic,assign)NSInteger result;

///【必须提供】
@property(nonatomic,assign)NSInteger session_id;

///token【必须提供】
@property(nonatomic,copy)NSString* token;

@end
