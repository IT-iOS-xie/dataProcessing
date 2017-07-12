//
//  SYYJSonMusicInfo.m
//  SYY
//
//  Created by kuoxin on 7/5/16.
//  Copyright © 2016 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonMusicInfo.h"
#import "SYYMusicModel.h"
#import <objc/runtime.h>
@implementation SYYJSonMusicInfo

+ (instancetype)modelWithModel:(id )oldModel{
    SYYJSonMusicInfo * newMusicModel = [[self alloc]init];
    NSArray * arr = [oldModel getMusicProperties];
    
    [arr  enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [newMusicModel setValue:[oldModel valueForKey:obj] forKey:obj];
        
    }];
    return newMusicModel;
    
}


- (NSArray *)getMusicProperties
{
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
}
+ (instancetype)modelWithmusic_comment_count:(NSInteger)music_comment_count music_composer_id:(NSInteger)music_composer_id music_composer_name:(NSString *)music_composer_name music_creative_time:(NSInteger)music_creative_time music_description:(NSString *)music_description music_duration:(NSInteger)music_duration music_emotion:(NSArray * )music_emotion music_favorite:(BOOL)music_favorite music_id:(NSInteger)music_id music_img:(NSString *)music_img music_like_count:(NSInteger)music_like_count music_lrc_url:(NSString *)music_lrc_url music_name:(NSString *)music_name music_play_count:(NSInteger)music_play_count music_share_count:(NSInteger)music_share_count music_singer_id:(NSInteger)music_singer_id music_singer_name:(NSString *)music_singer_name music_songwrite_id:(NSInteger)music_songwrite_id music_songwriter_name:(NSString *)music_songwriter_name music_style:(NSString *)music_style music_thumbnail_img:(NSString *)music_thumbnail_img music_url:(NSString *)music_url musician_id:(NSInteger)musician_id musician_name:(NSString *)musician_name music_favorite_count:(NSInteger )music_favorite_count music_modified_time:(NSInteger )music_modified_time is_like:(BOOL)is_like{
    SYYJSonMusicInfo * musicModel = [[self alloc]init];
    
    musicModel.music_comment_count = music_comment_count;
    musicModel.music_composer_id = music_composer_id;
    musicModel.music_composer_name = music_composer_name;
    musicModel.music_creative_time = music_creative_time;
    musicModel.music_description = music_description;
    musicModel.music_duration = music_duration;
    musicModel.music_emotion = music_emotion;
    musicModel.music_favorite = music_favorite;
    musicModel.music_id = music_id;
    musicModel.music_img = music_img;
    musicModel.music_like_count = music_like_count;
    musicModel.music_lrc_url = music_lrc_url;
    musicModel.music_name = music_name;
    musicModel.music_play_count = music_play_count;
    musicModel.music_share_count = music_share_count;
    musicModel.music_singer_id = music_singer_id;
    musicModel.music_singer_name = music_singer_name;
    musicModel.music_songwrite_id = music_songwrite_id;
    musicModel.music_songwriter_name = music_songwriter_name;
    musicModel.music_style = music_style;
    musicModel.music_thumbnail_img = music_thumbnail_img;
     musicModel.music_thumbnail_img = music_thumbnail_img;
     musicModel.music_url = music_url;
     musicModel.musician_id = musician_id;
     musicModel.musician_name = musician_name;
    musicModel.music_favorite_count = music_favorite_count;
    musicModel.music_modified_time = music_modified_time;
    musicModel.is_like = is_like;
    return musicModel;
   


}

@end
