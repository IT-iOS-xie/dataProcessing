//
//  SYYInterviewCommentsResponse.h
//  SYY
//
//  Created by wlp on 2017/4/25.
//  Copyright © 2017年 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonResponse.h"

@interface SYYInterviewCommentsResponse : SYYJSonResponse
//专访评论
@property(nonatomic, copy) NSArray *interview_comment;
@end
