 
//  SYYModelCoordinator.m
//  SYY
//
//  Created by kuoxin on 7/8/16.
//  Copyright © 2016 cn.com.rockmobile. All rights reserved.
//

#import "SYYModelCoordinator.h"
//#import "AFNetworking.h"

#import "SYYJSonRecommendedInfoResponse.h"
#import "SYYJSonAdvertisementInfo.h"
#import "SYYJSonMusicInfo.h"
#import "SYYJSonToObjectBuilder.h"
#import "SYYCoordinatorModel.h"
#import "AppDelegate.h"
#import "SYYJSonMusicianInfo.h"
//#import "SYYHomeViewController.h"
//#import "SYYPushModel.h"
#import <objc/message.h>

#define AFWEBAPI_REQUEST_TIMEOUT 20

@implementation SYYModelCoordinator



-(instancetype) init
{
    if (self = [super init]) {
        model_ = [[SYYCoordinatorModel alloc]init];
        
        
    }
    
    return self;
}

- (id) getDefaultMusicListWithType:(int)type
{
  
    if (type == 0) {
         return model_.defaultMusicList_;
    } else if (type == 1){
    
        return   model_.recommendedMusicList_;
    }else if (type == 2){
        
        return   model_.historyMusicList_;
    }else if (type == 3){
        
        return   model_.favoriteMusicList_;
    }
    return nil;
}

+(SYYModelCoordinator *)sharedManager
{
    static SYYModelCoordinator *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[self alloc]init];

    });
    
    return manager;
}


-(void) getMomentDetailInfo:(int) momentId andUserId:(int)userId
         getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
      getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking
{
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (kAppDelegate.SYYNETSTATUS != 0 && mgr.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEGMTIF];
    
        NSDictionary * paramaters = @{@"mid":[NSString stringWithFormat:@"%zd",momentId],@"uid":[NSString stringWithFormat:@"%zd",userId]};
        
        [manager GET:url parameters:paramaters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           
            [self judgeCacheLimit];
            [SYYFileCache writeDetail:responseObject key:CIRCLEDETAILCACHE name:[NSString stringWithFormat:@"%d",momentId]];
         
          
       
            [SYYFileCache totalMomentCache];
            id<SYYJSonAbstractBuilderInterface> builder = nil;
            CREATE_JSON_TO_OBJECT_BUILDER(builder);
            SET_BUILDER_CONTAINER(builder, @"SYYJSonMomentsResponse");
            SET_BUILDER_RESOURCE(builder, responseObject);
            ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonResourceInfo", @"resource_info")
            id object = GET_RESULT(builder);
            
            dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }
         ];
    }else {
      NSDictionary *dataDic = [SYYFileCache readDetailWith:CIRCLEDETAILCACHE name:[NSString stringWithFormat:@"%d",momentId]];
         if (dataDic) {//repDict有值说明读取本地成功；
            id<SYYJSonAbstractBuilderInterface> builder = nil;
            CREATE_JSON_TO_OBJECT_BUILDER(builder);
            SET_BUILDER_CONTAINER(builder, @"SYYJSonMomentsResponse");
            SET_BUILDER_RESOURCE(builder, dataDic);
            ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonResourceInfo", @"resource_info")
            id object = GET_RESULT(builder);
            dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
        }else {//没有值，直接返回失败；
            getFailureUseBlocking(nil);
        }
    }
}


-(void) getMomentsHeadList:(int) categoryId
                 timestamp:(NSInteger)timestamp
                  cacheKey:(NSString *)cacheKey
                   withUid:(int)userId
        getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
     getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking
{
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (kAppDelegate.SYYNETSTATUS != 0 && mgr.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable ){
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        
        NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEGTML];
        
        
         NSDictionary * paramaters = @{@"cid":[NSString stringWithFormat:@"%zd",categoryId],@"tm":[NSString stringWithFormat:@"%ld",(long)timestamp],@"uid":[NSString stringWithFormat:@"%zd",userId]};
        [manager GET:url_string parameters:paramaters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (timestamp == 0) {
                
                [SYYFileCache  deleteLocalCacheDataWithKey:cacheKey];
                
                [self judgeCacheLimit];
                [SYYFileCache  writeLocalCacheData:responseObject withKey:cacheKey andtimestamp:timestamp];
                [SYYFileCache totalMomentCache];
            }else {
                
                [self judgeCacheLimit];
                [SYYFileCache  writeLocalCacheData:responseObject withKey:cacheKey andtimestamp:timestamp];
                [SYYFileCache totalMomentCache];

            }
            
            id<SYYJSonAbstractBuilderInterface> builder = nil;
            CREATE_JSON_TO_OBJECT_BUILDER(builder);
            SET_BUILDER_CONTAINER(builder, @"SYYJSonMomentsHeadListResponse");
            SET_BUILDER_RESOURCE(builder, responseObject);
            ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonMomentHeadInfo", @"moment_heads")
            id object = GET_RESULT(builder); //SYYJSonMomentsHeadListResponse
            
            dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            getFailureUseBlocking(error);
        }
         ];
        
    }else {

        NSDictionary * dict;
        
        if (timestamp == 0) {
            
            dict = [SYYFileCache readLocalCacheDataWithKey:cacheKey andTimeScamp:timestamp];
        }  else {
            
            dict = [SYYFileCache readLocalCacheDataWithKey:cacheKey andTimeScamp:timestamp];
        }
        
        id<SYYJSonAbstractBuilderInterface> builder = nil;
        CREATE_JSON_TO_OBJECT_BUILDER(builder);
        SET_BUILDER_CONTAINER(builder, @"SYYJSonMomentsHeadListResponse");
        SET_BUILDER_RESOURCE(builder, dict);
        ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonMomentHeadInfo", @"moment_heads")
        id object = GET_RESULT(builder);
        
        //        SYYJSonRecommendedInfoResponse* tmp_obj = (SYYJSonRecommendedInfoResponse*)object;
        dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
    }
}



- (void) getRecommendedInfo:(SYY_RECOMMENDED_INFO_TYPE) type uid:(int)uid
                  timestamp:(NSInteger)timestamp
         getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
      getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking
{
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (kAppDelegate.SYYNETSTATUS != 0 && mgr.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable ){
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];

        NSString *url_string;
        //        if (app.isLogin) {
        url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEGRI];
        NSDictionary * paramaters = @{@"tp":[NSString stringWithFormat:@"%zd",type],@"tm":[NSString stringWithFormat:@"%ld",timestamp],@"uid":[NSString stringWithFormat:@"%zd",uid]};
     
         [manager GET:url_string parameters:paramaters  progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 // 保存字典
                 if (timestamp == 0) {
                     
                     [SYYFileCache  deleteLocalCacheDataWithKey:HOMEPAGECACHE];
                     
                     [self judgeCacheLimit];
                     [SYYFileCache  writeLocalCacheData:responseObject withKey:HOMEPAGECACHE andtimestamp:timestamp];
                 }  else {
                 
                     [self judgeCacheLimit];
                     [SYYFileCache  writeLocalCacheData:responseObject withKey:HOMEPAGECACHE andtimestamp:timestamp];
                 }
            
                 id<SYYJSonAbstractBuilderInterface> builder = nil;
                 CREATE_JSON_TO_OBJECT_BUILDER(builder);
                 SET_BUILDER_CONTAINER(builder, @"SYYJSonRecommendedInfoResponse");
                 SET_BUILDER_RESOURCE(builder, responseObject);
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonAdvertisementInfo", @"adv")
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYHomeMusicianModel", @"musicians")
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYHomeSongListModel", @"song_list")
                         ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYHomeNew_HotSongModel", @"newest_songs")
                         ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYHomeNew_HotSongModel", @"hottest_songs")
                 id object = GET_RESULT(builder);
                 
                 SYYJSonRecommendedInfoResponse* tmp_obj = (SYYJSonRecommendedInfoResponse*)object;
                 
                 if (tmp_obj != nil) {
                     
                     if (timestamp == 0) [self _clearRecommendedMusicList];
//                     [self _appendRecommendedMusicList: tmp_obj.musics];
                 }
                 
                 dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 getFailureUseBlocking(error);
             }
         ];
    } else {
        
        NSDictionary * dict;
        
        if (timestamp == 0) {
            
           dict = [SYYFileCache readLocalCacheDataWithKey:HOMEPAGECACHE andTimeScamp:timestamp];
        }  else {
        
            dict = [SYYFileCache readLocalCacheDataWithKey:HOMEPAGECACHE andTimeScamp:timestamp];
        }
     
        id<SYYJSonAbstractBuilderInterface> builder = nil;
        CREATE_JSON_TO_OBJECT_BUILDER(builder);
        SET_BUILDER_CONTAINER(builder, @"SYYJSonRecommendedInfoResponse");
        SET_BUILDER_RESOURCE(builder, dict);
        ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonAdvertisementInfo", @"adv")
        ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYHomeMusicianModel", @"musicians")
        ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYHomeSongListModel", @"song_list")
        ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYHomeNew_HotSongModel", @"newest_songs")
        ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYHomeNew_HotSongModel", @"hottest_songs")
        id object = GET_RESULT(builder);
        
        SYYJSonRecommendedInfoResponse* tmp_obj = (SYYJSonRecommendedInfoResponse*)object;
        
        dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(tmp_obj);});
        NSError *  error;
        getFailureUseBlocking(error);
    }
}



- (void) _appendRecommendedMusicList:(NSArray*)musicList
{
    [musicList enumerateObjectsUsingBlock:
        ^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [model_.recommendedMusicList_ addObject:obj];
        }
     ];
}

- (void) _clearRecommendedMusicList
{
    [model_.recommendedMusicList_ removeAllObjects];
}



-(void) getAttentionsInfo:(int) userId
                timestamp:(NSInteger)timestamp
       getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
    getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking
{
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusUnknown ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWWAN ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWiFi ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
      

         NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEGAL];
        NSDictionary * paramaters = @{@"uid":[NSString stringWithFormat:@"%zd",userId],@"tm":[NSString stringWithFormat:@"%ld",(long)timestamp],@"sz":@"15"};

        [manager GET:url_string parameters:paramaters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 
                 id<SYYJSonAbstractBuilderInterface> builder = nil;
                 CREATE_JSON_TO_OBJECT_BUILDER(builder);
                 SET_BUILDER_CONTAINER(builder, @"SYYJSonAttentionInfoResponse");
                 SET_BUILDER_RESOURCE(builder, responseObject);
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonMusicianInfo", @"attention")
                 id object = GET_RESULT(builder);
                 
                 dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 getFailureUseBlocking(error);
             }
         ];
    }
}

