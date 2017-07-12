//
//  SYYJSonUploadResourceToken.h
//  SYY
//
//  Created by kuoxin on 7/18/16.
//  Copyright © 2016 cn.com.rockmobile. All rights reserved.
//

#import "SYYJSonAbtractObject.h"

/// 资源token类
@interface SYYJSonUploadResourceToken : SYYJSonAbtractObject
@property(nonatomic, copy)NSString* key;
@property(nonatomic, copy)NSString* token;
@property(nonatomic, copy)NSString* url;
@end
