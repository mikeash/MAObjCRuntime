
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

- (NSString *)signature
{
    return [NSString stringWithUTF8String: method_getTypeEncoding(_m)];
}

- (void)setImplementation: (IMP)newImp
{
    method_setImplementation(_m, newImp);
}

@end

@interface _RTComponentsMethod : RTMethod
{
    SEL _sel;
    IMP _imp;
    NSString *_sig;
}

@end

@implementation _RTComponentsMethod

- (id)initWithSelector: (SEL)sel implementation: (IMP)imp signature: (NSString *)signature
{
    if((self = [self init]))
    {
        _sel = sel;
        _imp = imp;
        _sig = [signature copy];
    }
    return self;
}

- (void)dealloc
{
    [_sig release];
    [super dealloc];
}

- (SEL)selector
{
    return _sel;
}

- (IMP)implementation
{
    return _imp;
}

- (NSString *)signature
{
    return _sig;
}

- (void)setImplementation: (IMP)newImp
{
    _imp = newImp;
}

@end

@implementation RTMethod

+ (id)methodWithObjCMethod: (Method)method
{
    return [[[self alloc] initWithObjCMethod: method] autorelease];
}

+ (id)methodWithSelector: (SEL)sel implementation: (IMP)imp signature: (NSString *)signature
{
    return [[[self alloc] initWithSelector: sel implementation: imp signature: signature] autorelease];
}

- (id)initWithObjCMethod: (Method)method
{
    [self release];
    return [[_RTObjCMethod alloc] initWithObjCMethod: method];
}

- (id)initWithSelector: (SEL)sel implementation: (IMP)imp signature: (NSString *)signature
{
    [self release];
    return [[_RTComponentsMethod alloc] initWithSelector: sel implementation: imp signature: signature];
}

- (NSString *)description
{
    return [NSString stringWithFormat: @"<%@ %p: %@ %p %@>", [self class], self, NSStringFromSelector([self selector]), [self implementation], [self signature]];
}

- (BOOL)isEqual: (id)other
{
    return [other isKindOfClass: [RTMethod class]] &&
           [self selector] == [other selector] &&
           [self implementation] == [other implementation] &&
           [[self signature] isEqual: [other signature]];
}

- (NSUInteger)hash
{
    return (NSUInteger)[self selector] ^ (NSUInteger)[self implementation] ^ [[self signature] hash];
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

- (NSString *)signature
{
    [self doesNotRecognizeSelector: _cmd];
    return NULL;
}

- (void)setImplementation: (IMP)newImp
{
    [self doesNotRecognizeSelector: _cmd];
}

@end
