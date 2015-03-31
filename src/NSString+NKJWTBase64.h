//
//
//  ,--.  ,--.,--. ,--.     ,--.,--.   ,--.,--------.
//  |  ,'.|  ||  .'   /     |  ||  |   |  |'--.  .--'
//  |  |' '  ||  .   ' ,--. |  ||  |.'.|  |   |  |
//  |  | `   ||  |\   \|  '-'  /|   ,'.   |   |  |
//  `--'  `--'`--' '--' `-----' '--'   '--'   `--'
//
//

#import <Foundation/Foundation.h>

@interface NSString (NKJWTBase64)

- (NSString *)cleanupResultingBase64;
- (NSString *)restoreOriginalBase64FromCleanup;

- (NSString *)safeBase64Encode;
- (NSString *)safeBase64Decode;

@end