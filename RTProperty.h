
#import <Foundation/Foundation.h>
#import <objc/runtime.h>


@interface RTProperty : NSObject
{
}

+ (id)propertyWithObjCProperty: (objc_property_t)property;
+ (id)propertyWithName: (NSString *)name typeEncoding: (NSString *)typeEncoding;
+ (id)propertyWithName: (NSString *)name encode: (const char *)encodeStr;

- (id)initWithObjCProperty: (objc_property_t)property;
- (id)initWithName: (NSString *)name typeEncoding: (NSString *)typeEncoding;

- (NSString *)name;
- (NSString *)typeEncoding;

@end
