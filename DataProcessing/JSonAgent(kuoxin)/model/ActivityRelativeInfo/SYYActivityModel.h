//
//  SYYActivityModel.h
//  SYY
//
//  Created by xjw on 2017/4/12.
//  Copyright © 2017年 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonResponse.h"

@interface SYYActivityModel : NSObject

///活动ID
@property(nonatomic,assign)NSInteger  activity_id;
///活动图片链接
@property(nonatomic,strong)NSString * activity_img_url;
///活动跳转链接
@property(nonatomic,strong)NSString * activity_jump_url;
///活动创建时间
@property(nonatomic,assign)NSInteger  activity_creative_time;

@property(nonatomic,strong)NSString * activity_location;

@property(nonatomic,strong)NSString * activity_performer;
@property(nonatomic,strong)NSString * activity_time;
//@property(nonatomic,assign)NSInteger activity_time;
@property(nonatomic,strong)NSString * activity_title;
@end
