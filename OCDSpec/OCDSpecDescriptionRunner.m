#import "OCDSpecDescriptionRunner.h"
#import "OCDSpec/OCDSpecSharedResults.h"
#import "OCDSpec/OCDSpecDescription.h"

@implementation OCDSpecDescriptionRunner

+ (int)getFailures
{
  return [[OCDSpecSharedResults sharedResults].failures intValue];;
}

+ (int)getSuccesses
{
  return [[OCDSpecSharedResults sharedResults].successes intValue];\

}
- (OCDSpecSharedResults *) runContext:(void( *)(void))desc
{
  (*desc)();
  return [OCDSpecSharedResults sharedResults];
}

+ (void)describe:(NSString *)descriptionName withExamples:(va_list)examples
{
  OCDSpecDescription *description = [OCDSpecDescription descriptionFromName:descriptionName examples:examples];

  [description describe];

  OCDSpecSharedResults *results = [OCDSpecSharedResults sharedResults];
  results.successes = description.successes;
  results.failures = description.failures;
}

@end

void describe(NSString *descriptionName, ...)
{
  va_list variableArgumentList;

  va_start(variableArgumentList, descriptionName);
  [OCDSpecDescriptionRunner describe:descriptionName withExamples: variableArgumentList];
  va_end(variableArgumentList);
}