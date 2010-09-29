
#import "RTUnregisteredClass.h"

#import "RTClass.h"
#import "RTProtocol.h"
#import "RTIvar.h"
#import "RTMethod.h"


@implementation RTUnregisteredClass

+ (id)unregisteredClassWithName: (NSString *)name withSuperclass: (RTClass *)superclassOrNil
{
    return [[[self alloc] initWithName: name withSuperclass: superclassOrNil] autorelease];
}

+ (id)unregisteredClassWithName: (NSString *)name
{
    return [self unregisteredClassWithName: name withSuperclass: nil];
}

- (id)initWithName: (NSString *)name withSuperclass: (RTClass *)superclassOrNil
{
    if((self = [self init]))
    {
        Class superclass = Nil;
        if(superclassOrNil)
        {
            superclass = [superclassOrNil objCClass];
        }
        _class = objc_allocateClassPair(superclass, [name UTF8String], 0);
        if(_class == Nil)
        {
            [self release];
            return nil;
        }
    }
    return self;
}

- (id)initWithName: (NSString *)name
{
    return [self initWithName: name withSuperclass: nil];
}

- (void)addProtocol: (RTProtocol *)protocol
{
    class_addProtocol(_class, [protocol objCProtocol]);
}

- (void)addIvar: (RTIvar *)ivar
{
    const char *typeStr = [[ivar typeEncoding] UTF8String];
    NSUInteger size, alignment;
    NSGetSizeAndAlignment(typeStr, &size, &alignment);
    class_addIvar(_class, [[ivar name] UTF8String], size, log2(alignment), typeStr);
}

- (void)addMethod: (RTMethod *)method
{
    class_addMethod(_class, [method selector], [method implementation], [[method signature] UTF8String]);
}

- (RTClass *)registerClass
{
    objc_registerClassPair(_class);
    return [RTClass classWithObjCClass: _class];
}

@end
