//
//  SYYMusicModel.m
//  SYY
//
//  Created by xjw on 2017/2/22.
//  Copyright © 2017年 cn.com.rockmobile. All rights reserved.
//

#import "SYYMusicModel.h"
#import <objc/runtime.h>
@implementation SYYMusicModel
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
@end
