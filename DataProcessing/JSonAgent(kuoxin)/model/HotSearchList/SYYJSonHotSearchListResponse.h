//
//  SYYJSonHotSearchListResponse.h
//  SYY
//
//  Created by kuoxin on 7/24/16.
//  Copyright © 2016 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonResponse.h"
/// 热搜列表接口转接类
@interface SYYJSonHotSearchListResponse : SYYJSonResponse
@property(nonatomic, copy) NSMutableArray* hot_musicians;//SYYJSonMusicianInfo
@end
