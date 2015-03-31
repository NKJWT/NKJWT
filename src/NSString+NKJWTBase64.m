//
//
//  ,--.  ,--.,--. ,--.     ,--.,--.   ,--.,--------.
//  |  ,'.|  ||  .'   /     |  ||  |   |  |'--.  .--'
//  |  |' '  ||  .   ' ,--. |  ||  |.'.|  |   |  |
//  |  | `   ||  |\   \|  '-'  /|   ,'.   |   |  |
//  `--'  `--'`--' '--' `-----' '--'   '--'   `--'
//
//

#import "NSString+NKJWTBase64.h"

@implementation NSString (NKJWTBase64)

- (NSString *)cleanupResultingBase64
{
    return [[[self stringByReplacingOccurrencesOfString:@"+" withString:@"-"]
                   stringByReplacingOccurrencesOfString:@"/" withString:@"_"]
                   stringByReplacingOccurrencesOfString:@"=" withString:@""];
}

- (NSString *)restoreOriginalBase64FromCleanup
{
    if ([self isEqualToString:@""]) {
        return @"";
    }
    
    NSString *cleanup = [[self stringByReplacingOccurrencesOfString:@"_" withString:@"/"]
                               stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
    
    int remaining = [self length] % 4;
    
    if (remaining > 0) {
        int stringPadding = (4 - remaining);
        cleanup           = [cleanup stringByPaddingToLength:[cleanup length]+stringPadding
                                                  withString:@"=" startingAtIndex:0];
    }
    
    return cleanup;
}

- (NSString *)safeBase64Encode
{
    NSData *data     = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64 = [data base64EncodedStringWithOptions:0];
    return [base64 cleanupResultingBase64];
}

- (NSString *)safeBase64Decode
{
    NSData *data      = [[NSData alloc] initWithBase64EncodedString:[self restoreOriginalBase64FromCleanup] options:0];
    NSString *decoded = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];    
    return decoded;
}


@end