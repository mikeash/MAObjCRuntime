
#import <Foundation/Foundation.h>
#import <objc/runtime.h>


@interface RTProtocol : NSObject
{
}

+ (NSArray *)allProtocols;

+ (id)protocolWithObjCProtocol: (Protocol *)protocol;
+ (id)protocolWithName: (NSString *)name;

- (id)initWithObjCProtocol: (Protocol *)protocol;
- (id)initWithName: (NSString *)name;

- (Protocol *)objCProtocol;
- (NSString *)name;
- (NSArray *)incorporatedProtocols;
- (NSSet *)recursivelyIncorporatedProtocols;
- (NSArray *)methodsRequired: (BOOL)isRequiredMethod instance: (BOOL)isInstanceMethod;
- (NSArray *)methodsRequired: (BOOL)isRequiredMethod
                    instance: (BOOL)isInstanceMethod
                incorporated: (BOOL)recursivelyIncludeIncorporated;

@end
