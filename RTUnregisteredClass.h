
#import <Foundation/Foundation.h>


@class RTProtocol;
@class RTIvar;
@class RTMethod;

@interface RTUnregisteredClass : NSObject
{
    Class _class;
}

+ (id)unregisteredClassWithName: (NSString *)name withSuperclass: (Class)superclass;
+ (id)unregisteredClassWithName: (NSString *)name;

- (id)initWithName: (NSString *)name withSuperclass: (Class)superclass;
- (id)initWithName: (NSString *)name;

- (void)addProtocol: (RTProtocol *)protocol;
- (void)addIvar: (RTIvar *)ivar;
- (void)addMethod: (RTMethod *)method;

- (Class)registerClass;

@end
