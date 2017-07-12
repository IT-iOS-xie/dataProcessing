//
//  SYYJSonAgentController.h
//  SYY
//
//  Created by kuoxin on 16/7/1.
//  Copyright © 2016年 cn.com.rockmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYYJSonAbstractBuilder.h"

/**
 *   提供通用的json到对象的生成器，该类只试用于网路访问返回的应答json解析
 */
@interface SYYJSonToObjectBuilder : SYYJSonAbstractBuilder
{
    @protected
    ///存储指定的返回类信息
    Class     container_;
    
    ///存储json字典键值<keyName: ClassName>
    NSMutableDictionary *classWithKeyName_;
    
    ///存储需要加入到容器类中的属性 <propertyName: ClassName>
    NSMutableDictionary *propertiesOfContainer_;
    
    ///存储json源内容
    NSDictionary*  resource_;
}

@end
















