
#import <Foundation/Foundation.h>


@class RTClass;
@class RTProtocol;
@class RTIvar;
@class RTProperty;
@class RTMethod;
@class RTUnregisteredClass;

@interface NSObject (MARuntime)

// does not include the receiver
+ (NSArray *)rt_subclasses;

+ (RTUnregisteredClass *)rt_createUnregisteredSubclassNamed: (NSString *)name;
+ (RTClass *)rt_createSubclassNamed: (NSString *)name;

+ (BOOL)rt_isMetaClass;
+ (RTClass *)rt_setSuperclass: (RTClass *)newSuperclass;
+ (size_t)rt_instanceSize;

+ (NSArray *)rt_protocols;

+ (NSArray *)rt_classMethods;
+ (NSArray *)rt_instanceMethods;
+ (RTMethod *)rt_classMethodForSelector: (SEL)sel;
+ (RTMethod *)rt_instanceMethodForSelector: (SEL)sel;
+ (void)rt_addClassMethod: (RTMethod *)method;
+ (void)rt_addInstanceMethod: (RTMethod *)method;

+ (NSArray *)rt_ivars;
+ (RTIvar *)rt_ivarForName: (NSString *)name;

+ (NSArray *)rt_properties;
+ (RTProperty *)rt_propertyForName: (NSString *)name;

// Apple likes to fiddle with -class to hide their dynamic subclasses
// e.g. KVO subclasses, so [obj class] can lie to you
// rt_class is a direct call to object_getClass (which in turn
// directly hits up the isa) so it will always tell the truth
- (Class)rt_class;
- (Class)rt_setClass: (Class)newClass;

@end
