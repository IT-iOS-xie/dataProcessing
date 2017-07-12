//
//  SYYJSonSearchMusicOrMusicianResponse.h
//  SYY
//
//  Created by kuoxin on 7/24/16.
//  Copyright © 2016 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonResponse.h"
/// 搜索音乐/音乐人转接类
@interface SYYJSonSearchMusicOrMusicianResponse : SYYJSonResponse
/// issue 包含的首层键值
@property(nonatomic, copy) NSMutableArray* index_search;
@end
