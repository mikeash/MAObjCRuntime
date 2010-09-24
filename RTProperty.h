
#import <Foundation/Foundation.h>
#import <objc/runtime.h>


@interface RTProperty : NSObject
{
}

+ (id)propertyWithObjCProperty: (Property)property;
+ (id)propertyWithName: (NSString *)name typeEncoding: (NSString *)typeEncoding;
+ (id)propertyWithName: (NSString *)name encode: (const char *)encodeStr;

- (id)initWithObjCProperty: (Property)property;
- (id)initWithName: (NSString *)name typeEncoding: (NSString *)typeEncoding;

- (NSString *)name;
- (NSString *)typeEncoding;
- (ptrdiff_t)offset;

@end
