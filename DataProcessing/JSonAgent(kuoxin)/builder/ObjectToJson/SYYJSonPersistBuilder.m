 //
//  SYYJSonPersistBuilder.m
//  SYY
//
//  Created by kuoxin on 7/5/16.
//  Copyright © 2016 cn.com.rockmobile. All rights reserved.
//
#import <objc/runtime.h>
#import "SYYJSonPersistBuilder.h"

@implementation SYYJSonPersistBuilder

-(instancetype) init
{
    if(self = [super init]){}
    
    return self;
}

/**
 指定builder使用的资源
 @param resource   该类型具体实现的builder确定
 @return BOOL   YES为有效资源，NO资源无效
 */
-(BOOL) setBuilderResource:(SYYJSONBUILDER_VAR_TYPE)resource
{
    BOOL isOk = NO;
    
    if (resource.instance_ != nil) {
        
        resource_ = resource.instance_;
        isOk = YES;
    }
    
    return isOk;
}

/**
 指定json中相应的键值所对应的类型
 @param type    指定需要生成类名
 @param keyName 需要生成的对象变量名或键值
 @return BOOL   YES为有效资源，NO资源无效
 */
-(BOOL) addBuilderResourceProcessor:(SYYJSONBUILDER_VAR_TYPE)type
                            keyName:(SYYJSONBUILDER_VAR_TYPE)keyName
{   return YES; }

/**
 获取当前对象的属性转变为字典
 @param object 需要生成的对象
 @return NSDictionary  返回字典
 */
-(NSDictionary*) decodeObjectToJSon:(id) object
{
    NSMutableDictionary* result = nil;
    
    if (object == nil) return result;
    
    Class class = object_getClass(object);
    if (class == nil)   return result;
    
    result = [[NSMutableDictionary alloc]init];
    NSDictionary* keyNameWithValue = [self _getPropertyListFromObject:class];
    
    [keyNameWithValue enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL* stop){
        
        NSString* propertyName = (NSString*) key;
        NSString* className = (NSString*) value;
        
        id propertyValue = [self _getObjectPropertyValue:object propertyName: propertyName];
        id tmp_obj = nil;
        
        if (propertyValue != nil) {
            
            int classType = [self _getObjectCollectionType:className];
            
            switch (classType) {
                case SYYJSON_NSARRAY_TYPE:
                    
                    if ([propertyValue isKindOfClass:[NSArray class]]) {
                        
                        tmp_obj = [[NSMutableArray alloc] init];
                        [propertyValue enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop){
                            if ([obj isKindOfClass:[NSNumber class]]) {
                                [tmp_obj addObject: obj];
                            } else {
                            id tmp_result = [self decodeObjectToJSon: obj];
                            
                            if (tmp_result != nil) [tmp_obj addObject: tmp_result];
                            }
                        }];
                        
                        [result setValue:tmp_obj forKey:propertyName];
                    }
                    break;
                case SYYJSON_ABTRACT_OBJECT_TYPE:
                    
                    tmp_obj = [self decodeObjectToJSon:propertyValue];
                        
                    if (tmp_obj != nil) {
                            
                        [result setValue:tmp_obj forKey:propertyName];
                    }
                    
                    break;
                case SYYJSON_NULL_TYPE:
                    
                    [result setValue:propertyValue forKey:propertyName];
                    break;
                default:
                    break;
            }
        }
    }];
    
    return result;
}


-(id) getResult
{
    NSDictionary* result = [self decodeObjectToJSon:resource_];
    id json = [NSJSONSerialization dataWithJSONObject: result options:0 error:nil];
    
    NSString* jsonString = [[NSString alloc]initWithData:json encoding:NSUTF8StringEncoding];
    
    return jsonString;
}


@end
