//
//  SYYJSONUploadResourceTokenResponse.h
//  SYY
//
//  Created by kuoxin on 7/18/16.
//  Copyright © 2016 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonResponse.h"

@class SYYJSonUploadResourceToken;
/// 获取上传资源token接口转接类
@interface SYYJSONUploadResourceTokenResponse : SYYJSonResponse
@property(nonatomic, retain) SYYJSonUploadResourceToken* cloud_storage_token;
@end
