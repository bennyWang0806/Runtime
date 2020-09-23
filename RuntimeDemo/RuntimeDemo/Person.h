//
//  Person.h
//  RuntimeDemo
//
//  Created by admin on 2018/2/27.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *sex;
@property(nonatomic,assign)int age;
@property(nonatomic,assign)float height;
+(void)eat1;
-(void)eat;
-(void)sleep;
-(void)work;
@end
