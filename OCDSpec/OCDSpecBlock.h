#import <Foundation/Foundation.h>
#import "VoidBlock.h"

@interface OCDSpecBlock : NSObject {
    NSException *raisedException;
}
@property (readonly) NSException *raisedException;
@property (readonly) NSString *actualExceptionName;
@property (readonly) NSString *actualExceptionReason;

-(id) initWithVoidblock:(VOIDBLOCK) givenBlock;
-(BOOL) wasExceptionRaised;
-(BOOL) actualExceptionMatchesName:(NSString*) expectedName andReason:(NSString*) expectedReason;

@end
