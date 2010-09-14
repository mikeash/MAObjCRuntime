
#import <Foundation/Foundation.h>


@interface NSObject (MARuntime)

// includes the receiver
+ (NSArray *)rt_subclasses;

+ (Class)rt_createSubclassNamed: (NSString *)name;
+ (void)rt_destroyClass;

+ (BOOL)rt_isMetaClass;
+ (Class)rt_setSuperclass: (Class)newSuperclass;
+ (size_t)rt_instanceSize;

+ (NSArray *)rt_methods;

- (Class)rt_class;
- (Class)rt_setClass: (Class)newClass;

@end
