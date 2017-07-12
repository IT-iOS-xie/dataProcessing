//
//  SYYJSonAdvertisementInfo.h
//  SYY
//
//  Created by kuoxin on 7/7/16.
//  Copyright © 2016 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonAbtractObject.h"
/// 广告adv模型类
@interface SYYJSonAdvertisementInfo : SYYJSonAbtractObject
///id
@property(nonatomic,assign)NSInteger resource_info_id;

///资源名
@property(nonatomic,copy)NSString * resource_info_name;

///图片链接
@property(nonatomic,strong)NSString *resource_info_normal_url;

///跳转链接
@property(nonatomic,strong)NSString * resource_info_url;
@end
