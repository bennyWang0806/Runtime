//
//  NSMutableArray+Category.m
//  RuntimeDemo
//
//  Created by admin on 2018/2/28.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "NSMutableArray+Category.h"
#import <objc/runtime.h>
@implementation NSMutableArray (Category)

+(void)load{
    Method orginMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(addObject:));
    Method newMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(change_addObject:));
    method_exchangeImplementations(orginMethod, newMethod);
}

-(void)change_addObject:(id)object{
    if (object) {
        [self change_addObject:object];
    }
}

@end
