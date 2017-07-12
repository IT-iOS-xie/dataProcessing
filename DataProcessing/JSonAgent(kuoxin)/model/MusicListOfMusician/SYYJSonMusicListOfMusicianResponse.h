//
//  SYYJSonMusicsInfoResponse.h
//  SYY
//
//  Created by kuoxin on 7/7/16.
//  Copyright © 2016 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonResponse.h"
 /// 得到指定音乐人上传审核过的音乐列表接口转接类
@interface SYYJSonMusicListOfMusicianResponse : SYYJSonResponse
@property(nonatomic, copy) NSArray *music_list; //SYYJSonMusicInfo
@end

