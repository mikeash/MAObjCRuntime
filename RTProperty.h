
#import <Foundation/Foundation.h>
#import <objc/runtime.h>


@interface RTProperty : NSObject
{
}

+ (id)propertyWithObjCProperty: (objc_property_t)property;
+ (id)propertyWithName: (NSString *)name attributeEncodings: (NSString *)attributeEncodings typeEncoding: (NSString *)typeEncoding ivarName: (NSString *)ivarName;
+ (id)propertyWithName: (NSString *)name typeEncoding: (NSString *)typeEncoding ivarName: (NSString *)ivarName;
+ (id)propertyWithName: (NSString *)name typeEncoding: (NSString *)typeEncoding;
+ (id)propertyWithName: (NSString *)name encode: (const char *)encodeStr;

- (id)initWithObjCProperty: (objc_property_t)property;
- (id)initWithName: (NSString *)name attributeEncodings: (NSString *) attributeEncodings typeEncoding: (NSString *)typeEncoding ivarName: (NSString *)ivarName;
- (id)initWithName: (NSString *)name typeEncoding: (NSString *)typeEncoding ivarName: (NSString *)ivarName;
- (id)initWithName: (NSString *)name typeEncoding: (NSString *)typeEncoding;

- (NSString *)attributeEncodings;
- (NSString *)name;
- (NSString *)typeEncoding;
- (NSString *)ivarName;

@end
