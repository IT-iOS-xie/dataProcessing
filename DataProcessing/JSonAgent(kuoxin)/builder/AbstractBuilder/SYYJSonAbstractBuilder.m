//
//  SYYJSonAbstractBuilder.m
//  SYY
//
//  Created by kuoxin on 7/6/16.
//  Copyright © 2016 cn.com.rockmobile. All rights reserved.
//

#import <objc/runtime.h>
#import <objc/message.h>
#import "SYYJSonAbstractBuilder.h"
#import "SYYJSonAbtractObject.h"


@implementation SYYJSonAbstractBuilder

#pragma mark --- protocol implementation function ---

-(BOOL) buildContainer: (SYYJSONBUILDER_VAR_TYPE) container
{   return YES;}

-(BOOL) addBuilderPart:(SYYJSONBUILDER_VAR_TYPE)type
               keyName: (SYYJSONBUILDER_VAR_TYPE) keyName
{   return YES;}

-(BOOL) deleteBuilderPart:(SYYJSONBUILDER_VAR_TYPE)type
                  keyName: (SYYJSONBUILDER_VAR_TYPE) keyName
{   return YES;}

-(BOOL) setBuilderResource:(SYYJSONBUILDER_VAR_TYPE)resource
{   return YES; }

-(BOOL) addBuilderResourceProcessor:(SYYJSONBUILDER_VAR_TYPE)type
                            keyName:(SYYJSONBUILDER_VAR_TYPE)keyName
{   return YES;}

-(id) getResult{return nil;};

#pragma mark --- class protect function ---

-(NSString*) _getPropertyClassName:(const char*) className
{
    NSString* value = nil;
    char buf[MAX_BUF_SIZE] = {""};
    char* ptr = (char*) className;
    char* bufp = buf;
    
    while(*ptr) {
        
        if (*ptr != '@' && *ptr != '\"') {
            *bufp++ = *ptr;
        }
        ++ptr;
    }
    
    value = [NSMutableString stringWithCString: buf
                                      encoding:NSASCIIStringEncoding];
    return value;
}


-(NSDictionary*) _getPropertyListFromObject:(Class) class
{
    objc_property_t* properties = nil;
    objc_property_t op = nil;
    objc_property_attribute_t* attributes = nil;
    
    const char* name_ptr = nil;
    unsigned int count = 0;
    unsigned int attr_count = 0;
    
    NSString* keyName = nil;
    NSString* value = nil;
    
    if ( class == nil)  return nil;
    
    //if the class of this object is NSObject, the function returns a nil;
    if (strcasecmp(class_getName(class), "NSObject") == 0)    return nil;
    
    NSMutableDictionary* result = [[NSMutableDictionary alloc] init];
    
    //recursive call
    Class superClass = class_getSuperclass(class);
    
    if (superClass != nil) {
        
        NSDictionary* tmp_result = [self _getPropertyListFromObject: superClass];
        
        if(tmp_result != nil && tmp_result.count > 0)
            [result setDictionary:tmp_result];
    }
    
    properties = class_copyPropertyList(class, &count);
    
    for (int i = 0; i < count; ++i) {
        
        op = properties[i];
        attr_count = 0;
        name_ptr = property_getName(op);
        
        keyName = [NSString stringWithCString:name_ptr encoding:NSASCIIStringEncoding];
        
        attributes = property_copyAttributeList(op, &attr_count);
        
        for(int j = 0; j < attr_count; ++j){
            
            if (strcmp(attributes[j].name, "T") == 0) {
                
                value = [self _getPropertyClassName: attributes[j].value];
                [result setObject:value forKey:keyName];
                break;
            }
        }
        
        free(attributes);
    }
    
    free(properties);
    
    return result;
}

-(int) _getObjectCollectionType: (NSString*) className
{
    int result = SYYJSON_NULL_TYPE;
    
    if (className != nil && className.length > 0) {
        
        Class tmp_class = NSClassFromString(className);
        if (tmp_class != nil) {
            
            id tmp_obj = [[tmp_class alloc] init];
            if ([tmp_obj isKindOfClass:[NSArray class]]) {
                
                result = SYYJSON_NSARRAY_TYPE;
            }
            else if ([tmp_obj isKindOfClass:[SYYJSonAbtractObject class]]){
                
                result = SYYJSON_ABTRACT_OBJECT_TYPE;
            }
        }
    }
    
    return result;
}

-(id) _getObjectPropertyValue:(id) object
                 propertyName:(NSString*) propertyName
{
    id value = nil;
    
    if(object == nil || propertyName == nil) return value;
    
//    NSString* propertySetter = [[NSString alloc]initWithString:propertyName];
//    SEL getSel = NSSelectorFromString(propertySetter);
//    
//    if ([object respondsToSelector:getSel]) {
//        
//        value = [object performSelector:getSel];
//    }
    value = [object valueForKey: propertyName];
    
    return value;
}


-(BOOL) _setObjectPropertyValue:(id) object
                   propertyName:(NSString*) propertyName
                          value:(id) value
{
    BOOL isOk = YES;

    if(object == nil || propertyName == nil || value == nil) return NO;
    
    [object setValue:value forKey:propertyName];
    
//    //capital Apha word
//    NSMutableString* capitalAlphabetString = [[NSMutableString alloc]initWithString:propertyName];
//    NSString* alp = [propertyName.capitalizedString substringWithRange:NSMakeRange(0, 1)];
//    [capitalAlphabetString replaceCharactersInRange:NSMakeRange(0, 1) withString:alp];
//    
//    
//    //setResource_info
//    NSString* propertySetter = [NSString stringWithFormat:@"set%@:", capitalAlphabetString];
//    SEL setSel = NSSelectorFromString(propertySetter);
//    
//    if ([object respondsToSelector:setSel]) {
//        
//        [object performSelector:setSel withObject:value];
//        isOk = YES;
//    }
    
    
    return isOk;
}


@end
