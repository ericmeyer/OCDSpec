#import "OCDSpec/OCDSpec.h"
#import "Specs/Mocks/MockObjectWithEquals.h"

CONTEXT(OCDSpecExpectation){
  __block MockObjectWithEquals *actualObject;
  __block MockObjectWithEquals *expectedObject;
  __block OCDSpecExpectation *expectation;

  describe(@"The Expectation",

          it(@"throws its failures with the line and file passed in", ^{
            actualObject = [[MockObjectWithEquals alloc] initAsNotEqual];
            expectedObject = [[MockObjectWithEquals alloc] init];

            OCDSpecExpectation *expectation = [[OCDSpecExpectation alloc] initWithObject:actualObject inFile:@"FILENAME" atLineNumber:120];

            @try
            {
              [expectation toBeEqualTo:expectedObject];
              FAIL(@"Code did not throw a failure exception");
            }
            @catch (NSException *exception)
            {
              [expect([[exception userInfo] objectForKey:@"file"]) toBeEqualTo:@"FILENAME"];
              [expect([[exception userInfo] objectForKey:@"line"]) toBeEqualTo:[NSNumber numberWithLong:120]];
            }

          }),

          it(@"Is created helpfully by the expect macro", ^{
            NSObject *innerObject = nil;

            OCDSpecExpectation *expectation = expect(innerObject);

            [expect([NSNumber numberWithInt:expectation.line]) toBeEqualTo:[NSNumber numberWithInt:(__LINE__ - 2)]];
            [expect(expectation.file) toBeEqualTo:[NSString stringWithUTF8String:__FILE__]];
          }),
          nil);
    
  describe(@"failWithMessage",
           it(@"includes the line and file",
              ^{
                  OCDSpecExpectation *expectation = [[OCDSpecExpectation alloc] initWithObject:actualObject inFile:@"FILENAME" atLineNumber:456];
                  @try {
                      [expectation failWithMessage: @"Some Message"];
                      FAIL(@"Code did not throw a failure exception");
                  }
                  @catch (NSException *exception) {
                      [expect([[exception userInfo] objectForKey:@"file"]) toBeEqualTo:@"FILENAME"];
                      [expect([[exception userInfo] objectForKey:@"line"]) toBeEqualTo:[NSNumber numberWithLong:456]];
                  }              
              }),
           it(@"includes the message",
              ^{
                  OCDSpecExpectation *expectation = [[OCDSpecExpectation alloc] initWithObject:actualObject inFile:@"FILENAME" atLineNumber:456];
                  @try {
                      [expectation failWithMessage: @"Some Message"];
                      FAIL(@"Code did not throw a failure exception");
                  }
                  @catch (NSException *exception) {
                      [expect([exception reason]) toBeEqualTo: @"Some Message"];
                  }              
              }),
           nil);

  describe(@"toBeEqualTo",
          it(@"passes when two objects are equal", ^{
            actualObject = [[MockObjectWithEquals alloc] init];
            expectedObject = [[MockObjectWithEquals alloc] init];

            expectation = [[OCDSpecExpectation alloc] initWithObject:actualObject inFile:@"" atLineNumber:0];

            [expectation toBeEqualTo:expectedObject];
          }),

          it(@"fails if the two objects are not equal using equalTo", ^{
            actualObject = [[MockObjectWithEquals alloc] initAsNotEqual];
            expectedObject = [[MockObjectWithEquals alloc] init];

            expectation = [[OCDSpecExpectation alloc] initWithObject:actualObject inFile:@"" atLineNumber:0];

            @try
            {
              [expectation toBeEqualTo:expectedObject];
              FAIL(@"Code did not throw a failure exception");
            }
            @catch (NSException *exception)
            {
              NSString *expectedReason = [NSString stringWithFormat:@"%@ was expected to be equal to %@, and isn't", actualObject, expectedObject];

              [expect([exception reason]) toBeEqualTo:expectedReason];
            }
          }),
          nil);


  describe(@"toBe",
          it(@"fails if two objects are not the same object", ^{
            actualObject = [[MockObjectWithEquals alloc] init];
            expectedObject = [[MockObjectWithEquals alloc] init];

            @try
            {
              [expect(actualObject) toBe:expectedObject];
              FAIL(@"Should have thrown an exception, but didn't");
            }
            @catch (NSException *exception)
            {
              NSString *expectedReason = [NSString stringWithFormat:@"%@ was expected to be the same object as %@, but wasn't", actualObject, expectedObject];

              [expect([exception reason]) toBeEqualTo:expectedReason];
            }
          }),

          it(@"does not fail if the two objects are the same", ^{
            actualObject = [[MockObjectWithEquals alloc] init];

            [expect(actualObject) toBe:actualObject];
          }),

          nil);

  describe(@"toBeTrue",
          it(@"fails if the value is not truthy", ^{
            @try
            {
              expectTruth(FALSE);
              FAIL(@"Should have thrown an exception, but didn't");
            }
            @catch (NSException *exception)
            {
              NSString *expectedReason = [NSString stringWithFormat:@"%b was expected to be true, but was false", FALSE];

              [expect([exception reason]) toBeEqualTo:expectedReason];
            }
          }),

          it(@"does not fail if the value is TRUE", ^{
            expectTruth(TRUE);
          }),

          it(@"Passes with YES, fails with NO", ^{
            expectTruth(YES);
            @try
            {
              expectTruth(NO);
              FAIL(@"Did not fail for NO");
            }
            @catch (NSException *exception)
            {
              NSString *expectedReason = [NSString stringWithFormat:@"%b was expected to be true, but was false", NO];
                
              [expect([exception reason]) toBeEqualTo:expectedReason];
            }
          }),

          it(@"Passes with true", ^{
            expectTruth(true);
          }),

          it(@"fails with false", ^{
            @try
            {
              expectTruth(false);
              FAIL(@"Did not fail for false");
            }
            @catch (NSException *exception)
            {
              NSString *expectedReason = [NSString stringWithFormat: @"%b was expected to be true, but was false", false];
                
              [expect(exception.reason) toBeEqualTo: expectedReason];
            }
          }),

          nil);
    
  describe(@"toExist",
           it(@"fails for nil", ^{
             @try
             {
               [expect(nil) toExist];
               FAIL(@"Should have thrown an exception, but didn't");
             }
             @catch (NSException *exception)
             {
               NSString *expectedReason = [NSString stringWithFormat:@"Object was expected to exist, but didn't"];
               [expect([exception reason]) toBeEqualTo:expectedReason];
             }
          }),
          
          it(@"succeeds for non-nil", ^{
            [expect(@"not nil") toExist];
          }),
        
          nil);

  describe(@"expectFalse",
          it(@"fails if the value is truthy", ^{
            @try
            {
              expectFalse(YES);
              FAIL(@"Should have thrown an exception, but didn't");
            }
            @catch (NSException *exception)
            {
              NSString *expectedReason = [NSString stringWithFormat:@"%b was expected to be false, but was true", FALSE];

              [expect([exception reason]) toBeEqualTo:expectedReason];
            }
          }),
          it(@"passes if the value is false", ^{
            expectFalse(false);
          }),
          it(@"passes if the value is NO", ^{
            expectFalse(NO);
          }),
          nil);
    
    describe(@"toRaise:withReason:",
             it(@"fails when no exception is raised",
                ^{
                    @try
                    {
                        VOIDBLOCK passingBlock = ^{};
                        [expect(passingBlock) toRaise: @"Some Exception" withReason: @"Some Reason"];
                        FAIL(@"Should have thrown an exception, but didn't");
                    }
                    @catch (NSException *exception)
                    {
                        [expect([exception reason]) toBeEqualTo: @"Expected \"Some Exception\": \"Some Reason\" to have been raised, but got no exception."];
                    }
                }),
             it(@"passes when the matching exception is raised",
                ^{
                    VOIDBLOCK failingBlock = ^{
                        [NSException raise: @"Some Exception" format: @"Some Reason"];
                    };
                    [expect(failingBlock) toRaise: @"Some Exception" withReason: @"Some Reason"];
                }),
             it(@"fails when only the reason matches",
                ^{
                    @try
                    {
                        VOIDBLOCK failingBlock = ^{
                            [NSException raise: @"Actual Exception" format: @"Expected Reason"];
                        };
                        [expect(failingBlock) toRaise: @"Expected Exception" withReason: @"Expected Reason"];
                        FAIL(@"Should have thrown an exception, but didn't");
                    }
                    @catch (NSException* exception)
                    {
                        NSString *expectedMessage = @"Expected \"Expected Exception\": \"Expected Reason\" to have been raised, but \"Actual Exception\": \"Expected Reason\" was raised instead.";
                        
                        [expect(exception.reason) toBeEqualTo: expectedMessage];
                    }
                }),
             it(@"fails when only the name matches",
                ^{
                    @try
                    {
                        VOIDBLOCK failingBlock = ^{
                            [NSException raise: @"Expected Exception" format: @"Actual Reason"];
                        };
                        [expect(failingBlock) toRaise: @"Expected Exception" withReason: @"Expected Reason"];
                        FAIL(@"Should have thrown an exception, but didn't");
                    }
                    @catch (NSException* exception)
                    {
                        NSString *expectedMessage = @"Expected \"Expected Exception\": \"Expected Reason\" to have been raised, but \"Expected Exception\": \"Actual Reason\" was raised instead.";
                        
                        [expect(exception.reason) toBeEqualTo: expectedMessage];
                    }
                }),
             nil);
    
    
    describe(@"toRaiseException",
             it(@"passes when given a block that raises an exception",
                ^{
                    VOIDBLOCK failingBlock = ^{
                        [NSException raise: @"Some Exception" format: @"Some Reason"];
                    };
                    [expect(failingBlock) toRaiseException];
                }),
             it(@"fails when given a block that raises no exception",
                ^{
                    @try
                    {
                        VOIDBLOCK passingBlock = ^{};
                        [expect(passingBlock) toRaiseException];
                        FAIL(@"Should have thrown an exception, but didn't");
                    }
                    @catch (NSException *exception)
                    {
                        [expect([exception reason]) toBeEqualTo: @"Expected given block to raise an exception, but no exception was raised."];
                    }
                }),
             nil);

}
