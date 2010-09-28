
#import "MARTNSObject.h"

#import <objc/runtime.h>

#import "RTClass.h"
#import "RTProtocol.h"
#import "RTIvar.h"
#import "RTProperty.h"
#import "RTMethod.h"
#import "RTUnregisteredClass.h"


@implementation NSObject (MARuntime)

+ (NSArray *)rt_subclasses
{
    return [[RTClass classWithObjCClass: self] subclasses];
}

+ (RTUnregisteredClass *)rt_createUnregisteredSubclassNamed: (NSString *)name
{
    return [RTUnregisteredClass unregisteredClassWithName: name withSuperclass: [RTClass classWithObjCClass: self]];
}

+ (RTClass *)rt_createSubclassNamed: (NSString *)name
{
    return [[self rt_createUnregisteredSubclassNamed: name] registerClass];
}

+ (BOOL)rt_isMetaClass
{
    return class_isMetaClass(self);
}

+ (RTClass *)rt_setSuperclass: (RTClass *)newSuperclass
{
    return [[RTClass classWithObjCClass: self] setSuperclass: newSuperclass];
}

+ (size_t)rt_instanceSize
{
    return [[RTClass classWithObjCClass: self] instanceSize];
}

+ (NSArray *)rt_protocols
{
    return [[RTClass classWithObjCClass: self] protocols];
}

+ (NSArray *)rt_classMethods
{
    return [[RTClass classWithObjCClass: self] classMethods];
}

+ (NSArray *)rt_instanceMethods
{
    return [[RTClass classWithObjCClass: self] instanceMethods];
}

+ (RTMethod *)rt_classMethodForSelector: (SEL)sel
{
    return [[RTClass classWithObjCClass: self] classMethodForSelector: sel];
}

+ (RTMethod *)rt_instanceMethodForSelector: (SEL)sel
{
    return [[RTClass classWithObjCClass: self] instanceMethodForSelector: sel];
}

+ (void)rt_addClassMethod: (RTMethod *)method
{
    [[RTClass classWithObjCClass: self] addClassMethod: method];
}

+ (void)rt_addInstanceMethod: (RTMethod *)method
{
    [[RTClass classWithObjCClass: self] addInstanceMethod: method];
}

+ (NSArray *)rt_ivars
{
    return [[RTClass classWithObjCClass: self] instanceVariables];
}

+ (RTIvar *)rt_ivarForName: (NSString *)name
{
    return [[RTClass classWithObjCClass: self] instanceVariableNamed: name];
}

+ (NSArray *)rt_properties
{
    return [(RTClass *)[RTClass classWithObjCClass: self] properties];
}

+ (RTProperty *)rt_propertyForName: (NSString *)name
{
    return [[RTClass classWithObjCClass: self] propertyNamed: name];
}

- (Class)rt_class
{
    return object_getClass(self);
}

- (Class)rt_setClass: (Class)newClass
{
    return object_setClass(self, newClass);
}

@end

