//
//  UIImage+image.m
//  RuntimeDemo
//
//  Created by admin on 2018/2/27.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "UIImage+image.h"
#import <objc/runtime.h>
@implementation UIImage (image)
//load預加載
+(void)load{
    Method imageNamed =class_getClassMethod([self class], @selector(imageNamed:));
    Method imageWithName = class_getClassMethod([self class], @selector(imageWithName:));
    method_exchangeImplementations(imageNamed, imageWithName);
}

+(instancetype)imageWithName:(NSString *)name{
    //防止循环调用,这里其实是调用imageName:
    UIImage *image = [self imageWithName:name];
    if (image) {
        NSLog(@"图片为空");
    }
    return image;
}
@end
