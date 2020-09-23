//
//  NSObject+Category.h
//  RuntimeDemo
//
//  Created by admin on 2018/2/27.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Category)
//字典轉模型
+(instancetype)modelWithDict:(NSDictionary *)dict;
@end
