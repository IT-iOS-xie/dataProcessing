//
//  SYYInterviewModel.h
//  SYY
//
//  Created by xjw on 2017/4/12.
//  Copyright © 2017年 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonResponse.h"

@interface SYYInterviewModel : NSObject

///专访ID
@property(nonatomic,assign) NSInteger interview_id;
///专访图片链接
@property(nonatomic,strong) NSString * interview_img_url;
///专访跳转链接
@property(nonatomic,strong)NSString * interview_jump_url;
///专访标题
@property(nonatomic,strong) NSString * interview_title;
///专访简介
@property(nonatomic,strong)NSString *interview_brief;

///专访创建时间

@property(nonatomic,assign)NSInteger  interview_creative_time;

@property(nonatomic,strong)NSString * interview_info_img_url;

@end
