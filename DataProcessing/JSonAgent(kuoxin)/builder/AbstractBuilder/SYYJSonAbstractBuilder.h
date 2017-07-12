//
//  SYYJSonAbstractBuilder.h
//  SYY
//
//  Created by kuoxin on 7/6/16.
//  Copyright © 2016 cn.com.rockmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYYJSonAbstractBuilderInterface.h"

@interface SYYJSonAbstractBuilder : NSObject<SYYJSonAbstractBuilderInterface>

/**
 得到对象的属性列表
 */
-(NSDictionary*) _getPropertyListFromObject:(Class) class;


-(NSString*) _getPropertyClassName:(const char*) className;

/**
 得到当前类的集合类型，目前存在两种NSArray, SYYJSonAbstractObject
 */
-(int) _getObjectCollectionType: (NSString*) className;

/**
 指定json中相应的键值所对应的类型
 @param object         对象id
 @param propertyName   需要生成的对象属性名
 @return id            成功返回属性id，否则返回nil
 */
-(id) _getObjectPropertyValue:(id) object
                 propertyName:(NSString*) propertyName;

-(BOOL) _setObjectPropertyValue:(id) object
                   propertyName:(NSString*) propertyName
                          value:(id) value;

@end
