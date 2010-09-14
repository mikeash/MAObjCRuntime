
#import "RTMethod.h"


@interface _RTObjCMethod : RTMethod
{
    Method _m;
}

@end

@implementation _RTObjCMethod

- (id)initWithObjCMethod: (Method)method
{
    if((self = [self init]))
    {
        _m = method;
    }
    return self;
}

- (SEL)selector
{
    return method_getName(_m);
}

- (IMP)implementation
{
    return method_getImplementation(_m);
}

- (NSMethodSignature *)signature
{
    return [NSMethodSignature signatureWithObjCTypes: method_getTypeEncoding(_m)];
}

@end

@implementation RTMethod

+ (id)methodWithObjCMethod: (Method)method
{
    return [[[self alloc] initWithObjCMethod: method] autorelease];
}

- (id)initWithObjCMethod: (Method)method
{
    [self release];
    return [[_RTObjCMethod alloc] initWithObjCMethod: method];
}

- (SEL)selector
{
    [self doesNotRecognizeSelector: _cmd];
    return NULL;
}

- (IMP)implementation
{
    [self doesNotRecognizeSelector: _cmd];
    return NULL;
}

- (NSMethodSignature *)signature
{
    [self doesNotRecognizeSelector: _cmd];
    return NULL;
}

@end
