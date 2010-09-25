
#import <Foundation/Foundation.h>


@class RTProtocol;
@class RTIvar;
@class RTMethod;

@interface RTUnregisteredClass : NSObject
{
    Class _class;
}

+ (id)unregisteredClassWithClass: (Class)c;

- (id)initWithClass: (Class)c;

- (void)addProtocol: (RTProtocol *)protocol;
- (void)addIvar: (RTIvar *)ivar;
- (void)addMethod: (RTMethod *)method;

- (Class)registerClass;

@end
