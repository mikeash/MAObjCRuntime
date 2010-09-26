
#import "RTProperty.h"


@interface _RTObjCProperty : RTProperty
{
    objc_property_t _property;
    NSArray *_attributes;
}
@end

@implementation _RTObjCProperty

- (id)initWithObjCProperty: (objc_property_t)property
{
    if((self = [self init]))
    {
        _property = property;
        _attributes = [[[NSString stringWithUTF8String: property_getAttributes(property)] componentsSeparatedByString: @","] copy];
    }
    return self;
}

- (void)dealloc
{
    [_attributes release];
    [super dealloc];
}

- (NSString *)name
{
    return [NSString stringWithUTF8String: property_getName(_property)];
}

- (NSString *)attributeEncodings
{
    NSPredicate *filter = [NSPredicate predicateWithFormat: @"NOT (self BEGINSWITH 'T') AND NOT (self BEGINSWITH 'V')"];
    return [[_attributes filteredArrayUsingPredicate: filter] componentsJoinedByString: @","];
}

- (BOOL)hasAttribute: (NSString *)code
{
    for(NSString *encoded in _attributes)
        if([encoded hasPrefix: code]) return YES;
    return NO;
}

- (BOOL)isReadOnly
{
    return [self hasAttribute: @"R"];
}

- (RTPropertySetterSemantics)setterSemantics
{
    if([self hasAttribute: @"C"]) return RTPropertySetterSemanticsCopy;
    if([self hasAttribute: @"&"]) return RTPropertySetterSemanticsRetain;
    return RTPropertySetterSemanticsAssign;
}

- (BOOL)isNonAtomic
{
    return [self hasAttribute: @"N"];
}

- (BOOL)isDynamic
{
    return [self hasAttribute: @"D"];
}

- (BOOL)isWeakReference
{
    return [self hasAttribute: @"W"];
}

- (BOOL)isEligibleForGarbageCollection
{
    return [self hasAttribute: @"P"];
}

- (NSString *)contentOfAttribute: (NSString *)code
{
    for(NSString *encoded in _attributes)
        if([encoded hasPrefix: code]) return [encoded substringFromIndex: 1];
    return nil;
}

- (SEL)customGetter
{
    return NSSelectorFromString([self contentOfAttribute: @"G"]);
}

- (SEL)customSetter
{
    return NSSelectorFromString([self contentOfAttribute: @"G"]);
}

- (NSString *)typeEncoding
{
    return [self contentOfAttribute: @"T"];
}

- (NSString *)oldTypeEncoding
{
    return [self contentOfAttribute: @"t"];
}

- (NSString *)ivarName
{
    return [self contentOfAttribute: @"V"];
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

- (BOOL)isReadOnly
{
    [self doesNotRecognizeSelector: _cmd];
    return NO;
}
- (RTPropertySetterSemantics)setterSemantics
{
    [self doesNotRecognizeSelector: _cmd];
    return RTPropertySetterSemanticsAssign;
}

- (BOOL)isNonAtomic
{
    [self doesNotRecognizeSelector: _cmd];
    return NO;
}

- (BOOL)isDynamic
{
    [self doesNotRecognizeSelector: _cmd];
    return NO;
}

- (BOOL)isWeakReference
{
    [self doesNotRecognizeSelector: _cmd];
    return NO;
}

- (BOOL)isEligibleForGarbageCollection
{
    [self doesNotRecognizeSelector: _cmd];
    return NO;
}

- (SEL)customGetter
{
    [self doesNotRecognizeSelector: _cmd];
    return (SEL)0;
}

- (SEL)customSetter
{
    [self doesNotRecognizeSelector: _cmd];
    return (SEL)0;
}

- (NSString *)typeEncoding
{
    [self doesNotRecognizeSelector: _cmd];
    return nil;
}

- (NSString *)oldTypeEncoding
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