-(void) getFansInfo:(int) userId
          timestamp:(NSInteger)timestamp
 getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking
{
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusUnknown ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWWAN ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWiFi ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        


                NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEGFL];

    NSDictionary * paramaters = @{@"uid":[NSString stringWithFormat:@"%zd",userId],@"tm":[NSString stringWithFormat:@"%ld",(long)timestamp]};
        
        [manager GET:url_string parameters:paramaters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 id<SYYJSonAbstractBuilderInterface> builder = nil;
                 CREATE_JSON_TO_OBJECT_BUILDER(builder);
                 SET_BUILDER_CONTAINER(builder, @"SYYJSonFansInfoResponse");
                 SET_BUILDER_RESOURCE(builder, responseObject);
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonMusicianInfo", @"fans")
                 id object = GET_RESULT(builder);
                 
                 dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 getFailureUseBlocking(error);
             }
         ];
    }
}

-(void) getMusicListOfMusician:(int) userId
                     timestamp:(NSInteger)timestamp
            getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
         getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking
{
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusUnknown ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWWAN ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWiFi ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];


        NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEGMCL];

  NSDictionary * paramaters = @{@"uid":[NSString stringWithFormat:@"%zd",userId],@"tm":[NSString stringWithFormat:@"%ld",(long)timestamp]};
//        url_string =[url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [manager GET:url_string parameters:paramaters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }

             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 id<SYYJSonAbstractBuilderInterface> builder = nil;
                 CREATE_JSON_TO_OBJECT_BUILDER(builder);
                 SET_BUILDER_CONTAINER(builder, @"SYYJSonMusicListOfMusicianResponse");
                 SET_BUILDER_RESOURCE(builder, responseObject);
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonMusicInfo", @"music_list")
                 id object = GET_RESULT(builder);
                 
                 dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 getFailureUseBlocking(error);
             }
         ];
    }
}

- (void) getUploadResourceToken:(int) type
                            key:(NSString*) key
             getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
          getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking
{
    
    int userId = 10019;
    
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusUnknown ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWWAN ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWiFi ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        
 

          NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL, INTERFACECSA];

        
        NSDictionary * paramaters = @{@"uid":[NSString stringWithFormat:@"%zd",userId],@"tp":[NSString stringWithFormat:@"%d",type],@"key":key};
//        url_string =[url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [manager GET:url_string parameters:paramaters  progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 id<SYYJSonAbstractBuilderInterface> builder = nil;
                 CREATE_JSON_TO_OBJECT_BUILDER(builder);
                 SET_BUILDER_CONTAINER(builder, @"SYYJSONUploadResourceTokenResponse");
                 SET_BUILDER_RESOURCE(builder, responseObject);
                 id object = GET_RESULT(builder);
                 
                 dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 getFailureUseBlocking(error);
             }
         ];
    }
}

- (void) getMomentCommentList:(int) momentId withUserId:(int)userId
                    timestamp:(NSInteger)timestamp
                     cacheKey:(NSString *)cacheKey
           getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
        getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking
{
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (kAppDelegate.SYYNETSTATUS != 0 && mgr.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        
        NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEGCMTL];
         NSDictionary * paramaters = @{@"uid":[NSString stringWithFormat:@"%zd",userId],@"mid":[NSString stringWithFormat:@"%d",momentId],@"tm":[NSString stringWithFormat:@"%zd",timestamp]};
        //          url_string =[url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [manager GET:url_string parameters:paramaters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
           
            if (timestamp == 0) {
                
                [SYYFileCache  deleteLocalCacheDataWithKey:cacheKey andMomentID:momentId];
                
                [self judgeCacheLimit];
                [SYYFileCache writeLocalCacheData:responseObject withKey:cacheKey andtimestamp:timestamp andMomentID:momentId];
                
               
                  [SYYFileCache totalMomentCache];
                
               
            }else {
                
                [self judgeCacheLimit];
                [SYYFileCache writeLocalCacheData:responseObject withKey:cacheKey andtimestamp:timestamp andMomentID:momentId];
                //?
                  [SYYFileCache totalMomentCache];
            };
            
            id<SYYJSonAbstractBuilderInterface> builder = nil;
            CREATE_JSON_TO_OBJECT_BUILDER(builder);
            SET_BUILDER_CONTAINER(builder, @"SYYJSonMomentCommentsResponse");
            SET_BUILDER_RESOURCE(builder, responseObject);
            ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonCommentInfo", @"moments_comment")
            ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonResourceInfo", @"resource_info")
            id object = GET_RESULT(builder);
            
            dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            getFailureUseBlocking(error);
            
        }];
    }else {
        
        NSDictionary * dict;
        
        if (timestamp == 0) {
            
            dict = [SYYFileCache readLocalCacheDataWithKey:cacheKey andTimeStamp:timestamp andMomentID:momentId];
        }  else {
            
            dict = [SYYFileCache readLocalCacheDataWithKey:cacheKey andTimeStamp:timestamp andMomentID:momentId];
        }
        id<SYYJSonAbstractBuilderInterface> builder = nil;
        CREATE_JSON_TO_OBJECT_BUILDER(builder);
        SET_BUILDER_CONTAINER(builder, @"SYYJSonMomentCommentsResponse");
        SET_BUILDER_RESOURCE(builder, dict);
        ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonCommentInfo", @"moments_comment")
        ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonResourceInfo", @"resource_info")
        id object = GET_RESULT(builder);
        dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
    }
}


- (void) getMusicCommentList:(int) musicId ForUid:(int)uid
                   timestamp:(NSInteger)timestamp
          getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
       getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking
{

    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
 
    
    if (kAppDelegate.SYYNETSTATUS != 0 && mgr.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];

                NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEGCMCL];

          NSDictionary * paramaters = @{@"mcid":[NSString stringWithFormat:@"%zd",musicId],@"uid":[NSString stringWithFormat:@"%d",uid],@"tm":[NSString stringWithFormat:@"%zd",timestamp],@"sz":@"5"};
//          url_string =[url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString * informationStr =[NSString stringWithFormat:@"%zd%zd%@",uid,musicId,INTERFACEGCMCL];
        [manager GET:url_string parameters:paramaters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               
//                  [SYYFileCache writeLocalCacheData:responseObject withKey:cacheKey andtimestamp:timestamp andMomentID:momentId];
                 
                 [SYYFileCache  writeLocalCacheData:responseObject withKey:informationStr andtimestamp:timestamp];
                 id<SYYJSonAbstractBuilderInterface> builder = nil;
                 CREATE_JSON_TO_OBJECT_BUILDER(builder);
                 SET_BUILDER_CONTAINER(builder, @"SYYJSonMusicCommentsInfoResponse");
                 SET_BUILDER_RESOURCE(builder, responseObject);
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonCommentInfo", @"music_comment")
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonResourceInfo", @"resource_info")
                 id object = GET_RESULT(builder);
                 
                 dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 getFailureUseBlocking(error);
             }
         ];
    } else {
        
        NSDictionary * dict;
         NSString * informationStr =[NSString stringWithFormat:@"%zd%zd%@",uid,musicId,INTERFACEGCMCL];
   
            
            dict = [SYYFileCache readLocalCacheDataWithKey:informationStr andTimeScamp:timestamp];
     
    
        id<SYYJSonAbstractBuilderInterface> builder = nil;
        CREATE_JSON_TO_OBJECT_BUILDER(builder);
        SET_BUILDER_CONTAINER(builder, @"SYYJSonMusicCommentsInfoResponse");
        SET_BUILDER_RESOURCE(builder, dict);
        ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonCommentInfo", @"music_comment")
        ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonResourceInfo", @"resource_info")
        id object = GET_RESULT(builder);
        
        dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
    }
    
}


- (void) _uploadUserDefInfo:(int) userId
                 jsonString:(NSString*) jsonString
                        url:(NSString*) url
         getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
      getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking
{
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusUnknown ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWWAN ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWiFi ) {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

        manager.requestSerializer = [AFJSONRequestSerializer serializer];
         manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager.responseSerializer willChangeValueForKey:@"timeoutInterval"];
         manager.requestSerializer.timeoutInterval = 15;
        [manager.responseSerializer didChangeValueForKey:@"timeoutInterval"];
        
    
      
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        id parameters = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];    

        [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary * responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSUTF8StringEncoding error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(responseDic);});
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{    getFailureUseBlocking(error);
                
                                      NSLog(@"%@   %ld",error,(long)error.code);
                                      if(error.code == -1001){
                //                          NSLog(@"超时异常");
                                      }
                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"网络超时,请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                      [alert show];
                               });
        }];
    }
}

- (void) uploadMomentInfo:(NSString*) jsonString
       getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
    getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking
{

    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
  
    NSString * URL = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEUMI];
    [self _uploadUserDefInfo:(int)app.userModel.musician_id
                  jsonString:jsonString
                         url:URL

          getInfoUseBlocking:getInfoUseBlocking
       getFailureUseBlocking:getFailureUseBlocking];
}

- (void) uploadInfo:(NSString*) jsonString
        getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
     getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking
{
    
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
   
    NSString * URL = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEUCI];
    [self _uploadUserDefInfo:(int)app.userModel.musician_id
                  jsonString:jsonString

        url:URL

          getInfoUseBlocking:getInfoUseBlocking
       getFailureUseBlocking:getFailureUseBlocking];
}


#pragma mark  -----添加音乐评论
-(void)uploadMusicCommentInfo:(NSString*) jsonString
      getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
   getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking
{
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSString * URL =[NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEUCMI];
    [self _uploadUserDefInfo:(int)app.userModel.musician_id
                  jsonString:jsonString

      url:URL
          getInfoUseBlocking:getInfoUseBlocking
       getFailureUseBlocking:getFailureUseBlocking];
}


- (void) uploadCommentInfo:(NSString*) jsonString
        getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
     getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking
{
    //    int userId = 10019;
    
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSString * URL = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEUCI];
    [self _uploadUserDefInfo:(int)app.userModel.musician_id
                  jsonString:jsonString
     
                         url:URL
     
          getInfoUseBlocking:getInfoUseBlocking
       getFailureUseBlocking:getFailureUseBlocking];
}

- (void) getHotSearchList:(void (^)(id response))getInfoUseBlocking withUid:(int)uid   cacheKey:(NSString *)cacheKey  getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking
{

    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (kAppDelegate.SYYNETSTATUS != 0 && mgr.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
 
        NSString *url_string = [NSString stringWithFormat: @"%@%@uid=%d",INTERFACEKURL,INTERFACEHS, uid];

//          url_string =[url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [manager GET:url_string parameters:0 progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 // 保存JSON
                 
                 [SYYFileCache  deleteLocalCacheDataWithKey:POPULARMUSICIAN];
                 
                 [self judgeCacheLimit];
                 [SYYFileCache  writeLocalCacheData:responseObject withKey:POPULARMUSICIAN andtimestamp:0];
                 id<SYYJSonAbstractBuilderInterface> builder = nil;
                 CREATE_JSON_TO_OBJECT_BUILDER(builder);
                 SET_BUILDER_CONTAINER(builder, @"SYYJSonHotSearchListResponse");
                 SET_BUILDER_RESOURCE(builder, responseObject);
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonMusicianInfo", @"hot_musicians");
                 id object = GET_RESULT(builder);
                 
                 dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 getFailureUseBlocking(error);
             }
         ];
    }else {
        NSDictionary  * dict = [SYYFileCache readLocalCacheDataWithKey:POPULARMUSICIAN andTimeScamp:0];
        //    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        id<SYYJSonAbstractBuilderInterface> builder = nil;
        CREATE_JSON_TO_OBJECT_BUILDER(builder);
        SET_BUILDER_CONTAINER(builder, @"SYYJSonHotSearchListResponse");
        SET_BUILDER_RESOURCE(builder, dict);
        ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonMusicianInfo", @"hot_musicians");
        id object = GET_RESULT(builder);
        
        dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
    }
    NSError *  error;
    getFailureUseBlocking(error);

}



