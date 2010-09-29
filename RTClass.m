
#import "RTClass.h"

#import "MARuntime.h"
#import "RTProtocol.h"
#import "RTIvar.h"
#import "RTProperty.h"
#import "RTMethod.h"


@implementation RTClass

+ (id)classWithObjCClass: (Class)class
{
    return [[[self alloc] initWithObjCClass: class] autorelease];
}

- (id)initWithObjCClass: (Class)class
{
    if((self = [super init]))
    {
        if(!class || class_isMetaClass(class))
        {
            [self release];
            return nil;
        }
        _class = class;
        _metaclass = object_getClass(class);
    }
    return self;
}

- (Class)objCClass
{
    return _class;
}

- (void)destroyClass
{
    objc_disposeClassPair(_class);
}

- (NSString *)name
{
    return [NSString stringWithCString: class_getName(_class) encoding: [NSString defaultCStringEncoding]];
}

- (RTClass *)superclass
{
    return [[self class] classWithObjCClass: class_getSuperclass(_class)];
}

#ifdef __clang__
#pragma clang diagnostic push
#endif
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
- (RTClass *)setSuperclass: (RTClass *)newSuperclass
{
    return [[self class] classWithObjCClass: class_setSuperclass(_class, [newSuperclass objCClass])];
}
#ifdef __clang__
#pragma clang diagnostic pop
#endif

- (NSArray *)subclasses
{
    NSMutableArray *array = [NSMutableArray array];
    for(RTClass *candidate in [MARuntime classes])
    {
        if([[candidate superclass] isEqual: self])
        {
            [array addObject: candidate];
        }
    }
    return array;
}

- (size_t)instanceSize
{
    return class_getInstanceSize(_class);
}

- (NSArray *)protocols
{
    unsigned int count;
    Protocol **protocols = class_copyProtocolList(_class, &count);
    
    NSMutableArray *array = [NSMutableArray array];
    for(unsigned i = 0; i < count; i++)
        [array addObject: [RTProtocol protocolWithObjCProtocol: protocols[i]]];
    
    free(protocols);
    return array;
}

- (NSArray *)classVariables
{
    unsigned int count;
    Ivar *list = class_copyIvarList(_metaclass, &count);
    
    NSMutableArray *array = [NSMutableArray array];
    for(unsigned i = 0; i < count; i++)
        [array addObject: [RTIvar ivarWithObjCIvar: list[i]]];
    
    free(list);
    return array;
}

- (RTIvar *)classVariableNamed: (NSString *)name
{
    return [RTIvar ivarWithObjCIvar: class_getInstanceVariable(_metaclass, [name cStringUsingEncoding: [NSString defaultCStringEncoding]])];
}

- (NSArray *)instanceVariables
{
    unsigned int count;
    Ivar *list = class_copyIvarList(_class, &count);
    
    NSMutableArray *array = [NSMutableArray array];
    for(unsigned i = 0; i < count; i++)
        [array addObject: [RTIvar ivarWithObjCIvar: list[i]]];
    
    free(list);
    return array;
}

- (RTIvar *)instanceVariableNamed: (NSString *)name
{
    Ivar ivar = class_getInstanceVariable(_class, [name cStringUsingEncoding: [NSString defaultCStringEncoding]]);
    if(!ivar) return nil;

    return [RTIvar ivarWithObjCIvar: ivar];
}

- (NSArray *)properties
{
    unsigned int count;
    objc_property_t *list = class_copyPropertyList(_class, &count);
    
    NSMutableArray *array = [NSMutableArray array];
    for(unsigned i = 0; i < count; i++)
        [array addObject: [RTProperty propertyWithObjCProperty: list[i]]];
    
    free(list);
    return array;
}

- (RTProperty *)propertyNamed: (NSString *)name
{
    objc_property_t property = class_getProperty(_class, [name cStringUsingEncoding: [NSString defaultCStringEncoding]]);
    if(!property) return nil;

    return [RTProperty propertyWithObjCProperty: property];
}

- (NSArray *)classMethods
{
    unsigned int count;
    Method *methods = class_copyMethodList(_metaclass, &count);
    
    NSMutableArray *array = [NSMutableArray array];
    for(unsigned i = 0; i < count; i++)
        [array addObject: [RTMethod methodWithObjCMethod: methods[i]]];
    
    free(methods);
    return array;
}

- (RTMethod *)classMethodForSelector: (SEL)selector
{
    Method method = class_getClassMethod(_class, selector);
    if(!method) return nil;
    
    return [RTMethod methodWithObjCMethod: method];
}

- (void)addClassMethod: (RTMethod *)method
{
    class_addMethod(_metaclass, [method selector], [method implementation], [[method signature] cStringUsingEncoding:[NSString defaultCStringEncoding]]);
}

- (NSArray *)instanceMethods
{
    unsigned int count;
    Method *methods = class_copyMethodList(_class, &count);
    
    NSMutableArray *array = [NSMutableArray array];
    for(unsigned i = 0; i < count; i++)
        [array addObject: [RTMethod methodWithObjCMethod: methods[i]]];
    
    free(methods);
    return array;
}

- (RTMethod *)instanceMethodForSelector: (SEL)selector
{
    RTMethod *method = [RTMethod methodWithObjCMethod: class_getInstanceMethod(_class, selector)];
    if(!method) return nil;
    
    return method;
}

- (void)addInstanceMethod: (RTMethod *)method
{
    class_addMethod(_class, [method selector], [method implementation], [[method signature] cStringUsingEncoding:[NSString defaultCStringEncoding]]);
}

- (BOOL)isEqual: (id)other
{
    return [other isKindOfClass: [RTClass class]] &&
           [[self name] isEqual: [other name]];
}

@end
