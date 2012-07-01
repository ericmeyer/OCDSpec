#import "OCDSpecBlock.h"
#import "VoidBlock.h"

@implementation OCDSpecBlock

@synthesize raisedException;

-(id)initWithVoidblock:(VOIDBLOCK) givenBlock
{
    if ((self = [super init]))
    {
        @try
        {
            givenBlock();
        }
        @catch (NSException* exception)
        {
            raisedException = exception;
        }
    }
    return self;
}

-(BOOL) wasExceptionRaised
{
    return (raisedException != NULL);
}

-(BOOL) actualExceptionMatchesName:(NSString *)expectedName andReason:(NSString*) expectedReason
{
    return ([self.actualExceptionName isEqualToString: expectedName] && [self.actualExceptionReason isEqualToString: expectedReason]);
}

-(NSString*) actualExceptionName {
    return raisedException.name;
}

-(NSString*) actualExceptionReason {
    return raisedException.reason;
}

@end
