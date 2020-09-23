//
//  ViewController.m
//  RuntimeDemo
//
//  Created by admin on 2018/2/27.
//  Copyright © 2018年 admin. All rights reserved.
//


/*
 1.什么是runtime?
 runtime是一套底层的C语言API，包含很多强大实用的C语言数据类型和C语言函数，平时我们编写的OC代码，底层都是基于runtime实现的。
 2.runtime有什么作用？
 可以动态产生(修改,删除)一个类,一个成员变量,一个方法
 3.常用的头文件
 #import <objc/runtime.h> 包含对类、成员变量、属性、方法的操作
 #import <objc/message.h> 包含消息机制
 4.常用方法
 class_copyIvarList（）返回一个指向类的成员变量数组的指针
 class_copyPropertyList（）返回一个指向类的属性数组的指针
 注意：根据Apple官方runtime.h文档所示，上面两个方法返回的指针，在使用完毕之后必须free()。
 ivar_getName（）获取成员变量名-->C类型的字符串
 property_getName（）获取属性名-->C类型的字符串
 -------------------------------------
 typedef struct objc_method *Method;
 class_getInstanceMethod（）
 class_getClassMethod（）以上两个函数传入返回Method类型
 ---------------------------------------------------
 method_exchangeImplementations（）交换两个方法的实现
 5.runtime在开发中的用途
 1.动态的遍历一个类的所有成员变量,用于字典转模型,归档解档操作
 代码如下：
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 
 // 利用runtime遍历一个类的全部成员变量
 1.导入头文件<objc/runtime.h>
 
 unsigned int count = 0;
 //  Ivar:表示成员变量类型
 Ivar *ivars = class_copyIvarList([PersonModel class], &count);获得一个指向该类成员变量的指针
 for (int i =0; i < count; i ++) {
 // 获得Ivar
 Ivar ivar = ivars[i];
 // 根据ivar获得其成员变量的名称--->C语言的字符串
 const char *name = ivar_getName(ivar);
 NSString *key = [NSString stringWithUTF8String:name];
 NSLog(@"%d----%@",i,key);
 }
 
 */
#import "ViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "Person.h"
#import "NSObject+Property.h"
#import "NSObject+Category.h"
#import "NSMutableArray+Category.h"
@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *arrM;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.arrM = [[NSMutableArray alloc]init];
    [self changeMethod1];
    [self changeMethod2];
    [self messageForward];
    [self addMethodForCategory];
    [self model];
    [self addPropertyForCategory];
    [self getIvar];
    [self getProperty];
    [self getMethods];
    [self getProtcol];
}
//交换加载图片的方法
-(void)changeMethod1{
    UIImage * image = [UIImage imageNamed:@"cq"];
    NSLog(@"%@",image);
}
//消息转发
-(void)messageForward{
    
    Person * person = [[Person alloc]init];
  ((void (*) (id,SEL))(void *)objc_msgSend)(person,@selector(eat));
((void (*) (id,SEL))(void *)objc_msgSend)([Person class],@selector(eat1));
}

-(void)changeMethod2{
    //数组字典添加空对象不崩溃
    [self.arrM addObject:nil];
  
}

//動態添加方法
-(void)addMethodForCategory{
    Person * person = [[Person alloc]init];
    
    [person performSelector:@selector(eat)];
}

// 字典转模型
-(void)model
{
    NSDictionary *dic=@{
                        @"name":@"machiel",
                        @"sex":@"女"
                        };
    Person *personModel=[Person modelWithDict:dic];
}

// 給分類添加屬性
-(void)addPropertyForCategory{
    NSObject *object = [[NSObject alloc]init];
    object.name = @"machiel";
}

//獲取該類遵循的全部協議
-(void)getProtcol{
    unsigned int count;
    __unsafe_unretained Protocol ** protocols = class_copyProtocolList([self class], &count);
    for (int i = 0; i < count; ++i) {
        Protocol *protocol = protocols[i];
        
        const char *name = protocol_getName(protocol);
        NSString * protocolName = [NSString stringWithUTF8String:name];
        NSLog(@"%@",protocolName);
    }
    free(protocols);
}

// 獲取類的全部方法
-(void)getMethods{
    unsigned int count;
    Method * methods = class_copyMethodList([self class], &count);
    for (int i = 0; i < count; ++i) {
        Method method = methods[i];
        SEL methodSEL = method_getName(method);
        const char * name = sel_getName(methodSEL);
        NSString * methodName = [NSString stringWithUTF8String:name];
        
        int args = method_getNumberOfArguments(method);
        
        NSLog(@"%@===%d",methodName,args);
        
    }
}
//獲取該類的所有屬性
-(void)getProperty{
    unsigned int count;
    objc_property_t * properties =class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        NSString * key = [NSString stringWithUTF8String:name];
        NSLog(@"%@",key);
    }
    free(properties);
}

// 獲取成員變量
-(void)getIvar{
    unsigned int count;
    Ivar * ivars = class_copyIvarList([self class], &count);
    for (NSInteger i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        //根據變量的指針生成C字符串
        const char * name = ivar_getName(ivar);
        //根據C 的字符串生成OC字符串
        NSString * key = [NSString stringWithUTF8String:name];
        NSLog(@"%d====%@",i,key);
    }
    free(ivars);
}

/**
 歸檔解檔
 */
-(void)ArchiverTest{
    
    Person * person = [[Person alloc]init];
    person.name = @"Machiel";
    person.sex = @"man";
    person.age = 26;
    person.height = 201;
    //歸檔
    NSString * path = [NSString stringWithFormat:@"%@",NSHomeDirectory()];
    NSString *archivePath = [path stringByAppendingPathComponent:@"/archive"];
    [NSKeyedArchiver archiveRootObject:person toFile:archivePath];
    NSLog(@"%@",archivePath);
    //解檔
    Person * person2 = [NSKeyedUnarchiver  unarchiveObjectWithFile:archivePath];
    NSLog(@"%@====%@",person2,archivePath);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
