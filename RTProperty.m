
#import "RTProperty.h"


@interface _RTObjCProperty : RTProperty
{
    objc_property_t _property;
}
@end

@implementation _RTObjCProperty

- (id)initWithObjCProperty: (objc_property_t)property
{
    if((self = [self init]))
    {
        _property = property;
    }
    return self;
}
- (NSString *)name
{
    return [NSString stringWithUTF8String: property_getName(_property)];
}

- (NSString *)typeEncoding
{
    return [NSString stringWithUTF8String: property_getTypeEncoding(_property)];
}

@end

@interface _RTComponentsProperty : RTProperty
{
    NSString *_name;
    NSString *_typeEncoding;
}
@end

@implementation _RTComponentsProperty

- (id)initWithName: (NSString *)name typeEncoding: (NSString *)typeEncoding
{
    if((self = [self init]))
    {
        _name = [name copy];
        _typeEncoding = [typeEncoding copy];
    }
    return self;
}

- (void)dealloc
{
    [_name release];
    [_typeEncoding release];
    [super dealloc];
}

- (NSString *)name
{
    return _name;
}

- (NSString *)typeEncoding
{
    return _typeEncoding;
}

@end

@implementation RTProperty

+ (id)propertyWithObjCProperty: (objc_property_t)property
{
    return [[[self alloc] initWithObjCProperty: property] autorelease];
}

+ (id)propertyWithName: (NSString *)name typeEncoding: (NSString *)typeEncoding
{
    return [[[self alloc] initWithName: name typeEncoding: typeEncoding] autorelease];
}

+ (id)propertyWithName: (NSString *)name encode: (const char *)encodeStr
{
    return [self propertyWithName: name typeEncoding: [NSString stringWithUTF8String: encodeStr]];
}

- (id)initWithObjCProperty: (objc_property_t)property
{
    [self release];
    return [[_RTObjCProperty alloc] initWithObjCProperty: property];
}

- (id)initWithName: (NSString *)name typeEncoding: (NSString *)typeEncoding
{
    return [[_RTComponentsProperty alloc] initWithName: name typeEncoding: typeEncoding];
}

- (NSString *)description
{
    return [NSString stringWithFormat: @"<%@ %p: %@ %@>", [self class], self, [self name], [self typeEncoding]];
}

- (BOOL)isEqual: (id)other
{
    return [other isKindOfClass: [RTProperty class]] &&
           [[self name] isEqual: [other name]] &&
           [[self typeEncoding] isEqual: [other typeEncoding]];
}

- (NSUInteger)hash
{
    return [[self name] hash] ^ [[self typeEncoding] hash];
}

- (NSString *)name
{
    [self doesNotRecognizeSelector: _cmd];
    return nil;
}

- (NSString *)typeEncoding
{
    [self doesNotRecognizeSelector: _cmd];
    return nil;
}

@end