- (void) getSearchMusicOrMusicianList:(NSString*) condition WithUid:(NSInteger)userId
                            timestamp:(int)timestamp
                   getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
                getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking
{
//    int userId = 10019;
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusUnknown ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWWAN ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWiFi ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        


        NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACESEARCHIS];

        NSDictionary * paramater = @{@"search":condition,@"tp":[NSString stringWithFormat:@"%zd",timestamp]};
        url_string = [url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [manager GET:url_string parameters:paramater progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 id<SYYJSonAbstractBuilderInterface> builder = nil;
                 CREATE_JSON_TO_OBJECT_BUILDER(builder);
                 SET_BUILDER_CONTAINER(builder, @"SYYJSonSearchMusicOrMusicianResponse");
                 SET_BUILDER_RESOURCE(builder, responseObject);
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonSearchMusicOrMusicianInfo", @"index_search");
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonMusicianInfo", @"musicians");
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYMusicModel", @"music");
                 id object = GET_RESULT(builder);
                 
                 dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"%@  %zd",error,error.code);
                 getFailureUseBlocking(error);
             }
         ];
    }
   
}

#pragma mark -------获取用户发布音乐列表


- (void) getPublishMusicList:(int) userId   timestamp:(NSInteger)timestamp
          getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
       getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking
{
    
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (kAppDelegate.SYYNETSTATUS != 0 && mgr.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        
   
        NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEMMI];
        NSDictionary * paramaters = @{@"uid":[NSString stringWithFormat:@"%d",userId],@"tm":[NSString stringWithFormat:@"%ld",(long)timestamp] } ;
        [manager GET:url_string parameters:paramaters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                 保存字典
                 if (timestamp == 0) {
                     
                    [self judgeCacheLimit];
                     [SYYFileCache  writeLocalCacheData:responseObject withKey:USERPUBLISHMUSICPAGECACHE andtimestamp:timestamp];
                 }
                 
                 id<SYYJSonAbstractBuilderInterface> builder = nil;
                 CREATE_JSON_TO_OBJECT_BUILDER(builder);
                 SET_BUILDER_CONTAINER(builder, @"SYYJSonPublishMusicOfMusicianResponse");
                 SET_BUILDER_RESOURCE(builder, responseObject);
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonMusicInfo", @"issue_musics")
                 id object = GET_RESULT(builder);
                 
                 dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 getFailureUseBlocking(error);
             }
         ];
    } else {
     
        NSDictionary  * dict = [SYYFileCache readLocalCacheDataWithKey:USERPUBLISHMUSICPAGECACHE andTimeScamp:timestamp];
        //    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        id<SYYJSonAbstractBuilderInterface> builder = nil;
        CREATE_JSON_TO_OBJECT_BUILDER(builder);
        SET_BUILDER_CONTAINER(builder, @"SYYJSonPublishMusicOfMusicianResponse");
        SET_BUILDER_RESOURCE(builder, dict);
        ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonMusicInfo", @"issue_musics")
        id object = GET_RESULT(builder);
        
        dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
    
        NSError *  error;
        getFailureUseBlocking(error);
    
    }
}


- (void) getPublishMusicList:(int) userId  mcid:(int)musicId  getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
       getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking;{
    
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusUnknown ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWWAN ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWiFi ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        
     
        
        NSString *url_string = [NSString stringWithFormat:@"%@%@mcid=%d",INTERFACEKURL,DELETERELEASEMUSIC,musicId];
        
        
        //          url_string =[url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [manager GET:url_string parameters:0 progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         
   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 
             }
         ];
    }
    
    
    
}

- (void) getFavouriteMusicList:(int) userId  timestamp:(NSInteger)timestamp getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
         getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking
{
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (kAppDelegate.SYYNETSTATUS != 0 && mgr.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        

                NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEFM];

        NSDictionary * paramater = @{ @"uid":[NSString stringWithFormat:@"%d",userId],@"tm":[NSString stringWithFormat:@"%ld",(long)timestamp],@"sz":@"15"};
        [manager GET:url_string parameters:paramater  progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 //  保存字典
                 if (timestamp == 0) {
                     
                     [self judgeCacheLimit];
                     [SYYFileCache  writeLocalCacheData:responseObject withKey:USERCOLLECTIONPAGECACHE andtimestamp:timestamp];
                 }
                 id<SYYJSonAbstractBuilderInterface> builder = nil;
                 CREATE_JSON_TO_OBJECT_BUILDER(builder);
                 SET_BUILDER_CONTAINER(builder, @"SYYJSonFavouriteMusicOfMusicianResponse");
                 SET_BUILDER_RESOURCE(builder, responseObject);
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonMusicInfo", @"favorite_list")
                 id object = GET_RESULT(builder);
                 
                 dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 getFailureUseBlocking(error);
             }
         ];
    } else {
    
        NSDictionary  * dict = [SYYFileCache readLocalCacheDataWithKey:USERCOLLECTIONPAGECACHE andTimeScamp:timestamp];
        //    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        id<SYYJSonAbstractBuilderInterface> builder = nil;
        CREATE_JSON_TO_OBJECT_BUILDER(builder);
        SET_BUILDER_CONTAINER(builder, @"SYYJSonFavouriteMusicOfMusicianResponse");
        SET_BUILDER_RESOURCE(builder, dict);
        ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonMusicInfo", @"favorite_list")
        id object = GET_RESULT(builder);
        
        dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});

        NSError *  error;
        getFailureUseBlocking(error);
    }
}


//-(void)getAttentions:(int)userId to:(int)aid  withType:(int)type
// getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
//getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking
//{
//
//    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
//
//    if (mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusUnknown ||
//        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWWAN ||
//        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWiFi ) {
//
//        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
//        manager.requestSerializer=[AFJSONRequestSerializer serializer];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
//
//        NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEFS];
//
//
//        NSDictionary * paramaters = @{@"uid":[NSString stringWithFormat:@"%d",userId],@"aid":[NSString stringWithFormat:@"%d",aid],@"tp":[NSString stringWithFormat:@"%d",type]};
//        [manager GET:url_string parameters:paramaters progress:^(NSProgress * _Nonnull downloadProgress) {
//            
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSLog(@"success//////");
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"网络超时,请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//                    }];
//    }
//}
//
- (void) getAttentionInfo:(NSString*) jsonString        getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
    getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{

    NSString * URL = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEFS];
    [self _uploadUserDefInfo:0
                  jsonString:jsonString
                         url:URL
          getInfoUseBlocking:getInfoUseBlocking
       getFailureUseBlocking:getFailureUseBlocking];

}
-(void)getLikeMusic:(int)mcid ForUid:(int)uid withType:(int)type
 getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{

    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusUnknown ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWWAN ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWiFi ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        

                NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEMLK];
  NSDictionary * paramater = @{ @"mcid":[NSString stringWithFormat:@"%d",mcid],@"tp":[NSString stringWithFormat:@"%d",type],@"uid":[NSString stringWithFormat:@"%d",uid]  };
        
        [manager GET:url_string parameters:paramater progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 
             }
         ];

    }
}

-(void)getLikeMusicComment:(int)cmid ForMcid:(int)mcid withUid:(int)uid Type:(int)type
        getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
     getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking
{

    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusUnknown ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWWAN ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWiFi ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        

                NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEMCLK];

          NSDictionary * paramater = @{ @"mcid":[NSString stringWithFormat:@"%d",mcid],@"cmid":[NSString stringWithFormat:@"%d",cmid],@"tp":[NSString stringWithFormat:@"%d",type],@"uid":[NSString stringWithFormat:@"%d",uid]  };
        [manager GET:url_string parameters:paramater progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 
             }
         ];
    }


}

-(void)getLikePostComment:(int)cmid  withType:(int)type withUserId:(int)userId withMomentId:(int)momentId
       getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
    getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking
{

    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusUnknown ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWWAN ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWiFi ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];


        NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACECLK];
        NSDictionary * paramater = @{ @"cmid":[NSString stringWithFormat:@"%d",cmid],@"tp":[NSString stringWithFormat:@"%d",type],@"uid":[NSString stringWithFormat:@"%d",userId],@"mid":[NSString stringWithFormat:@"%d",momentId]  };
        [manager GET:url_string parameters:paramater progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}


- (void) uploadMusicianInfo:(NSString*) jsonString to:(int)userId
       getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
    getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking
{
    
    
    NSString * URL = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEUOI];
    [self _uploadUserDefInfo:userId
                  jsonString:jsonString
                         url:URL
          getInfoUseBlocking:getInfoUseBlocking
       getFailureUseBlocking:getFailureUseBlocking];
}


-(void)getHotORSuggestMusicianList:(NSInteger)timestamp  withUserId:(int)userId   cacheKey:(NSString *)cacheKey getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
             getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (kAppDelegate.SYYNETSTATUS != 0 && mgr.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        
        NSString* url = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACESRM];
        NSDictionary * parameters = @{@"tm":[NSString stringWithFormat:@"%zd",timestamp],@"uid":[NSString stringWithFormat:@"%d",userId]};
        
        [manager GET:url parameters:parameters    progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            
//            [SYYFileCache  writeLocalCacheData:responseObject withKey:RECOMMENDEDMUSICIANS andtimestamp:timestamp];
            if (timestamp == 0) {
                
                [SYYFileCache  deleteLocalCacheDataWithKey:RECOMMENDEDMUSICIANS];
                
                [self judgeCacheLimit];
                [SYYFileCache  writeLocalCacheData:responseObject withKey:RECOMMENDEDMUSICIANS andtimestamp:timestamp];
//            }  else {
//                
//                [SYYFileCache  writeLocalCacheData:responseObject withKey:RECOMMENDEDMUSICIANS andtimestamp:timestamp];
            }
            
            id<SYYJSonAbstractBuilderInterface> builder = nil;
            CREATE_JSON_TO_OBJECT_BUILDER(builder);
            SET_BUILDER_CONTAINER(builder, @"SYYJsonHotORSuggestMusicianResponse");
            SET_BUILDER_RESOURCE(builder, responseObject);
            ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonMusicianInfo", @"musicians");
            id object = GET_RESULT(builder);
            
            dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
            
           
        }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 getFailureUseBlocking(error);
             }
         ];
    } else {
        
//        NSDictionary  * dict = [SYYFileCache readLocalCacheDataWithKey:RECOMMENDEDMUSICIANS];
        NSDictionary * dict;
        
//        if (timestamp == 0) {
//            
//            dict = [SYYFileCache readLocalCacheDataWithKey:RECOMMENDEDMUSICIANS andTimeScamp:timestamp];
//        }  else {
        
            dict = [SYYFileCache readLocalCacheDataWithKey:RECOMMENDEDMUSICIANS andTimeScamp:timestamp];
//        }
        //    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        id<SYYJSonAbstractBuilderInterface> builder = nil;
        CREATE_JSON_TO_OBJECT_BUILDER(builder);
        SET_BUILDER_CONTAINER(builder, @"SYYJsonHotORSuggestMusicianResponse");
        SET_BUILDER_RESOURCE(builder, dict);
        ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonMusicianInfo", @"musicians");
        id object = GET_RESULT(builder);
        
        dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
        
        NSError *  error;
        getFailureUseBlocking(error);
    }

}



