
#import <Foundation/Foundation.h>


@class RTMethod;

@interface NSObject (MARuntime)

// includes the receiver
+ (NSArray *)rt_subclasses;

+ (Class)rt_createSubclassNamed: (NSString *)name;
+ (void)rt_destroyClass;

+ (BOOL)rt_isMetaClass;
+ (Class)rt_setSuperclass: (Class)newSuperclass;
+ (size_t)rt_instanceSize;

+ (NSArray *)rt_methods;

+ (void)rt_addMethod: (RTMethod *)method;

- (Class)rt_class;
- (Class)rt_setClass: (Class)newClass;

@end
