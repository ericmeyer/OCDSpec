#import "OCDSpec/OCDSpec.h"
#import "OCDSpec/OCDSpecDescription.h"
#import "OCDSpec/OCDSpecOutputter.h"
#import "OCDSpecOutputter+RedirectOutput.h"

static BOOL descriptionWasRun = false;

void testDescription(void) {
  descriptionWasRun = true;

  [OCDSpecOutputter withRedirectedOutput:^{
    describe(@"MyFakeTest",
            it(@"succeeds", ^{
            }),
            it(@"Fails", ^{
              FAIL(@"FAILURE IN TEST");
            }),
            nil
    );
  }];
}

void testContextWithTwoDescribes(void) {
  [OCDSpecOutputter withRedirectedOutput:^{
    describe(@"MyFakeTest",
            it(@"succeeds", ^{
            }),
            it(@"Fails", ^{
              FAIL(@"FAILURE IN TEST");
            }),
            nil
    );

    describe(@"Empty Description", nil);
  }];
}

@interface FakeDescription : OCDSpecDescription
{
  bool wasRun;
}

@property(assign) bool wasRun;
@end

@implementation FakeDescription
@synthesize wasRun;

-(void) describe
{
  wasRun = true;
}
@end

CONTEXT(OCDSpecDescriptionRunner){
  __block OCDSpecDescriptionRunner *runner;
  describe(@"OCDSpecDescriptionRunner",

          beforeEach(^{
            runner = [[OCDSpecDescriptionRunner alloc] init];
          }),

          it(@"runs the passed in C function", ^{
            [runner runContext:testDescription];

            expectTruth(descriptionWasRun);
          }),

          it(@"returns the results from runContext", ^{
            OCDSpecResults results = [runner runContext:testDescription];

            [expect([NSNumber numberWithInt:results.failures]) toBeEqualTo:[NSNumber numberWithInt:1]];
            [expect([NSNumber numberWithInt:results.successes]) toBeEqualTo:[NSNumber numberWithInt:1]];
          }),

          it(@"Runs an individual description", ^{
            FakeDescription *desc = [[FakeDescription alloc] init];
            desc.wasRun = false;

            [runner runDescription:desc];

            expectTruth(desc.wasRun);
          }),

          it(@"stores the results of a description on itself", ^{
            OCDSpecDescription *description = [[OCDSpecDescription alloc] init];
            description.failures = [NSNumber numberWithInt:8];
            description.successes = [NSNumber numberWithInt:6];

            [runner runDescription:description];

            [expect(runner.failures) toBeEqualTo:[NSNumber numberWithInt:8]];
            [expect(runner.successes) toBeEqualTo:[NSNumber numberWithInt:6]];
          }),

          it(@"Totals up the runDescriptions on multiple runs", ^{
            OCDSpecDescription *descriptionOne = [[OCDSpecDescription alloc] init];
            descriptionOne.failures = [NSNumber numberWithInt:8];
            descriptionOne.successes = [NSNumber numberWithInt:1];
            OCDSpecDescription *descriptionTwo = [[OCDSpecDescription alloc] init];
            descriptionTwo.successes = [NSNumber numberWithInt:8];

            [runner runDescription:descriptionOne];
            [runner runDescription:descriptionTwo];

            [expect(runner.failures) toBeEqualTo:[NSNumber numberWithInt:8]];
            [expect(runner.successes) toBeEqualTo:[NSNumber numberWithInt:9]];
          }),

          it(@"Does not overwrite counts when two describes are nested in a context", ^{
            OCDSpecResults results = [runner runContext:testContextWithTwoDescribes];

            [expect([NSNumber numberWithInt:results.failures]) toBeEqualTo:[NSNumber numberWithInt:1]];
            [expect([NSNumber numberWithInt:results.successes]) toBeEqualTo:[NSNumber numberWithInt:1]];
          }),
          nil
  );
}