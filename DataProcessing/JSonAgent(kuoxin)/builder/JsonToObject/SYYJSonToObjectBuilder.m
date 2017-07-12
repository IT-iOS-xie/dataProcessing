/**
 file:  SYYJSonAgentController.m
 project:  SYY

  log:
    16/7/1: Created by kuoxin
    16/7/5: support the inheritance of container
*/

#import <objc/runtime.h>
#import "SYYJSonToObjectBuilder.h"
#import "SYYJSonResponse.h"

@interface SYYJSonToObjectBuilder(Private)

    -(id) getValueOfResourceFromKeyName: (NSDictionary*) resource keyName:(NSString*) keyName;

    -(BOOL) addBuilderPartPrivate:(SYYJSONBUILDER_VAR_TYPE) type
                          keyName: (SYYJSONBUILDER_VAR_TYPE) keyName
                        container: (NSMutableDictionary*) container;

    -(BOOL) deleteBuilderPartPrivate:(SYYJSONBUILDER_VAR_TYPE) type
                             keyName: (SYYJSONBUILDER_VAR_TYPE) keyName
                           container: (NSMutableDictionary*) container;

    -(BOOL) addBuilderPropertyIntoContainerPrivate: (Class) container
                                  availableKeyName: (NSDictionary*) availableKeyName;

    -(Class) getBuilderResourceProcessorPrivate: (NSString*) keyName;

    -(id) encodeJSonToObjectPrivate:(Class) class
                           resource: (id) resource;

@end

@implementation SYYJSonToObjectBuilder

-(instancetype) init
{
    if(self = [super init]){
        
        container_ = nil;
        classWithKeyName_ = [[NSMutableDictionary alloc] init];
        propertiesOfContainer_ = [[NSMutableDictionary alloc] init];
        resource_ = nil;
    }
    return self;
}

/**
 *   需要填写SYYJSONBUILDER_PART中的类名或实例名
 */
-(BOOL) buildContainer: (SYYJSONBUILDER_VAR_TYPE) container;
{
    BOOL isOk = NO;
    if (container.className_ != nil) {
        container_ = objc_getClass([container.className_ cStringUsingEncoding: NSASCIIStringEncoding]);
        isOk = YES;
    }
    else if (container.instance_ != nil){
        const char* class_name = object_getClassName(container.instance_);
        container_ = objc_getClass(class_name);
        isOk = YES;
    }
    
    return isOk;
}

#pragma mark operateBuilderPart function...

-(BOOL) addBuilderPartPrivate:(SYYJSONBUILDER_VAR_TYPE) type
                      keyName: (SYYJSONBUILDER_VAR_TYPE) keyName
                    container: (NSMutableDictionary*) container
{
    BOOL isOk = NO;
    if(type.className_ != nil && keyName.jsonKeyName_ != nil){
        
        [container setObject:type.className_ forKey:keyName.jsonKeyName_];
        isOk = YES;
    }
    return isOk;
}

-(BOOL) deleteBuilderPartPrivate:(SYYJSONBUILDER_VAR_TYPE) type
                      keyName: (SYYJSONBUILDER_VAR_TYPE) keyName
                    container: (NSMutableDictionary*) container
{
    BOOL isOk = NO;
    if(keyName.jsonKeyName_ != nil){
        
        [container removeObjectForKey:keyName.jsonKeyName_];
        isOk = YES;
    }
    return isOk;
}

-(BOOL) addBuilderPropertyIntoContainerPrivate: (Class) container
                              availableKeyName: (NSDictionary*) availableKeyName
{
    __block BOOL isOk = YES;
    
    if (container == nil) return isOk = NO;
    
    if (availableKeyName != nil) {
        
        [availableKeyName enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL* stop){
            
            NSString* name = (NSString*)key;
            const char* ptr = [name cStringUsingEncoding: NSASCIIStringEncoding];
            char tmp_buf[MAX_BUF_SIZE] = {""};
            char tmp_buf_1[MAX_BUF_SIZE] = {""};

            sprintf(tmp_buf, "@\"%s\"", [value cStringUsingEncoding:NSASCIIStringEncoding]);
            sprintf(tmp_buf_1, "_%s", [key cStringUsingEncoding:NSASCIIStringEncoding]);
            
            objc_property_attribute_t attrs[] = {{"T", tmp_buf}, {"C", ""}, {"N",""}, {"V", tmp_buf_1}};
            isOk = class_addProperty(container, ptr, attrs, sizeof(attrs)/sizeof(attrs[0]));
        }];
    }
    
    return isOk;
}

/**
 指定在json中需要导出的key名称
 */
-(BOOL) addBuilderPart:(SYYJSONBUILDER_VAR_TYPE)type
          keyName: (SYYJSONBUILDER_VAR_TYPE) keyName
{
    return [self addBuilderPartPrivate:type keyName:keyName container: propertiesOfContainer_];
}

