//
//  SYYJSonRecommendedInfoResponse.h
//  SYY
//
//  Created by kuoxin on 7/7/16.
//  Copyright © 2016 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonResponse.h"
/// 首页接口数据转接类
@interface SYYJSonRecommendedInfoResponse : SYYJSonResponse
@property(nonatomic, copy) NSArray* adv; //SYYJSonAdvertisementInfo
@property(nonatomic, copy) NSArray* musicians; //SYYHomeMusicianModel
@property(nonatomic, copy) NSArray* song_list; //SYYHomeSongListModel

@property(nonatomic, copy) NSArray* newest_songs; //SYYHomeNew_HotSongModel
@property(nonatomic, copy) NSArray* hottest_songs; //SYYHomeNew_HotSongModel
@end
