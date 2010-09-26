
#import <Foundation/Foundation.h>
#import <objc/runtime.h>


@interface RTProperty : NSObject
{
}

+ (id)propertyWithObjCProperty: (objc_property_t)property;

- (id)initWithObjCProperty: (objc_property_t)property;

- (NSString *)attributeEncodings;
- (SEL)customGetter;
- (SEL)customSetter;
- (NSString *)name;
- (NSString *)typeEncoding;
- (NSString *)oldTypeEncoding;
- (NSString *)ivarName;

@end
