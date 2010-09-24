
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

- (NSString *)attributeEncodings
{
    NSString *attributes = [NSString stringWithUTF8String: property_getAttributes(_property)];
    NSRange range = [attributes rangeOfString:@","];
    NSUInteger loc = range.location + range.length;
    range = [attributes rangeOfString:@",V"];
    NSUInteger len = range.location - loc;
    return [attributes substringWithRange:NSMakeRange(loc, len)];
}

- (NSString *)typeEncoding
{
    NSString *attributes = [NSString stringWithUTF8String: property_getAttributes(_property)];
    NSRange range = [attributes rangeOfString:@","];
    range.length = range.location - 1;
    range.location = 1;
    return [attributes substringWithRange:range];
}

- (NSString *)ivarName
{
    NSString *attributes = [NSString stringWithUTF8String: property_getAttributes(_property)];
    NSRange range = [attributes rangeOfString:@",V"];
    if(range.location == NSNotFound) return nil;
    return [attributes substringFromIndex:(range.location + range.length)];
}

@end

@implementation RTProperty

+ (id)propertyWithObjCProperty: (objc_property_t)property
{
    return [[[self alloc] initWithObjCProperty: property] autorelease];
}

- (id)initWithObjCProperty: (objc_property_t)property
{
    [self release];
    return [[_RTObjCProperty alloc] initWithObjCProperty: property];
}

- (NSString *)description
{
    return [NSString stringWithFormat: @"<%@ %p: %@ %@ %@ %@>", [self class], self, [self name], [self attributeEncodings], [self typeEncoding], [self ivarName]];
}

- (BOOL)isEqual: (id)other
{
    return [other isKindOfClass: [RTProperty class]] &&
           [[self name] isEqual: [other name]] &&
           ([self attributeEncodings] ? [[self attributeEncodings] isEqual: [other attributeEncodings]] : ![other attributeEncodings]) &&
           [[self typeEncoding] isEqual: [other typeEncoding]] &&
           ([self ivarName] ? [[self ivarName] isEqual: [other ivarName]] : ![other ivarName]);
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

- (NSString *)attributeEncodings
{
    [self doesNotRecognizeSelector: _cmd];
    return nil;
}

- (NSString *)typeEncoding
{
    [self doesNotRecognizeSelector: _cmd];
    return nil;
}

- (NSString *)ivarName
{
    [self doesNotRecognizeSelector: _cmd];
    return nil;
}

@end
