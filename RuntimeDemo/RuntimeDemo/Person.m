//
//  Person.m
//  RuntimeDemo
//
//  Created by admin on 2018/2/27.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
#import <objc/message.h>
@interface Person()<NSCoding>

@end

@implementation Person

-(void)encodeWithCoder:(NSCoder *)aCoder{
    unsigned int count;
    objc_property_t * properties = class_copyPropertyList([self class], &count);
    for (NSInteger i = 0; i < count; i++) {
        objc_property_t  property = properties[i];
        //獲取C字符串屬性名
        const char * name = property_getName(property);
        //C字符串轉成OC字符串
        NSString * propertyName = [NSString stringWithUTF8String:name];
        //通過屬性key 取值
        NSString * propertyVaule = [self valueForKey:propertyName];
        //利用kvc 取出值
        [aCoder encodeObject:propertyVaule forKey:propertyName];
    }
    //釋放
    free(properties);
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    unsigned int count;
    
    //獲取當前類的所有屬性指針
    objc_property_t * properyies =class_copyPropertyList([self class], &count);
    for (NSInteger i = 0; i < count; i++) {

        objc_property_t property = properyies[i];
        //通過屬性的指針獲取C字符串屬性名
        const char * name = property_getName(property);
        //C字符串轉成OC字符串
        NSString * propertyName = [NSString stringWithUTF8String:name];
        //解檔
        NSString * propertyValue = [aDecoder decodeObjectForKey:propertyName];
        [self setValue:propertyValue forKey:propertyName];
    }
    return self;
}

+(void)eat1{
    
}
//-(void)eat{
//
//}
-(void)sleep{
    
}
-(void)work{
    
}

void eat (id self,SEL sel){
    
}

+(BOOL)resolveInstanceMethod:(SEL)sel{
    if (sel == @selector(eat)) {
        class_addMethod([self class], @selector(eat), eat, "v@:");
    }
    return [super resolveInstanceMethod:sel];
}







@end
