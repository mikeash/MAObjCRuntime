
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@class RTMethod;

@interface RTProtocol : NSObject
{
}

+ (NSArray <RTProtocol *> *)allProtocols;

+ (id)protocolWithObjCProtocol: (Protocol *)protocol;
+ (id)protocolWithName: (NSString *)name;

- (id)initWithObjCProtocol: (Protocol *)protocol;
- (id)initWithName: (NSString *)name;

- (Protocol *)objCProtocol;
- (NSString *)name;
- (NSArray <RTProtocol *> *)incorporatedProtocols;
- (NSArray <RTMethod *> *)methodsRequired: (BOOL)isRequiredMethod instance: (BOOL)isInstanceMethod;

@end
