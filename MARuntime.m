
#import "MARuntime.h"


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
        [array addObject: buffer[i]];
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

+ (Class)classNamed: (NSString *)name
{
    return objc_getClass([name cStringUsingEncoding:[NSString defaultCStringEncoding]]);
}

@end

