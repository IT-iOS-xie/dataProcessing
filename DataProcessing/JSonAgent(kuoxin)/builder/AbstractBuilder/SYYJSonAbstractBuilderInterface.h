//
//  SYYJSonBuilderInterface.h
//  SYY
//
//  Created by kuoxin on 7/5/16.
//  Copyright © 2016 cn.com.rockmobile. All rights reserved.
//

#ifndef __SYYJSonAbstractBuilderInterface_H_
#define __SYYJSonAbstractBuilderInterface_H_

/**
 指定当前使用的参数类型
 */
typedef union __uniSYYJSONBUILDER_VAR_TYPE{
    __unsafe_unretained NSString    *jsonKeyName_;   //!< json中键值
    __unsafe_unretained NSString    *classProperty_;  //!< 类的属性
    __unsafe_unretained NSString    *className_;     //!<  类名
    __unsafe_unretained id          instance_;        //!< 类名或实例名
} SYYJSONBUILDER_VAR_TYPE;

#define MAX_BUF_SIZE    256

/// 预编译 创建构造器
#define CREATE_JSON_TO_OBJECT_BUILDER(builder)  builder=[[SYYJSonToObjectBuilder alloc] init]

/// 设置容器对应资源键值
#define SET_BUILDER_CONTAINER(builder, className)    \
    SYYJSONBUILDER_VAR_TYPE container;  \
    container.className_ = className; \
    [builder buildContainer: container]

/// 设置资源
#define SET_BUILDER_RESOURCE(builder, resource) \
    SYYJSONBUILDER_VAR_TYPE res;   \
    res.instance_ = resource;    \
    [builder setBuilderResource:res]

/// 填写对应键值在资源中的key
#define ADD_BUILDER_RESOURCE_PROCESSOR(builder, class, key)     \
    {   \
        SYYJSONBUILDER_VAR_TYPE rt;  \
        SYYJSONBUILDER_VAR_TYPE rk;   \
        rt.className_ = class;    \
        rk.jsonKeyName_ = key;    \
        [builder addBuilderResourceProcessor:rt keyName:rk]; \
    }

/// 输出对象
#define GET_RESULT(builder) [builder getResult]

/// 枚举 定义资源类型
typedef enum __enuSYYJSON_COLLECTION_TYPE: NSUInteger {
    SYYJSON_NULL_TYPE,    //!< 空
    SYYJSON_NSARRAY_TYPE,  //!< 数组类型
    SYYJSON_ABTRACT_OBJECT_TYPE  //!< 对象类型
} SYYJSON_COLLECTION_TYPE;

@protocol SYYJSonAbstractBuilderInterface

/**
 初始化一个builder使用参数，该功能将生成相应类型的对象返回
 @param container  指定基础容器类型
 @return BOOL   YES表示成功，NO表示失败
 */
-(BOOL) buildContainer: (SYYJSONBUILDER_VAR_TYPE) container;

/**
 加入一个新的属性
 @param type    指定需要生成类名
 @param keyName 需要生成的对象变量名或键值
 @return BOOL   YES表示成功，NO表示失败
 */
-(BOOL) addBuilderPart:(SYYJSONBUILDER_VAR_TYPE)type
               keyName: (SYYJSONBUILDER_VAR_TYPE) keyName;

/**
 删除一个属性,但是不能删除容器类的属性
 初始化一个builder使用参数，该功能将生成相应类型的对象返回
 @param type    指定需要生成类名
 @param keyName 需要生成的对象变量名或键值
 @return BOOL   YES表示成功，NO表示失败
 */
-(BOOL) deleteBuilderPart:(SYYJSONBUILDER_VAR_TYPE)type
                  keyName: (SYYJSONBUILDER_VAR_TYPE) keyName;

/**
 指定builder使用的资源
 @param resource   该类型具体实现的builder确定
 @return BOOL   YES为有效资源，NO资源无效
 */
-(BOOL) setBuilderResource:(SYYJSONBUILDER_VAR_TYPE)resource;

/**
 指定json中相应的键值所对应的类型
 @param type    指定需要生成类名
 @param keyName 需要生成的对象变量名或键值
 @return BOOL   YES为有效资源，NO资源无效
 */
-(BOOL) addBuilderResourceProcessor:(SYYJSONBUILDER_VAR_TYPE)type
                            keyName:(SYYJSONBUILDER_VAR_TYPE)keyName;

/**
 生成需要返回的对象实例
 @return 返回实例
 */
-(id) getResult;

@end


#endif /* __SYYJSonAbstractBuilderInterface_H_ */
