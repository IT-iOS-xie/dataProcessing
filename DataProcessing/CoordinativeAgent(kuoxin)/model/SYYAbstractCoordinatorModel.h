//
//  SYYAbstraceCoordinatorModel.h
//  SYY
//
//  Created by kuoxin on 7/12/16.
//  Copyright © 2016 cn.com.rockmobile. All rights reserved.
//

#ifndef SYYAbstractCoordinatorModel_h
#define SYYAbstractCoordinatorModel_h

@class SYYJSonMusicInfo;
@class SYYJSonMusicianInfo;

/**
 define a protocol for coordinator's model
 */
@protocol SYYAbstractCoordinatorModel

@property(nonatomic, retain)NSMutableArray* defaultMusicList_; //当前正在使用的音乐列表
@property(nonatomic, retain)SYYJSonMusicInfo* defaultMusicInfo_; //当前播放音乐

@property(nonatomic, retain)NSMutableArray* recommendedMusicList_; //推荐音乐列表
@property(nonatomic, retain)NSMutableArray* historyMusicList_; //播放历史音乐列表
@property(nonatomic, retain)NSMutableArray* favoriteMusicList_; //收藏音乐列表

@property(nonatomic, retain)SYYJSonMusicianInfo* defaultMusicianInfo_; //当前用户信息

@end


#endif /* SYYAbstractCoordinatorModel_h */
