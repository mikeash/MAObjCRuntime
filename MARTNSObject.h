
#import <Foundation/Foundation.h>


@class RTIvar;
@class RTMethod;
@class RTUnregisteredClass;

@interface NSObject (MARuntime)

// includes the receiver
+ (NSArray *)rt_subclasses;

+ (RTUnregisteredClass *)rt_createUnregisteredSubclassNamed: (NSString *)name;
+ (Class)rt_createSubclassNamed: (NSString *)name;
+ (void)rt_destroyClass;

+ (BOOL)rt_isMetaClass;
+ (Class)rt_setSuperclass: (Class)newSuperclass;
+ (size_t)rt_instanceSize;

+ (NSArray *)rt_methods;
+ (RTMethod *)rt_methodForSelector: (SEL)sel;

+ (void)rt_addMethod: (RTMethod *)method;

+ (NSArray *)rt_ivars;
+ (RTIvar *)rt_ivarForName: (NSString *)name;

- (Class)rt_class;
- (Class)rt_setClass: (Class)newClass;

@end
