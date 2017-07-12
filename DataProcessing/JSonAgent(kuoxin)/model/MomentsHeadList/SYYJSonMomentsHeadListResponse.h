//
//  SYYJSonMomentsHeadListResponse.h
//  SYY
//
//  Created by kuoxin on 7/7/16.
//  Copyright © 2016 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonResponse.h"
///  得到圈子分类列表接口转接类
@interface SYYJSonMomentsHeadListResponse : SYYJSonResponse


@property(nonatomic, copy) NSArray* moment_heads; //SYYJSonMomentsHeadInfo
@end
