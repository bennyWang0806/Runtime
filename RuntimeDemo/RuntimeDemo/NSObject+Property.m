//
//  NSObject+Property.m
//  RuntimeDemo
//
//  Created by admin on 2018/2/27.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "NSObject+Property.h"
#import <objc/runtime.h>
static const char * key = "name";
@implementation NSObject (Property)

-(NSString *)name{
 return   objc_getAssociatedObject(self, key);
}

-(void)setName:(NSString *)name{
    objc_setAssociatedObject(self, key, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
