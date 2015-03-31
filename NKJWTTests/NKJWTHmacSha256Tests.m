//
//
//  ,--.  ,--.,--. ,--.     ,--.,--.   ,--.,--------.
//  |  ,'.|  ||  .'   /     |  ||  |   |  |'--.  .--'
//  |  |' '  ||  .   ' ,--. |  ||  |.'.|  |   |  |
//  |  | `   ||  |\   \|  '-'  /|   ,'.   |   |  |
//  `--'  `--'`--' '--' `-----' '--'   '--'   `--'
//
//

#define EXP_SHORTHAND

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import "NSString+NKJWTHmacSha256.h"

SpecBegin(NKJWTHmacSha256)

describe(@"Hmac Coder", ^{
    it(@"should generate correct signature", ^{
        NSString *correctBase64 = @"+defeHrccx3843eeY/eMmt/NBJLOEyWHkptTPyyZQx0=";
        
        NSString *input = @"Some input";
        NSString *key   = @"12345678901234";
        
        NSData *res      = [input NKWTHmacSha256:key];
        NSString *base64 = [res base64EncodedStringWithOptions:0];
        
        expect(base64).to.equal(correctBase64);
        
        res = [input NKWTHmacSha256:@"1234567890123"];
        expect(res).notTo.equal(correctBase64);
    });
});

SpecEnd