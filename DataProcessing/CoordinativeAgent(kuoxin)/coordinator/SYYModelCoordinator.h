//
//  SYYModelCoordinator.h
//  SYY
//
//  Created by kuoxin on 7/8/16.
//  Copyright © 2016 cn.com.rockmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYYAbstractCoordinator.h"
#import "SYYAbstractCoordinatorModel.h"



 

@class SYYCoordinatorModel;



///  网络请求类（遵循提供系统协调器抽象协议）
@interface SYYModelCoordinator : NSObject<SYYAbstractCoordinator>
{
    
@protected
    id<SYYAbstractCoordinatorModel> model_;
}
/** 单例类方法  */
+(SYYModelCoordinator *)sharedManager;

- (id)init __attribute__((unavailable("cannot use init for this class, use +(SYYModelCoordinator*)sharedInstance instead")));


- (void)judgeCacheLimit;

@end
