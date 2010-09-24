
#import <Foundation/Foundation.h>
#import <objc/runtime.h>


@interface RTProperty : NSObject
{
}

+ (id)propertyWithObjCProperty: (objc_property_t)property;

- (id)initWithObjCProperty: (objc_property_t)property;

- (NSString *)attributeEncodings;
- (NSString *)name;
- (NSString *)typeEncoding;
- (NSString *)ivarName;

@end