- (void) getMusicAttentionInfo:(NSString*) jsonString
            getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
         getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{

    
    NSString * URL  = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEGFM];
    [self _uploadUserDefInfo:0
                  jsonString:jsonString
     
                         url:URL
     
     
          getInfoUseBlocking:getInfoUseBlocking
       getFailureUseBlocking:getFailureUseBlocking];

}

- (void) uploadUserFeedbackInfo:(NSString*) jsonString
             getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
          getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{

    int userId = 10019;
    
    NSString * URL  = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEGFB];
    [self _uploadUserDefInfo:userId
                  jsonString:jsonString

                         url:URL


          getInfoUseBlocking:getInfoUseBlocking
       getFailureUseBlocking:getFailureUseBlocking];

}



- (void) uploadUserConsultInfo:(NSString*) jsonString 
            getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
         getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking

{

    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];

    if (mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusUnknown ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWWAN ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWiFi ||mgr.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {

        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        id parameters = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSString * URL= [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEGC];
        
        [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary * response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSUTF8StringEncoding error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(response);});
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{    getFailureUseBlocking(error);});
          
                              NSLog(@"%@",error);
        }];
    }
}
- (void) uploadUserRegisterInfo:(NSString*) jsonString
             getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
          getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
    
    NSString * URL= [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACERT];

 
    [self _uploadUserDefInfo:0
                  jsonString:jsonString

                         url:URL

          getInfoUseBlocking:getInfoUseBlocking
       getFailureUseBlocking:getFailureUseBlocking];
    
    
}


- (void) getUserLogininInfo:(NSString*) jsonString 
         getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
      getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
   
    
    NSString * URL= [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACELN];

    [self _uploadUserDefInfo:0
                  jsonString:jsonString

                         url:URL

          getInfoUseBlocking:getInfoUseBlocking
       getFailureUseBlocking:getFailureUseBlocking];
    


}
- (void) verifyUserPhoneNumberInfo:(NSString*) jsonString
                getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
             getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
 NSString * URL= [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEVPN];
    [self _uploadUserDefInfo:0
                  jsonString:jsonString

                         url:URL


          getInfoUseBlocking:getInfoUseBlocking
       getFailureUseBlocking:getFailureUseBlocking];
}

- (void) getUserThirdLogininInfo:(NSString*) jsonString
              getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
           getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{

    NSString * URL= [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEOLN];
    [self _uploadUserDefInfo:0
                  jsonString:jsonString
                        url:URL

          getInfoUseBlocking:getInfoUseBlocking
       getFailureUseBlocking:getFailureUseBlocking];
}


- (void) getUserInformationInfoWithUid:(NSInteger) userId
                    getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
                 getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
   
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (kAppDelegate.SYYNETSTATUS != 0 && mgr.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        
        

              NSString *url_string = [NSString stringWithFormat: @"%@%@",INTERFACEKURL,INTERFACEOI];
        
        NSDictionary * paramater = @{@"uid":[NSString stringWithFormat:@"%zd",userId]};
 
        [manager GET:url_string parameters:paramater  progress: nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 [self judgeCacheLimit];
                 [SYYFileCache  writeLocalCacheData:responseObject withKey:USERINFORMATIONPAGECACHE andtimestamp:0];
                 id<SYYJSonAbstractBuilderInterface> builder = nil;
                 CREATE_JSON_TO_OBJECT_BUILDER(builder);
                 SET_BUILDER_CONTAINER(builder, @"SYYJsonUerInformationResponse");
                 SET_BUILDER_RESOURCE(builder, responseObject);
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonMusicianInfo", @"ownerinfo");
                 id object = GET_RESULT(builder);
                 
                 dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 getFailureUseBlocking(error);
             }
         ];
    } else{
        
            NSDictionary  * dict = [SYYFileCache readLocalCacheDataWithKey:USERINFORMATIONPAGECACHE andTimeScamp:0];
        if (dict ) {
            //    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            id<SYYJSonAbstractBuilderInterface> builder = nil;
            CREATE_JSON_TO_OBJECT_BUILDER(builder);
            SET_BUILDER_CONTAINER(builder, @"SYYJsonUerInformationResponse");
            SET_BUILDER_RESOURCE(builder, dict);
            ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonMusicianInfo", @"ownerinfo");
            id object = GET_RESULT(builder);
            
            dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
        }
        
        
        NSError *  error;
        getFailureUseBlocking(error);
        }


   

}



- (void)getUserShareInformation:(int)momentId
             getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
          getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking
{
    
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusUnknown ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWWAN ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWiFi ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        
        NSString *url_string = [NSString stringWithFormat:@"%@%@mid=%d",INTERFACEKURL,INTERFACESMT,momentId];
        
        [manager GET:url_string parameters:0 progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSJSONSerialization * json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            
            id object = json;
            dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            getFailureUseBlocking(error);
            NSLog(@"%@",error);
        }
         ];
    }
}

- (void)getUserShareMusicInformation:(int)musicId
                  getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
               getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
    
    
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusUnknown ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWWAN ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWiFi ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        
        NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACESMC];
        NSDictionary * paramater = @{@"mcid":[NSString stringWithFormat:@"%zd",musicId]};
        [manager GET:url_string parameters:paramater progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSJSONSerialization * json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            
            id object = json;
            dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      
            getFailureUseBlocking(error);
            NSLog(@"%@",error);
        }
    ];
    }
}



- (void) uploadUserNewPasswordInfo:(NSString*) jsonString
                getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
             getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
     int userId = 10019;
    
      NSString * URL = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACECP];
    [self _uploadUserDefInfo:userId
                  jsonString:jsonString


                         url:URL


          getInfoUseBlocking:getInfoUseBlocking
       getFailureUseBlocking:getFailureUseBlocking];


}
- (void) getSMSMessageInfo:(NSString*) jsonString
        getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
     getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
    
    
    NSString * URL = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEGSR];

    [self _uploadUserDefInfo:0
                  jsonString:jsonString

                         url:URL

          getInfoUseBlocking:getInfoUseBlocking
       getFailureUseBlocking:getFailureUseBlocking];
    
    
}

- (void) getSMSMessageVerifyInfo:(NSString*) jsonString
              getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
           getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
    
     NSString * URL = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEVPC];
    [self _uploadUserDefInfo:0
                  jsonString:jsonString


                              url:URL

          getInfoUseBlocking:getInfoUseBlocking
       getFailureUseBlocking:getFailureUseBlocking];

}


- (void) getUserAccountBlindInfo:(NSString*) jsonString
              getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
           getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{

    
        NSString * URL = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEBUI];
    [self _uploadUserDefInfo:0
                  jsonString:jsonString


                              url:URL

          getInfoUseBlocking:getInfoUseBlocking
       getFailureUseBlocking:getFailureUseBlocking];
    


}

- (void) getUserTelephoneNumberBlindInfo:(NSString*) jsonString        getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
                   getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
    
    
    NSString * URL = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEBPAP];
    
    [self _uploadUserDefInfo:0
                  jsonString:jsonString


                              url:URL

          getInfoUseBlocking:getInfoUseBlocking
       getFailureUseBlocking:getFailureUseBlocking];
    
    
    
}

- (void)getPushMusicModel:(int)musicId
       getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
    getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
    
    
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusUnknown ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWWAN ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWiFi ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
                manager.requestSerializer=[AFJSONRequestSerializer serializer];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        

                NSString *url_string = [NSString stringWithFormat:@"%@%@mcid=%d",INTERFACEKURL,INTERFACEGMS,musicId];

        //          url_string =[url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [manager GET:url_string parameters:0 progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 id<SYYJSonAbstractBuilderInterface> builder = nil;
                 CREATE_JSON_TO_OBJECT_BUILDER(builder);
                 SET_BUILDER_CONTAINER(builder, @"SYYJPushMusicInfo");
                 SET_BUILDER_RESOURCE(builder, responseObject);
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYMusicModel", @"musics")
                 id object = GET_RESULT(builder);
                 
                 dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 
                 getFailureUseBlocking(error);
                 NSLog(@"%@",error);
             }
         ];
    }
    
}


- (void) getPlayingWithMusicId:(NSInteger)musicId
           getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
        getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking
{
    

    
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusUnknown ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWWAN ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWiFi ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        

        NSString *url_string = [NSString stringWithFormat:@"%@%@mcid=%zd",INTERFACEKURL,INTERFACEGPC, musicId];

        [manager GET:url_string parameters:0 progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
            
                 dispatch_async(dispatch_get_main_queue(), ^{
                     getInfoUseBlocking(responseObject);});
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 getFailureUseBlocking(error);
             }
         ];
    }
}



- (void) getVersionAndTokenWith:(NSString*) jsonString       getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
        getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
    
    
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusUnknown ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWWAN ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWiFi ) {
        
        //        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.responseSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 15;
        [manager.responseSerializer didChangeValueForKey:@"timeoutInterval"];
        
        
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        id parameters = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        
        NSString * urlString = [NSString stringWithFormat:@"%@/fxmusic/music/api/v2.0.0/uvi?",INTERFACEKURL];
        
        [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString * str = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];;
            
            NSDictionary  * tokenDic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            
            NSLog(@"============%@   %@ ", str , tokenDic);
            
            //                  [kUserDefaults setValue:[tokenDic valueForKey:@"token"]  forKey:KAccessToken];
            //
            //                  AppDelegate * app = kAppDelegate;
            //
            //                  app.accessToken =[tokenDic valueForKey:@"token"];
            //                  app.sessionId = [[tokenDic valueForKey:@"session_id"] integerValue];
            //                   NSLog(@"============%@   %@ ", str , tokenDic);
            dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(tokenDic);});
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{    getFailureUseBlocking(error);
                
                NSLog(@"%@",error);
            });
            NSLog(@"%@",error);
            
        }];
    }
}



