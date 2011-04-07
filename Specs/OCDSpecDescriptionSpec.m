#import "OCDSpec/OCDSpec.h"
#import "Specs/Mocks/MockExample.h"
#import "Specs/Utils/TemporaryFileStuff.h"
#import "OCDSpec/OCDSpecOutputter.h"

CONTEXT(OCDSpecDescription)
{
  describe(@"The Description",
         it(@"describes one example without errors",
            ^{
              OCDSpecDescription *description = [[[OCDSpecDescription alloc] init] autorelease];
              
              [description describe:@"It Should Do Something" onArrayOfExamples: [[[NSArray alloc] init] autorelease]];
              
              if (description.failures != 0) {
                FAIL(@"Should have had 0 failures.  Did not");
              }
            }),
         
         it(@"describes an example with one error",
            ^{
              OCDSpecDescription *description = [[[OCDSpecDescription alloc] init] autorelease];
              OCDSpecOutputter *outputter = [OCDSpecOutputter sharedOutputter];
              outputter.fileHandle = [NSFileHandle fileHandleWithNullDevice];
              
              MockExample *example = [MockExample exampleThatFailed];  
              NSArray *examples = [NSArray arrayWithObjects:example, nil];
              
              [description describe:@"It Should Do Something" onArrayOfExamples: examples];
              
              outputter.fileHandle = [NSFileHandle fileHandleWithStandardError];
              
              if (description.failures != 1)
              {
                FAIL(@"Should have had 1 error, did not");
              }
            }),
         
         it(@"writes the exceptions to the shared outputter", 
            ^{
              OCDSpecDescription *description = [[[OCDSpecDescription alloc] init] autorelease];
              OCDSpecOutputter *outputter = [OCDSpecOutputter sharedOutputter];
              outputter.fileHandle = GetTemporaryFileHandle();
              
              OCDSpecExample *example = [[[OCDSpecExample alloc] initWithBlock:^{ FAIL(@"FAIL"); }] autorelease];
              NSArray *tests = [NSArray arrayWithObject: example];
              
              [description describe:@"It Should Do Something" onArrayOfExamples: tests];
              
              NSString *outputException = ReadTemporaryFile();  
              outputter.fileHandle = [NSFileHandle fileHandleWithStandardError];
              
              if (outputException.length == 0)
              {
                FAIL(@"An exception should have been written to the outputter - but wasn't.");
              }
              
              DeleteTemporaryFile();
            }),
         
         it(@"can describe multiple examples", 
            ^{
              OCDSpecDescription *description = [[[OCDSpecDescription alloc] init] autorelease];
              OCDSpecOutputter *outputter = [OCDSpecOutputter sharedOutputter];
              outputter.fileHandle = [NSFileHandle fileHandleWithNullDevice];
              
              OCDSpecExample *exampleOne = [[[OCDSpecExample alloc] initWithBlock: ^{ FAIL(@"Fail One"); }] autorelease];
              OCDSpecExample *exampleTwo = [[[OCDSpecExample alloc] initWithBlock: ^{ FAIL(@"Fail Two"); }] autorelease];
              
              NSArray *tests = [NSArray arrayWithObjects:exampleOne, exampleTwo, nil];
              
              [description describe:@"It Should Do Something" onArrayOfExamples: tests];
              
              outputter.fileHandle = [NSFileHandle fileHandleWithStandardError];
              
              if (description.failures != 2)
              {
                FAIL(@"Should have had two errors, didn't");
              }
            }),
         
         it(@"can describe multiple successes",
            ^{
              OCDSpecDescription *description = [[[OCDSpecDescription alloc] init] autorelease];
              OCDSpecOutputter *outputter = [OCDSpecOutputter sharedOutputter];
              outputter.fileHandle = [NSFileHandle fileHandleWithNullDevice];
              
              OCDSpecExample *exampleOne = [[[OCDSpecExample alloc] initWithBlock: ^{ }] autorelease];
              OCDSpecExample *exampleTwo = [[[OCDSpecExample alloc] initWithBlock: ^{ }] autorelease];
              
              NSArray *tests = [NSArray arrayWithObjects:exampleOne, exampleTwo, nil];
              
              [description describe:@"It Should Do Something" onArrayOfExamples: tests];
              
              outputter.fileHandle = [NSFileHandle fileHandleWithStandardError];
              
              if (description.successes != 2)
              {
                FAIL(@"Should have had two successes, didn't");
              }
            }),
          nil
           );
}