-(BOOL) deleteBuilderPart:(SYYJSONBUILDER_VAR_TYPE)type
               keyName: (SYYJSONBUILDER_VAR_TYPE) keyName
{
    return [self deleteBuilderPartPrivate:type keyName:keyName container:propertiesOfContainer_];
}

#pragma mark builderResource and processor function...

/**
 指定传输内容，当前为json-string
 */
-(BOOL) setBuilderResource:(SYYJSONBUILDER_VAR_TYPE) resource
{
    BOOL isOk = NO;
    
    if (resource.instance_ != nil) {
        
        resource_ = resource.instance_;
        if (resource_ != nil)   isOk = YES;
    }
    
    return isOk;
}

/**
 得到json中指定键值的资源内容
 @param  resource   资源键值对字典
 @param  keyName    键值字符串
 */
-(id) getValueOfResourceFromKeyName: (NSDictionary*) resource keyName:(NSString*) keyName
{
    id sub_resource = nil;
    
    if (resource == nil || keyName == nil)
        return sub_resource;
    
    sub_resource = [resource objectForKey: keyName];
    
    return sub_resource;
}

/**
    得到键值处理器
 */
-(Class) getBuilderResourceProcessorPrivate: (NSString*) keyName
{
    __block Class class = nil;
    
    if (keyName == nil | keyName.length == 0)   return class;
    
    [classWithKeyName_ enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL* stop){
        
        if ([keyName isEqualToString:key]) {
            
            class = NSClassFromString(object);
            *stop=YES;
        }
    }];
    
    return class;
}

-(BOOL) addBuilderResourceProcessorPrivate:(SYYJSONBUILDER_VAR_TYPE) type
                                   keyName: (SYYJSONBUILDER_VAR_TYPE) keyName
                                 container: (NSMutableDictionary*) container
{
    BOOL isOk = NO;
    if(type.className_ != nil && keyName.jsonKeyName_ != nil){
        
        [container setObject:type.className_ forKey:keyName.jsonKeyName_];
        isOk = YES;
    }
    return isOk;
}

-(BOOL) addBuilderResourceProcessor:(SYYJSONBUILDER_VAR_TYPE)type
                            keyName:(SYYJSONBUILDER_VAR_TYPE)keyName
{
    return [self addBuilderResourceProcessorPrivate:type
                                            keyName:keyName
                                          container: classWithKeyName_];
}

#pragma mark encodeJsonToObject function...

/**
    转化json到指定数据类中
    @param  class       指定类
    @param  resource    对应json资源，该资源必须为NSDictionary
    @return id  返回实例化的对象
 */
-(id) encodeJSonToObjectPrivate:(Class) class
                       resource: (id) resource
{
    
    id object = [[class alloc] init];
    NSDictionary* keyNameWithValue = [self _getPropertyListFromObject:class];

    [keyNameWithValue enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL* stop){
        //key = variable name   value = className
        NSString* propertyName = (NSString*) key;
        NSString* className = (NSString*) value;
        id sub_resource = [self getValueOfResourceFromKeyName:resource keyName:propertyName];
        id tmp_obj = nil;
        
        if (sub_resource != nil) {
        
            int classType = [self _getObjectCollectionType:className];
            switch (classType) {
                case SYYJSON_NSARRAY_TYPE:
                
                    if ([sub_resource isKindOfClass:[NSArray class]]) {
                    
                        tmp_obj = [[NSMutableArray alloc] init];
                        [sub_resource enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop){
                        
                            Class arrayItemClass = [self getBuilderResourceProcessorPrivate:propertyName];
                            id tmp_idx_obj = [self encodeJSonToObjectPrivate:arrayItemClass resource:obj];
                            if (tmp_idx_obj != nil) [tmp_obj addObject:tmp_idx_obj];
                        }];
                
                        [self _setObjectPropertyValue:object propertyName:propertyName value:tmp_obj];
                    }
                    break;
                case SYYJSON_ABTRACT_OBJECT_TYPE:
                
                    tmp_obj = [self encodeJSonToObjectPrivate:NSClassFromString(className)
                                                     resource:sub_resource];
                    
                    [self _setObjectPropertyValue:object propertyName:propertyName value:tmp_obj];
                
                    break;
                case SYYJSON_NULL_TYPE:
               
                    [object setValue:sub_resource forKey:propertyName];
                
                    break;
                default:
                    break;
            }
        }
    }];
    
    return object;
}

#pragma mark buildAndGetResult function...

-(id) getResult
{
    //add some new property
    [self addBuilderPropertyIntoContainerPrivate:container_
                                availableKeyName: propertiesOfContainer_];
    //encode the json to object
    return [self encodeJSonToObjectPrivate:container_ resource:resource_];
}

@end