- (void) uploadUserReportInfo:(NSString*) jsonString
           getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
        getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
    
    
//    NSString *URL = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEREP];
    NSString *URL = [NSString stringWithFormat:@"%@/fxmusic/music/api/v2.0.0/up",INTERFACEKURL];
    
    [self _uploadUserDefInfo:0 jsonString:jsonString url:URL getInfoUseBlocking:getInfoUseBlocking getFailureUseBlocking:getFailureUseBlocking];
 
}



- (void) uploadAuthMusicianInformation:(NSString*) jsonString
                    getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
                 getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{

    NSString *URL = [NSString stringWithFormat:@"%@/fxmusic/music/api/v2.0.0/em",INTERFACEKURL];
    

    
    [self _uploadUserDefInfo:0 jsonString:jsonString url:URL getInfoUseBlocking:getInfoUseBlocking getFailureUseBlocking:getFailureUseBlocking];
}

- (void) getMusicianMusicListWith:(int)userId  and:(int)aid  withTimestamp:(NSInteger)timestamp
               getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
            getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
    
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (kAppDelegate.SYYNETSTATUS != 0 && mgr.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        
    
        
        NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,GETMUSICIANMUSICLIST];
        
        NSDictionary * paramaters = @{@"uid":[NSString stringWithFormat:@"%zd",userId],@"aid":[NSString stringWithFormat:@"%zd",aid],@"tm":[NSString stringWithFormat:@"%ld",(long)timestamp],@"sz":@"10"};
        //        url_string =[url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString * informationStr =[NSString stringWithFormat:@"%zd%@",aid,MUSICIANINMUSICPAGECACHE];
        
        
        
        [manager GET:url_string parameters:paramaters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                [self judgeCacheLimit];
                [SYYFileCache  writeLocalCacheData:responseObject withKey:informationStr andtimestamp:timestamp];
                 id<SYYJSonAbstractBuilderInterface> builder = nil;
                 CREATE_JSON_TO_OBJECT_BUILDER(builder);
                 SET_BUILDER_CONTAINER(builder, @"SYYJSonMusicListOfMusicianResponse");
                 SET_BUILDER_RESOURCE(builder, responseObject);
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonMusicInfo", @"music_list")
                 id object = GET_RESULT(builder);
                 
                 dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 getFailureUseBlocking(error);
             }
         ];
    } else {
        NSString * informationStr =[NSString stringWithFormat:@"%zd%@",aid,MUSICIANINMUSICPAGECACHE];
        
        NSDictionary  * dict = [SYYFileCache readLocalCacheDataWithKey:informationStr andTimeScamp:timestamp];
        if (dict ) {
            id<SYYJSonAbstractBuilderInterface> builder = nil;
            CREATE_JSON_TO_OBJECT_BUILDER(builder);
            SET_BUILDER_CONTAINER(builder, @"SYYJSonMusicListOfMusicianResponse");
            SET_BUILDER_RESOURCE(builder, dict);
            ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonMusicInfo", @"music_list")
            id object = GET_RESULT(builder);
            
            dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
        }
        
        NSError *  error;
        getFailureUseBlocking(error);

    }
}

- (void) getMusicianInformationInfoWithUid:(NSInteger) userId and:(NSInteger)aid withTimestamp:(NSInteger)timestamp
                        getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
                     getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
    
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (kAppDelegate.SYYNETSTATUS != 0 && mgr.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        
        NSString *url_string = [NSString stringWithFormat: @"%@%@",INTERFACEKURL,MUSICIANINFORMATION];
        
        NSDictionary * paramater = @{@"uid":[NSString stringWithFormat:@"%zd",userId],@"aid":[NSString stringWithFormat:@"%zd",aid],@"tm":[NSString stringWithFormat:@"%zd",timestamp]};
        
       
        //          url_string =[url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString * informationStr =[NSString stringWithFormat:@"%zd%@",aid,MUSICIANINFORMATIONPAGECACHE];
        [manager GET:url_string parameters:paramater  progress: nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 [self judgeCacheLimit];
                 [SYYFileCache  writeLocalCacheData:responseObject withKey:informationStr andtimestamp:0];
                 id<SYYJSonAbstractBuilderInterface> builder = nil;
                 CREATE_JSON_TO_OBJECT_BUILDER(builder);
                 SET_BUILDER_CONTAINER(builder, @"SYYJsonUerInformationResponse");
                 SET_BUILDER_RESOURCE(builder, responseObject);
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonMusicianInfo", @"ownerinfo");
                
                 id object = GET_RESULT(builder);
                 
                 
           
                 dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 getFailureUseBlocking(error);
             }
         ];
    } else{
        NSString * informationStr =[NSString stringWithFormat:@"%zd%@",aid,MUSICIANINFORMATIONPAGECACHE];

        NSDictionary  * dict = [SYYFileCache readLocalCacheDataWithKey:informationStr andTimeScamp:0];
        if (dict ) {
            //    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            id<SYYJSonAbstractBuilderInterface> builder = nil;
            CREATE_JSON_TO_OBJECT_BUILDER(builder);
            SET_BUILDER_CONTAINER(builder, @"SYYJsonUerInformationResponse");
            SET_BUILDER_RESOURCE(builder, dict);
            ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonMusicianInfo", @"ownerinfo");
            id object = GET_RESULT(builder);
            
            dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
        }
        
        
        NSError *  error;
        getFailureUseBlocking(error);
    }
 
}


- (void) getMusicianMomentListWithUid:(NSInteger) userId withTimestamp:(NSInteger)timestamp
                   getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
                getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
    
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (kAppDelegate.SYYNETSTATUS != 0 && mgr.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        
       
        
        NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,MUSICIANMOMENTLIST];
        
        NSDictionary * paramaters = @{@"uid":[NSString stringWithFormat:@"%zd",userId],@"tm":[NSString stringWithFormat:@"%ld",(long)timestamp],@"sz":@"10"};
        //        url_string =[url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString * informationStr =[NSString stringWithFormat:@"%zd%@",userId,MUSICIANMOMENTPAGELIST];
        
        
        
        [manager GET:url_string parameters:paramaters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 [self judgeCacheLimit];
                 [SYYFileCache  writeLocalCacheData:responseObject withKey:informationStr andtimestamp:timestamp];
                 id<SYYJSonAbstractBuilderInterface> builder = nil;
                 CREATE_JSON_TO_OBJECT_BUILDER(builder);
                 SET_BUILDER_CONTAINER(builder, @"SYYJSonMomentListOfMusicianResponse");
                 SET_BUILDER_RESOURCE(builder, responseObject);
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonMomentInfo", @"my_moments_list")
                 id object = GET_RESULT(builder);
                 
                 dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 getFailureUseBlocking(error);
             }
         ];
    } else {
        NSString * informationStr =[NSString stringWithFormat:@"%zd%@",userId,MUSICIANMOMENTPAGELIST];
        
        NSDictionary  * dict = [SYYFileCache readLocalCacheDataWithKey:informationStr andTimeScamp:timestamp];
        if (dict ) {
            id<SYYJSonAbstractBuilderInterface> builder = nil;
            CREATE_JSON_TO_OBJECT_BUILDER(builder);
            SET_BUILDER_CONTAINER(builder, @"SYYJSonMomentListOfMusicianResponse");
            SET_BUILDER_RESOURCE(builder, dict);
            ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonMomentInfo", @"my_moments_list")
            id object = GET_RESULT(builder);
            
            dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
        }
        
        NSError *  error;
        getFailureUseBlocking(error);
        
    }
}
- (void) getMusicianMomentListWithUid:(NSInteger) userId  andaid:(NSInteger)aid withTimestamp:(NSInteger)timestamp
                   getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
                getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
    
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (kAppDelegate.SYYNETSTATUS != 0 && mgr.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        
        
        
        NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,GETOTHERMUSICIANMOMENT];
        
        NSDictionary * paramaters = @{@"uid":[NSString stringWithFormat:@"%zd",userId],@"aid":[NSString stringWithFormat:@"%zd",aid],@"tm":[NSString stringWithFormat:@"%ld",(long)timestamp],@"sz":@"10"};
        //        url_string =[url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString * informationStr =[NSString stringWithFormat:@"%zd%@",aid,MUSICIANMOMENTPAGELIST];
        
        
        
        [manager GET:url_string parameters:paramaters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 [self judgeCacheLimit];
                 [SYYFileCache  writeLocalCacheData:responseObject withKey:informationStr andtimestamp:0];
                 id<SYYJSonAbstractBuilderInterface> builder = nil;
                 CREATE_JSON_TO_OBJECT_BUILDER(builder);
                 SET_BUILDER_CONTAINER(builder, @"SYYJSONMomentListOfOtherMusicianReponse");
                 SET_BUILDER_RESOURCE(builder, responseObject);
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonMomentInfo", @"musician_index_moments_list")
                 id object = GET_RESULT(builder);
                 
                 dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 getFailureUseBlocking(error);
             }
         ];
    } else {
        NSString * informationStr =[NSString stringWithFormat:@"%zd%@",aid,MUSICIANMOMENTPAGELIST];
        
        NSDictionary  * dict = [SYYFileCache readLocalCacheDataWithKey:informationStr andTimeScamp:0];
        if (dict ) {
            id<SYYJSonAbstractBuilderInterface> builder = nil;
            CREATE_JSON_TO_OBJECT_BUILDER(builder);
            SET_BUILDER_CONTAINER(builder, @"SYYJSONMomentListOfOtherMusicianReponse");
            SET_BUILDER_RESOURCE(builder, dict);
            ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonMomentInfo", @"musician_index_moments_list")
            id object = GET_RESULT(builder);
            
            dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
        }
        
        NSError *  error;
        getFailureUseBlocking(error);
        
    }
}

- (void) getVersionInformation:(NSString*) jsonString
            getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
         getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
 
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusUnknown ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWWAN ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWiFi ) {

        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
       
//        [manager.responseSerializer willChangeValueForKey:@"timeoutInterval"];
//        manager.requestSerializer.timeoutInterval = 15;
//        [manager.responseSerializer didChangeValueForKey:@"timeoutInterval"];
       
        
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        id parameters = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
   
        NSString *urlString = [NSString stringWithFormat:@"%@/fxmusic/music/api/v2.0.0/vabri",INTERFACEKURL];
        [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
           NSDictionary * response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSUTF8StringEncoding error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(response);});
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{    getFailureUseBlocking(error);
                
                NSLog(@"%@",error);
            });
            NSLog(@"%@",error);
            
        }];
    }
}

