//
//  SYYCoordinatorModel.m
//  SYY
//
//  Created by kuoxin on 7/13/16.
//  Copyright © 2016 cn.com.rockmobile. All rights reserved.
//

#import "SYYCoordinatorModel.h"
#import "SYYJSonMusicianInfo.h"

@implementation SYYCoordinatorModel

@synthesize defaultMusicList_; //当前正在使用的音乐列表
@synthesize defaultMusicInfo_; //当前播放音乐

@synthesize recommendedMusicList_; //推荐音乐列表
@synthesize historyMusicList_; //播放历史音乐列表
@synthesize favoriteMusicList_; //收藏音乐列表

@synthesize defaultMusicianInfo_;

- (instancetype) init
{
    if (self=[super  init]) {
        
        self.favoriteMusicList_ = [[NSMutableArray alloc]init];
        self.historyMusicList_ = [[NSMutableArray alloc]init];
        self.recommendedMusicList_ = [[NSMutableArray alloc]init];
        self.defaultMusicList_ = self.recommendedMusicList_;
        self.defaultMusicianInfo_ = [[SYYJSonMusicianInfo alloc]init];
    }
    return self;
}

@end
