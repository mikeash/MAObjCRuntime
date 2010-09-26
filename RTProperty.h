
#import <Foundation/Foundation.h>
#import <objc/runtime.h>


typedef enum
{
    RTPropertySetterSemanticsAssign,
    RTPropertySetterSemanticsRetain,
    RTPropertySetterSemanticsCopy
}
RTPropertySetterSemantics;

@interface RTProperty : NSObject
{
}

+ (id)propertyWithObjCProperty: (objc_property_t)property;

- (id)initWithObjCProperty: (objc_property_t)property;

- (NSString *)attributeEncodings;
- (BOOL)isReadOnly;
- (RTPropertySetterSemantics)setterSemantics;
- (BOOL)isNonAtomic;
- (BOOL)isDynamic;
- (BOOL)isWeakReference;
- (BOOL)isEligibleForGarbageCollection;
- (SEL)customGetter;
- (SEL)customSetter;
- (NSString *)name;
- (NSString *)typeEncoding;
- (NSString *)oldTypeEncoding;
- (NSString *)ivarName;

@end