- (void) getVerificationCode:(NSString*) jsonString
          getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
       getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
    
//    NSString * URL = @"http://www.fxyinyue.com/discoverMusic/user.do/sendVerificationCodeForApp";

//    NSString * URL = @"http://www.fxyinyue.com/discoverMusic/user.do/sendVerificationCodeForApp";

    NSString * URL = [NSString stringWithFormat:@"%@%@",CODEINTERFACEKURL,AGENTVERIFICATIONCODE];
    
    [self _uploadUserDefInfo:0
                  jsonString:jsonString
     
                         url:URL
     
          getInfoUseBlocking:getInfoUseBlocking
       getFailureUseBlocking:getFailureUseBlocking];

}


- (void) getCommentPushListWithUid:(NSInteger) userId withTimestamp:(NSInteger)timestamp
                getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
             getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
    
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (kAppDelegate.SYYNETSTATUS != 0 && mgr.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        
        
        
        NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,MUSICIANCOMMENTPUSHLIST];
        
        NSDictionary * paramaters = @{@"uid":[NSString stringWithFormat:@"%zd",userId],@"tm":[NSString stringWithFormat:@"%ld",(long)timestamp],@"sz":@"10"};
        //        url_string =[url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString * informationStr =[NSString stringWithFormat:@"%zd%@",userId,KMusicianCommentPushList];
        
        
        
        [manager GET:url_string parameters:paramaters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 [self judgeCacheLimit];
                 [SYYFileCache  writeLocalCacheData:responseObject withKey:informationStr andtimestamp:0];
                 id<SYYJSonAbstractBuilderInterface> builder = nil;
                 CREATE_JSON_TO_OBJECT_BUILDER(builder);
                 SET_BUILDER_CONTAINER(builder, @"SYYJsonUserCommentPushListInfo");
                 SET_BUILDER_RESOURCE(builder, responseObject);
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYPushModel", @"my_commented_list")
                 id object = GET_RESULT(builder);
                 
                 dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 getFailureUseBlocking(error);
             }
         ];
    } else {
        NSString * informationStr =[NSString stringWithFormat:@"%zd%@",userId,KMusicianCommentPushList];
        
        NSDictionary  * dict = [SYYFileCache readLocalCacheDataWithKey:informationStr andTimeScamp:0];
        if (dict ) {
            id<SYYJSonAbstractBuilderInterface> builder = nil;
            CREATE_JSON_TO_OBJECT_BUILDER(builder);
            SET_BUILDER_CONTAINER(builder, @"SYYJsonUserCommentPushListInfo");
            SET_BUILDER_RESOURCE(builder, dict);
            ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYPushModel", @"my_commented_list")
            id object = GET_RESULT(builder);
            
            dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
        }
        
        NSError *  error;
        getFailureUseBlocking(error);
        
    }
}



- (void) getMusicOrMomentPushListWithUid:(NSInteger) userId withTimestamp:(NSInteger)timestamp
                      getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
                   getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
    
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (kAppDelegate.SYYNETSTATUS != 0 && mgr.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
    
        
        NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,MUSICORMOMENTPUSHLIST];
        
        NSDictionary * paramaters = @{@"uid":[NSString stringWithFormat:@"%zd",userId],@"tm":[NSString stringWithFormat:@"%ld",(long)timestamp],@"sz":@"10"};
        //        url_string =[url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString * informationStr =[NSString stringWithFormat:@"%zd%@",userId,KGetLikeList];
        
        
        
        [manager GET:url_string parameters:paramaters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 [self judgeCacheLimit];
                 [SYYFileCache  writeLocalCacheData:responseObject withKey:informationStr andtimestamp:0];
                 id<SYYJSonAbstractBuilderInterface> builder = nil;
                 CREATE_JSON_TO_OBJECT_BUILDER(builder);
                 SET_BUILDER_CONTAINER(builder, @"SYYLikeMusicOrMomentInfo");
                 SET_BUILDER_RESOURCE(builder, responseObject);
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYPushModel", @"my_liked_list")
                 id object = GET_RESULT(builder);
                 
                 dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 getFailureUseBlocking(error);
             }
         ];
    } else {
        NSString * informationStr =[NSString stringWithFormat:@"%zd%@",userId,KGetLikeList];
        
        NSDictionary  * dict = [SYYFileCache readLocalCacheDataWithKey:informationStr andTimeScamp:0];
        if (dict ) {
            id<SYYJSonAbstractBuilderInterface> builder = nil;
            CREATE_JSON_TO_OBJECT_BUILDER(builder);
            SET_BUILDER_CONTAINER(builder, @"SYYLikeMusicOrMomentInfo");
            SET_BUILDER_RESOURCE(builder, dict);
            ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYPushModel", @"my_liked_list")
            id object = GET_RESULT(builder);
            
            dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
        }
        
        NSError *  error;
        getFailureUseBlocking(error);
        
    }
}

- (void) getPushListWithUid:(NSInteger) userId withTimestamp:(NSInteger)timestamp
         getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
      getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
    
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (kAppDelegate.SYYNETSTATUS != 0 && mgr.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        
        
        
        NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,PUSHLIST];
        
        NSDictionary * paramaters = @{@"uid":[NSString stringWithFormat:@"%zd",userId],@"tm":[NSString stringWithFormat:@"%ld",(long)timestamp],@"sz":@"10"};
        //        url_string =[url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString * informationStr =[NSString stringWithFormat:@"%zd%@",userId,KNotyList];
        
        
        
        [manager GET:url_string parameters:paramaters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 [self judgeCacheLimit];
                 [SYYFileCache  writeLocalCacheData:responseObject withKey:informationStr andtimestamp:0];
                 id<SYYJSonAbstractBuilderInterface> builder = nil;
                 CREATE_JSON_TO_OBJECT_BUILDER(builder);
                 SET_BUILDER_CONTAINER(builder, @"SYYOfficialPushInfo");
                 SET_BUILDER_RESOURCE(builder, responseObject);
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYPushModel", @"my_messaged_list")
                 id object = GET_RESULT(builder);
                 
                 dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 getFailureUseBlocking(error);
             }
         ];
    } else {
        NSString * informationStr =[NSString stringWithFormat:@"%zd%@",userId,KNotyList];
        
        NSDictionary  * dict = [SYYFileCache readLocalCacheDataWithKey:informationStr andTimeScamp:0];
        if (dict ) {
            id<SYYJSonAbstractBuilderInterface> builder = nil;
            CREATE_JSON_TO_OBJECT_BUILDER(builder);
            SET_BUILDER_CONTAINER(builder, @"SYYOfficialPushInfo");
            SET_BUILDER_RESOURCE(builder, dict);
            ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYPushModel", @"my_messaged_list")
            id object = GET_RESULT(builder);
            
            dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
        }
        
        NSError *  error;
        getFailureUseBlocking(error);
    }
}

- (void)uploadMomentCommentLike:(NSString *)jsonString getInfoUseBlocking:(void (^)(id))getInfoUseBlocking getFailureUseBlocking:(void (^)(id))getFailureUseBlocking {



      NSString *URL = [NSString stringWithFormat:@"%@/fxmusic/music/api/v2.0.0/clk",INTERFACEKURL];
  
    [self _uploadUserDefInfo:0
                  jsonString:jsonString
     
                         url:URL
     
          getInfoUseBlocking:getInfoUseBlocking
       getFailureUseBlocking:getFailureUseBlocking];
    

       
}

- (void) uploadMomentLike:(NSString*) jsonString
       getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
    getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{

 NSString *URL = [NSString stringWithFormat:@"%@/fxmusic/music/api/v2.0.0/mtl",INTERFACEKURL];
   
   
    [self _uploadUserDefInfo:0
                  jsonString:jsonString
     
                         url:URL
     
          getInfoUseBlocking:getInfoUseBlocking
       getFailureUseBlocking:getFailureUseBlocking];
    
}

- (void) uploadLikeMusic:(NSString*) jsonString
      getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
   getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking {

    NSString *URL = [NSString stringWithFormat:@"%@/fxmusic/music/api/v2.0.0/mlk",INTERFACEKURL];
    
    
    [self _uploadUserDefInfo:0
                  jsonString:jsonString
     
                         url:URL
     
          getInfoUseBlocking:getInfoUseBlocking
       getFailureUseBlocking:getFailureUseBlocking];
    
  
}

- (void) uploadLikeMusicComment:(NSString*) jsonString
             getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
          getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{

    NSString *URL = [NSString stringWithFormat:@"%@/fxmusic/music/api/v2.0.0/mclk",INTERFACEKURL];
    

    
    [self _uploadUserDefInfo:0
                  jsonString:jsonString
     
                         url:URL
     
          getInfoUseBlocking:getInfoUseBlocking
       getFailureUseBlocking:getFailureUseBlocking];


}
- (void)judgeCacheLimit {

    NSInteger limit = [[NSUserDefaults standardUserDefaults] integerForKey:@"user_max_cacheLimit"];
    
    float cacheSize = 0;
    cacheSize = [SYYFileCache totalMomentCache];
    
    if (cacheSize > limit) {
        

        //清理缓存
        NSString *createPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
                                stringByAppendingPathComponent:CIRCLEPAGECACHE];
        
        [SYYFileCache deleteLocalCacheDataWithKey:createPath];
        
        NSString *createPath1 = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
                                 stringByAppendingPathComponent:CIRCLEDETAILCACHE];
        
        [SYYFileCache deleteLocalCacheDataWithKey:createPath1];
        
        NSString *createPath2 = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
                                 stringByAppendingPathComponent:CIRCLECOMMENTCACHE];
        
        [SYYFileCache deleteLocalCacheDataWithKey:createPath2];
        
        NSString *createPath3 = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
                                 stringByAppendingPathComponent:KInviteSongCache];
        
        [SYYFileCache deleteLocalCacheDataWithKey:createPath3];
        
        NSString *createPath4 = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
                                 stringByAppendingPathComponent:KWorkChanceCache];
        
        [SYYFileCache deleteLocalCacheDataWithKey:createPath4];
        
        NSString *createPath5 = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
                                 stringByAppendingPathComponent:KSecondHandDealCache];
        
        [SYYFileCache deleteLocalCacheDataWithKey:createPath5];
        
        NSString *creatPath7 = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,
            YES)[0]
                                stringByAppendingPathComponent:ACTIVITYHOMECACHE];
        
        [SYYFileCache deleteLocalCacheDataWithKey:creatPath7];
        
        
        [SYYFileHandle clearCache];
        
        [[SDImageCache sharedImageCache] cleanDisk];
        return;
        
    }
    

    NSString *createPath6 = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
                             stringByAppendingPathComponent:@"MusicCaches"];
    
    CGFloat musicSize =  [SYYFileCache folderSizeAtPath:createPath6];
    
    if (cacheSize + musicSize > limit) {
        
    [[SDImageCache sharedImageCache] cleanDisk];
    
     [SYYFileHandle clearCache];
        
        return;
    }
   
   CGFloat picCache =[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
   
    if (cacheSize + musicSize + picCache > limit) {
        
    [[SDImageCache sharedImageCache] cleanDisk];
 
        return;

    }
}

