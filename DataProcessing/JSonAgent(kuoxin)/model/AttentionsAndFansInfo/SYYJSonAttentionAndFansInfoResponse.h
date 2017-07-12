//
//  SYYJSonAttentionInfoResponse.h
//  SYY
//
//  Created by kuoxin on 7/7/16.
//  Copyright © 2016 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonResponse.h"

@interface SYYJSonFansInfoResponse : SYYJSonResponse
@property(nonatomic, copy) NSArray* fans; //SYYJSonMusicianInfo
@end

@interface SYYJSonAttentionInfoResponse : SYYJSonResponse
@property(nonatomic, copy) NSArray* attention; //SYYJSonMusicianInfo
@end
