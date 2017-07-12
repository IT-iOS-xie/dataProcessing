//
//  SYYJSonResourceInfo.h
//  SYY
//
//  Created by kuoxin on 16/7/1.
//  Copyright © 2016年 cn.com.rockmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYYJSonAbtractObject.h"
/// 评论模型类
@interface SYYJSonResourceInfo : SYYJSonAbtractObject

///资源id
@property(nonatomic,assign)NSInteger resource_info_id;

///资源内容
@property(nonatomic,copy)NSString *resource_info_content;

///资源类型 1：图; 2：音频; 3:  文字
@property(nonatomic,assign)NSInteger resource_info_type;

///资源地址
@property(nonatomic,copy)NSString *resource_info_url;

///资源图片宽度（如果该资源是图片）
@property(nonatomic,assign)NSInteger resource_info_url_width;

///资源图片高度（如果该资源是图片）
@property(nonatomic,assign)NSInteger resource_info_url_height;

///资源缩图地址
@property(nonatomic,copy)NSString *resource_info_thumbnails_url;

///资源标准图地址
@property(nonatomic,copy)NSString *resource_info_normal_url;

///资源标准图地址宽度（正文图片）
@property(nonatomic,assign)NSInteger resource_info_normal_url_width;

///资源标准图地址高度（正文图片）
@property(nonatomic,assign)NSInteger resource_info_normal_url_height;

///资源源图地址或下载地址
@property(nonatomic,assign)NSInteger resource_info_original_url_width;

///资源源图地址或下载地址
@property(nonatomic,assign)NSInteger resource_info_original_url_height;

///资源源图地址或下载地址
@property(nonatomic,copy)NSString *resource_info_original_url;
///资源所有者（歌曲为上传人）
@property(nonatomic,copy)NSString *resource_info_owner;
///是否删除
@property(nonatomic,assign)BOOL is_delete;
@end