- (void) getAPPVersiongetInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
                   getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
    
//    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];

        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        
    NSString *url_string = [NSString stringWithFormat:@"%@/fxmusic/music/api/v2.0.0/uvi?",INTERFACEKURL];
    
        [manager GET:url_string parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                 dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(responseObject);});

             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 getFailureUseBlocking(error);
             }
         ];
    
}


- (void) deleteMomentInfoWithMid:(NSInteger)mid  andUid:(NSInteger)uid  getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
           getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
    
    NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,DELETEMOMENT];
    
    NSDictionary * paramater = @{@"mid": [NSString stringWithFormat:@"%zd",mid] ,@"uid":[NSString stringWithFormat:@"%zd",uid]};
    
    [manager DELETE:url_string parameters:paramater success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(responseObject);});
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        getFailureUseBlocking(error);
    }];
 
    
}


- (void)getNotifyInformationWithUid:(NSInteger)uid getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
              getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
    
    NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,GETPUSHINFORMATION];
    
    NSDictionary * paramater = @{@"uid": [NSString stringWithFormat:@"%zd",uid]};
    
   [manager GET:url_string parameters:paramater progress:^(NSProgress * _Nonnull downloadProgress) {
       
   } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       getInfoUseBlocking(responseObject);
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       getFailureUseBlocking(error);
   }];



}


- (void) deleteMusicWithMcid:(NSInteger)mcid  andUid:(NSInteger)uid getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
       getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
    
    NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,DELETEMUSIC];
    
    NSDictionary * paramater = @{@"mcid": [NSString stringWithFormat:@"%zd",mcid] ,@"uid":[NSString stringWithFormat:@"%zd",uid]};
    
    [manager DELETE:url_string parameters:paramater success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(responseObject);});
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        getFailureUseBlocking(error);
    }];
}


- (void)getActivityRelativeDataWithUid:(NSInteger)uid withActivityType:(NSInteger)tpye  withTimestamp:(NSInteger)timestamp withCacheKey:(NSString *)cacheKey getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
                 getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking
{
    
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (kAppDelegate.SYYNETSTATUS != 0 && mgr.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        
        NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,ACTIVITYHOME];
        
        NSDictionary * paramater = @{@"uid":[NSString stringWithFormat:@"%zd",uid],@"tp":[NSString stringWithFormat:@"%zd",tpye],@"tm":[NSString stringWithFormat:@"%zd",timestamp]};
        
        url_string = [url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [manager GET:url_string parameters:paramater progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 [SYYFileCache  deleteLocalCacheDataWithKey:cacheKey];
                 
                 [self judgeCacheLimit];
                 
                 [SYYFileCache writeLocalActivityCacheData:responseObject withKey:cacheKey];
                 
                 [SYYFileCache totalMomentCache];
                 
                 id<SYYJSonAbstractBuilderInterface> builder = nil;
                 CREATE_JSON_TO_OBJECT_BUILDER(builder);
                 SET_BUILDER_CONTAINER(builder, @"SYYActivityRelativeInfo");
                 
                 SET_BUILDER_RESOURCE(builder, responseObject);
                 
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYInterviewModel", @"newest_interview");
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYActivityModel", @"newest_activity");
                 
                 id object = GET_RESULT(builder);
                 
                 
                 dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"%@  %zd",error,error.code);
                 getFailureUseBlocking(error);
             }
         ];
    } else{
        
         NSDictionary *dataDic = [SYYFileCache readLocalActivityCacheData:cacheKey];
    
        if (dataDic ) {
            
            id<SYYJSonAbstractBuilderInterface> builder = nil;
            CREATE_JSON_TO_OBJECT_BUILDER(builder);
            SET_BUILDER_CONTAINER(builder, @"SYYActivityRelativeInfo");
            
            SET_BUILDER_RESOURCE(builder, dataDic);
            
            ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYInterviewModel", @"newest_interview");
            ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYActivityModel", @"newest_activity");
            
            id object = GET_RESULT(builder);
            
            
            dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
        }else {//没有值，直接返回失败；
            getFailureUseBlocking(nil);
        }
   }
}

- (void)getNewestORHotestMusicListWithUid:(NSInteger)uid withMusicType:(NSInteger)tpye  AndKey:(NSString *)key withTimestamp:(NSInteger)timestamp getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
                    getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
    //    int userId = 10019;
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (kAppDelegate.SYYNETSTATUS != 0 && mgr.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable  ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        
        
        NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,HOMEHOTNEWMUSICLIST];
        
        NSDictionary * paramater = @{@"uid":[NSString stringWithFormat:@"%zd",uid],@"tp":[NSString stringWithFormat:@"%zd",tpye],@"tm":[NSString stringWithFormat:@"%zd",timestamp],@"sz":@"20"};
        
        url_string = [url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString * informationStr;
//        if (tpye == 0) {
//          informationStr  =[NSString stringWithFormat:@"ew%zd",uid];
//
//        } else if (tpye ==1){
//          informationStr  =[NSString stringWithFormat:@"hot%zd",uid];
//        }
                [manager GET:url_string parameters:paramater progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                  [SYYFileCache  writeLocalCacheData:responseObject withKey:key andtimestamp:timestamp];
                 id<SYYJSonAbstractBuilderInterface> builder = nil;
                 CREATE_JSON_TO_OBJECT_BUILDER(builder);
                 SET_BUILDER_CONTAINER(builder, @"SYYHomeHOT_NEWMusicList");
                 
                 SET_BUILDER_RESOURCE(builder, responseObject);
                 
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonMusicInfo", @"recommended_hottest_music_list");
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonMusicInfo", @"recommended_newest_music_list");
                 
                 id object = GET_RESULT(builder);
                 
                 
                 dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"%@  %zd",error,error.code);
                 getFailureUseBlocking(error);
             }
         ];
    } else {
//        NSString * informationStr;
//        if (tpye == 0) {
//            informationStr  =[NSString stringWithFormat:@"ew%zd",uid];
//            
//        } else if (tpye ==1){
//            informationStr  =[NSString stringWithFormat:@"hot%zd",uid];
//        }
        
        NSDictionary  * dict = [SYYFileCache readLocalCacheDataWithKey:key andTimeScamp:timestamp];
        if (dict ) {
            
            id<SYYJSonAbstractBuilderInterface> builder = nil;
            CREATE_JSON_TO_OBJECT_BUILDER(builder);
            SET_BUILDER_CONTAINER(builder, @"SYYHomeHOT_NEWMusicList");
            
            SET_BUILDER_RESOURCE(builder, dict);
            
            ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonMusicInfo", @"recommended_hottest_music_list");
            ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonMusicInfo", @"recommended_newest_music_list");
            
            id object = GET_RESULT(builder);
            
            
            dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
        }
        
        NSError *  error;
        getFailureUseBlocking(error);
    }
    
}

- (void)getMoreMusicListwithTimestamp:(NSInteger)timestamp getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
                getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
    
    
    
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusUnknown ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWWAN ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWiFi ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        
        
        
        NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,GETMORESONGLIST];
        
        NSDictionary * paramater = @{@"sz":@"15",@"tm":[NSString stringWithFormat:@"%zd",timestamp]};
        
        url_string = [url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
       NSString * informationStr =[NSString stringWithFormat:@"musicList%@",KNotyList];
        
        
        [manager GET:url_string parameters:paramater progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 [SYYFileCache  writeLocalCacheData:responseObject withKey:informationStr andtimestamp:0];

                 
                 id<SYYJSonAbstractBuilderInterface> builder = nil;
                 CREATE_JSON_TO_OBJECT_BUILDER(builder);
                 
                 SET_BUILDER_CONTAINER(builder, @"SYYGetMoreSongLIstInfo");
                 
                 SET_BUILDER_RESOURCE(builder, responseObject);
                 
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYHomeSongListModel", @"song_list");
                 
                 id object = GET_RESULT(builder);
                 
                 
                 
                 dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"%@  %zd",error,error.code);
                 getFailureUseBlocking(error);
             }
         ];
    } else {
        NSString * informationStr =[NSString stringWithFormat:@"musicList%@",KNotyList];
        
        NSDictionary  * dict = [SYYFileCache readLocalCacheDataWithKey:informationStr andTimeScamp:0];
        if (dict ) {
            
            id<SYYJSonAbstractBuilderInterface> builder = nil;
            CREATE_JSON_TO_OBJECT_BUILDER(builder);
            
            SET_BUILDER_CONTAINER(builder, @"SYYGetMoreSongLIstInfo");
            
            SET_BUILDER_RESOURCE(builder, dict);
            
            ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYHomeSongListModel", @"song_list");
            
            id object = GET_RESULT(builder);
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
        }
        
        NSError *  error;
        getFailureUseBlocking(error);
    }
    
}



- (void) getSearchInterviewOrActivityList:(NSString*) condition
                                withActivityType:(NSInteger)tpye
                       getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
                    getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
    


    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusUnknown ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWWAN ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWiFi ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        
        

        
        NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,SEARCHACTIVITYLIST];
        
        NSDictionary * paramater = @{@"search":condition,@"tp":[NSString stringWithFormat:@"%zd",tpye]};

        url_string = [url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [manager GET:url_string parameters:paramater progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 id<SYYJSonAbstractBuilderInterface> builder = nil;
                 CREATE_JSON_TO_OBJECT_BUILDER(builder);

                
                 SET_BUILDER_CONTAINER(builder, @"SYYJSonSearchInterviewOrActivityResponse");
                 SET_BUILDER_RESOURCE(builder, responseObject);
                 
                 
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYInterviewModel",@"interview_search");
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYActivityModel", @"activity_search");
                 id object = GET_RESULT(builder);
                 

                 dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"%@  %zd",error,error.code);
                 getFailureUseBlocking(error);
             }
         ];
    }

}


