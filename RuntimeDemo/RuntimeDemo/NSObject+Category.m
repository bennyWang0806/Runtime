//
//  NSObject+Category.m
//  RuntimeDemo
//
//  Created by admin on 2018/2/27.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "NSObject+Category.h"
#import <objc/runtime.h>
@implementation NSObject (Category)
+(instancetype)modelWithDict:(NSDictionary *)dict{
    id  obj = [[self alloc]init];
    for (NSString * propertyName in [self PropertyList]) {
        if (dict[propertyName]) {
            [obj setValue:dict[propertyName] forKey:propertyName];
        }
    }

    return obj;
}
+(NSArray *)PropertyList{
    NSMutableArray * mutableArr = [[NSMutableArray alloc]init];
    unsigned int count;
    objc_property_t * properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; ++i) {
        objc_property_t property =properties[i];
        const char * name = property_getName(property);
        NSString * propertyName = [NSString stringWithUTF8String:name];
        [mutableArr addObject:propertyName];
    }
    return mutableArr.copy;
}
@end
