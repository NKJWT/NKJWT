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
#import "NSString+NKJWTBase64.h"

SpecBegin(NKJWTBase64)

describe(@"Regular strings", ^{
    it(@"should generate correct unpadded base64 for valid input", ^{
        NSString *input = [@"Some Test" safeBase64Encode];
        expect(input).to.equal(@"U29tZSBUZXN0");
        
        NSString *secondInput = [@"Another pesky test" safeBase64Encode];
        expect(secondInput).to.equal(@"QW5vdGhlciBwZXNreSB0ZXN0");
        
        NSString *thirtInput = [@"Another pesky test!" safeBase64Encode];
        expect(thirtInput).to.equal(@"QW5vdGhlciBwZXNreSB0ZXN0IQ");
    });
});

describe(@"Padded Base64 String", ^{
    it(@"should be correctly decoded", ^{
        NSString *result = [@"QW5vdGhlciBwZXNreSB0ZXN0IQ==" safeBase64Decode];
        expect(result).to.equal(@"Another pesky test!");
    });
});

describe(@"Unpadded Base64", ^{
    it(@"should be correctly decoded", ^{
        NSString *result = [@"QW5vdGhlciBwZXNreSB0ZXN0IQ===" safeBase64Decode];
        expect(result).to.equal(@"Another pesky test!");
    });
});

SpecEnd