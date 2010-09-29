
#import <Foundation/Foundation.h>


@class RTClass;
@class RTProtocol;
@class RTIvar;
@class RTMethod;

@interface RTUnregisteredClass : NSObject
{
    Class _class;
}

+ (id)unregisteredClassWithName: (NSString *)name withSuperclass: (RTClass *)superclassOrNil;
+ (id)unregisteredClassWithName: (NSString *)name;

- (id)initWithName: (NSString *)name withSuperclass: (RTClass *)superclassOrNil;
- (id)initWithName: (NSString *)name;

- (void)addProtocol: (RTProtocol *)protocol;
- (void)addIvar: (RTIvar *)ivar;
- (void)addMethod: (RTMethod *)method;

- (RTClass *)registerClass;

@end