- (void) getMusicianListWith:(NSString *)searchStr  WithUid:(NSInteger) uid
                                 andTimestamp:(NSInteger)timestamp
                    getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking

                 getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
    //    int userId = 10019;
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (kAppDelegate.SYYNETSTATUS != 0 && mgr.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        
        
        NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,SEARCHMUSICIANLISTBRIEFINFORMARTION];
        
        NSDictionary * paramater = @{@"uid":[NSString stringWithFormat:@"%zd",uid],@"tm":[NSString stringWithFormat:@"%zd",timestamp],@"search":searchStr};
        
        url_string = [url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString * informationStr =[NSString stringWithFormat:@"%zd%@",uid,searchStr];
        [manager GET:url_string parameters:paramater progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                    [SYYFileCache  writeLocalCacheData:responseObject withKey:informationStr andtimestamp:0];
                 id<SYYJSonAbstractBuilderInterface> builder = nil;
                 CREATE_JSON_TO_OBJECT_BUILDER(builder);
                 SET_BUILDER_CONTAINER(builder, @"SYYMusicianInformationInfo");
                 
                 SET_BUILDER_RESOURCE(builder, responseObject);
                 
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYMusicianBriefModel", @"musicians");
                 
                 
                 id object = GET_RESULT(builder);
                 
                 
                 dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"%@  %zd",error,error.code);
                 getFailureUseBlocking(error);
             }
         ];
    } else {
    
        NSString * informationStr =[NSString stringWithFormat:@"%zd%@",uid,searchStr];
        
        NSDictionary  * dict = [SYYFileCache readLocalCacheDataWithKey:informationStr andTimeScamp:0];
        if (dict ) {
            id<SYYJSonAbstractBuilderInterface> builder = nil;
            CREATE_JSON_TO_OBJECT_BUILDER(builder);
            SET_BUILDER_CONTAINER(builder, @"SYYMusicianInformationInfo");
            
            SET_BUILDER_RESOURCE(builder, dict);
            
            ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYMusicianBriefModel", @"musicians");
            
            
            id object = GET_RESULT(builder);
            
            dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
        }
        
        NSError *  error;
        getFailureUseBlocking(error);
    }
    
}
- (void)getHotOrNewMusicianListWithUid:(NSInteger) uid
                          andTimestamp:(NSInteger)timestamp withTP:(NSInteger)type
                    getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking

                 getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
    //    int userId = 10019;
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (kAppDelegate.SYYNETSTATUS != 0 && mgr.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        
        
        NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,HOTORNEWMUSICIANLISTBRIEFINFORMARTION];
        
        NSDictionary * paramater = @{@"uid":[NSString stringWithFormat:@"%zd",uid],@"tm":[NSString stringWithFormat:@"%zd",timestamp],@"tp":[NSString stringWithFormat:@"%zd",type]};
        
        url_string = [url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
         NSString * informationStr =[NSString stringWithFormat:@"hotAndNewMusician%zd%zd",uid,type];
        [manager GET:url_string parameters:paramater progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SYYFileCache  writeLocalCacheData:responseObject withKey:informationStr andtimestamp:0];
                 id<SYYJSonAbstractBuilderInterface> builder = nil;
                 CREATE_JSON_TO_OBJECT_BUILDER(builder);
                 SET_BUILDER_CONTAINER(builder, @"SYYMusicianInformationInfo");
                 
                 SET_BUILDER_RESOURCE(builder, responseObject);
                 
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYMusicianBriefModel", @"musicians");
                 
                 
                 id object = GET_RESULT(builder);
                 
                 
                 dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"%@  %zd",error,error.code);
                 getFailureUseBlocking(error);
             }
         ];
    } else {
        NSString * informationStr =[NSString stringWithFormat:@"hotAndNewMusician%zd%zd",uid,type];
        
        NSDictionary  * dict = [SYYFileCache readLocalCacheDataWithKey:informationStr andTimeScamp:0];
        if (dict ) {
            
            id<SYYJSonAbstractBuilderInterface> builder = nil;
            CREATE_JSON_TO_OBJECT_BUILDER(builder);
            SET_BUILDER_CONTAINER(builder, @"SYYMusicianInformationInfo");
            
            SET_BUILDER_RESOURCE(builder, dict);
            
            ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYMusicianBriefModel", @"musicians");
            
            
            id object = GET_RESULT(builder);
            
            
            dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
        }
        
        NSError *  error;
        getFailureUseBlocking(error);
    }
    
}


- (void) getRecommendMusicListWith:(int)userId  withSongListId:(NSInteger)songlistId
               getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
            getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{

    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (kAppDelegate.SYYNETSTATUS != 0 && mgr.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];

        NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,MUSICDETAILLIST];
        
        NSDictionary * paramaters = @{@"uid":[NSString stringWithFormat:@"%zd",userId],@"song_list_id":[NSString stringWithFormat:@"%zd",songlistId]};
        NSString * informationStr =[NSString stringWithFormat:@"%zd%zd",userId,songlistId];
        
        [manager GET:url_string parameters:paramaters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
               [SYYFileCache  writeLocalCacheData:responseObject withKey:informationStr andtimestamp:0];
                 
                 id<SYYJSonAbstractBuilderInterface> builder = nil;
                 CREATE_JSON_TO_OBJECT_BUILDER(builder);
                 SET_BUILDER_CONTAINER(builder, @"SYYRecommendMusicListDetailResponse");
                 SET_BUILDER_RESOURCE(builder, responseObject);
                 
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonMusicInfo", @"music_list")
                 id object = GET_RESULT(builder);
                 
                 dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 getFailureUseBlocking(error);
             }
         ];
    } else {
        NSString * informationStr =[NSString stringWithFormat:@"%zd%zd",userId,songlistId];
        
        NSDictionary  * dict = [SYYFileCache readLocalCacheDataWithKey:informationStr andTimeScamp:0];
        if (dict ) {
            
            
            id<SYYJSonAbstractBuilderInterface> builder = nil;
            CREATE_JSON_TO_OBJECT_BUILDER(builder);
            SET_BUILDER_CONTAINER(builder, @"SYYRecommendMusicListDetailResponse");
            SET_BUILDER_RESOURCE(builder, dict);
            
            ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonMusicInfo", @"music_list")
            id object = GET_RESULT(builder);
            
            dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
        }
        
        NSError *  error;
        getFailureUseBlocking(error);
    }
}


- (void) getInterviewRelativeCommentList:(int) interviewId withUserId:(int)userId withSize:(int)size
                               timestamp:(NSInteger)timestamp
                      getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
                   getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
    
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusUnknown ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWWAN ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWiFi ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        
        
        NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERVIEWCOMMENT];   
        
        NSDictionary * paramater = @{@"interview_id":[NSString stringWithFormat:@"%zd",interviewId],@"uid":[NSString stringWithFormat:@"%zd",userId],@"tm":[NSString stringWithFormat:@"%zd",timestamp],@"sz":[NSString stringWithFormat:@"%zd",size]}; 
        
        url_string = [url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [manager GET:url_string parameters:paramater progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                 //?解析方法
                 id<SYYJSonAbstractBuilderInterface> builder = nil;
                 CREATE_JSON_TO_OBJECT_BUILDER(builder);
                 SET_BUILDER_CONTAINER(builder, @"SYYInterviewCommentsResponse");
                 
                 SET_BUILDER_RESOURCE(builder, responseObject);
                 
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJsonInterviewCommentInfo", @"interview_comment");
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonResourceInfo", @"resource_info");
                 
                 id object = GET_RESULT(builder);
                 
                 
                 dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"%@  %zd",error,error.code);
                 getFailureUseBlocking(error);
             }
         ];
    }
}



- (void) uploadInterViewCommentInfo:(NSString*) jsonString
                getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
             getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
    
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSString * URL = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEGUIWC];
    
    [self _uploadUserDefInfo:(int)app.userId
                  jsonString:jsonString
     
                         url:URL
     
          getInfoUseBlocking:getInfoUseBlocking
       getFailureUseBlocking:getFailureUseBlocking];


}

- (void) uploadActivityDetailCommentInfo:(NSString*) jsonString
                getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
             getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
    
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSString * URL = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEGUIYC];
    
    [self _uploadUserDefInfo:(int)app.userId
                  jsonString:jsonString
     
                         url:URL
     
          getInfoUseBlocking:getInfoUseBlocking
       getFailureUseBlocking:getFailureUseBlocking];
    
    
}

- (void) getAcitivityRelativeCommentList:(int)activityId  withUserId:(int)userId withSize:(int)size
                               timestamp:(NSInteger)timestamp
                      getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
                   getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{
    
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusUnknown ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWWAN ||
        mgr.networkReachabilityStatus ==AFNetworkReachabilityStatusReachableViaWiFi ) {
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        
        
        NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,ACTIVITYCOMMENT];
        
        NSDictionary * paramater = @{@"activity_id":[NSString stringWithFormat:@"%zd",activityId],@"uid":[NSString stringWithFormat:@"%zd",userId],@"tm":[NSString stringWithFormat:@"%zd",timestamp],@"sz":[NSString stringWithFormat:@"%zd",size]};
        
        url_string = [url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [manager GET:url_string parameters:paramater progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 //?解析方法
                 id<SYYJSonAbstractBuilderInterface> builder = nil;
                 CREATE_JSON_TO_OBJECT_BUILDER(builder);
                 SET_BUILDER_CONTAINER(builder, @"SYYActivityCommentInfo");
                 
                 SET_BUILDER_RESOURCE(builder, responseObject);
                 
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJsonInterviewCommentInfo", @"activity_comment");
                 ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonResourceInfo", @"resource_info");
                 //ADD_BUILDER_RESOURCE_PROCESSOR(builder, @"SYYJSonResourceInfo", @"resource_info");
                 
                 id object = GET_RESULT(builder);
                 
                 
                 dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(object);});
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"%@  %zd",error,error.code);
                 getFailureUseBlocking(error);
             }
         ];
    }
}

- (void) uploadInterviewCommentLike:(NSString*) jsonString
                 getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
              getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{

    NSString *URL = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACRGUICL];
    
    
    [self _uploadUserDefInfo:0
                  jsonString:jsonString
     
                         url:URL
     
          getInfoUseBlocking:getInfoUseBlocking
       getFailureUseBlocking:getFailureUseBlocking];
 
}

- (void) uploadActivityCommentLike:(NSString*) jsonString
                getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
             getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{

    NSString *URL = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTERFACEGUACL];
    
    
    [self _uploadUserDefInfo:0
                  jsonString:jsonString
     
                         url:URL
     
          getInfoUseBlocking:getInfoUseBlocking
       getFailureUseBlocking:getFailureUseBlocking];

}

-(void) getDefaultSearchValue:(int) tpye
           getInfoUseBlocking:(void (^)(id response))getInfoUseBlocking
        getFailureUseBlocking:(void (^)(id error))getFailureUseBlocking{

    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    
    if (kAppDelegate.SYYNETSTATUS != 0 && mgr.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable ){
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html" ,@"text/plain",nil];
        
        NSString *url_string = [NSString stringWithFormat:@"%@%@",INTERFACEKURL,INTETFACEGSDV];
        
        
        NSDictionary * paramaters = @{@"tp":[NSString stringWithFormat:@"%zd",tpye]};
        [manager GET:url_string parameters:paramaters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           NSDictionary * response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSUTF8StringEncoding error:nil];
         
            dispatch_async(dispatch_get_main_queue(), ^{    getInfoUseBlocking(response);});
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            getFailureUseBlocking(error);
            NSLog(@"%@",error);
        }
         ];
    }
}



@end

