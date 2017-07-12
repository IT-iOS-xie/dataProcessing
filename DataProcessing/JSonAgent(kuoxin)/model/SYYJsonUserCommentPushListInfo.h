//
//  SYYJsonUserCommentPushListInfo.h
//  SYY
//
//  Created by xjw on 2016/12/30.
//  Copyright © 2016年 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonResponse.h"
/// 评论接口转接类
@interface SYYJsonUserCommentPushListInfo : SYYJSonResponse

@property(nonatomic,strong)NSArray * my_commented_list;
@end
