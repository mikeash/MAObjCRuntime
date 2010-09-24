
#import "RTUnregisteredClass.h"

#import "RTProtocol.h"
#import "RTIvar.h"
#import "RTMethod.h"


@implementation RTUnregisteredClass

+ (id)unregisteredClassWithClass: (Class)c
{
    return [[[self alloc] initWithClass: c] autorelease];
}

- (id)initWithClass: (Class)c
{
    if((self = [self init]))
    {
        _class = c;
    }
    return self;
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

- (Class)registerClass
{
    objc_registerClassPair(_class);
    return _class;
}

@end
