
#import "MARuntime.h"

#import "RTClass.h"
#import "RTProtocol.h"

@implementation MARuntime

+ (NSArray *)classes
{
    Class *buffer = NULL;
    
    int count, size;
    do
    {
        count = objc_getClassList(NULL, 0);
        buffer = realloc(buffer, count * sizeof(*buffer));
        size = objc_getClassList(buffer, count);
    } while(size != count);
    
    NSMutableArray *array = [NSMutableArray array];
    for(int i = 0; i < count; i++)
    {
        RTClass *candidate = [RTClass classWithObjCClass: buffer[i]];
        [array addObject: candidate];
    }
    free(buffer);
    return array;
}

+ (NSArray *)rootClasses
{
    NSMutableArray *array = [NSMutableArray array];
    for(Class candidate in [self classes])
    {
        Class superclass = class_getSuperclass(candidate);
        if(superclass == Nil)
        {
            [array addObject: candidate];
        }
    }
    return array;
}

+ (RTClass *)classNamed: (NSString *)name
{
    Class class = objc_getClass([name cStringUsingEncoding:[NSString defaultCStringEncoding]]);
    return [RTClass classWithObjCClass: class];
}

- (NSArray *)protocols
{
    unsigned int count;
    Protocol **protocols = objc_copyProtocolList(&count);
    
    NSMutableArray *array = [NSMutableArray array];
    for(unsigned i = 0; i < count; i++)
        [array addObject: [RTProtocol protocolWithObjCProtocol: protocols[i]]];
    
    free(protocols);
    return array;
}

+ (RTProtocol *)protocolNamed: (NSString *)name
{
    Protocol *protocol = objc_getProtocol([name cStringUsingEncoding:[NSString defaultCStringEncoding]]);
    if(!protocol) return nil;
    
    return [RTProtocol protocolWithObjCProtocol: protocol];
}

@end

