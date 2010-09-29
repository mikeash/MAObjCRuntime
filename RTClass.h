
#import <Foundation/Foundation.h>


@class RTProtocol;
@class RTIvar;
@class RTProperty;
@class RTMethod;

@interface RTClass : NSObject
{
    Class _class;
    Class _metaclass;
}

+ (id)classWithObjCClass: (Class)class;

- (id)initWithObjCClass: (Class)class;

- (Class)objCClass;
- (void)destroyClass;

- (NSString *)name;
- (RTClass *)superclass;
- (RTClass *)setSuperclass: (RTClass *)newSuperclass;
- (NSArray *)subclasses;
- (size_t)instanceSize;

- (NSArray *)protocols;

- (NSArray *)classVariables;
- (RTIvar *)classVariableNamed: (NSString *)name;
- (NSArray *)instanceVariables;
- (RTIvar *)instanceVariableNamed: (NSString *)name;

- (NSArray *)properties;
- (RTProperty *)propertyNamed: (NSString *)name;

- (NSArray *)classMethods;//does not search superclasses
- (RTMethod *)classMethodForSelector: (SEL)selector;//searches superclasses
- (void)addClassMethod: (RTMethod *)method;

- (NSArray *)instanceMethods;//does not search superclasses
- (RTMethod *)instanceMethodForSelector: (SEL)selector;//searches superclasses
- (void)addInstanceMethod: (RTMethod *)method;

@end
