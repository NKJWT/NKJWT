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
#import "NKJWT.h"

SpecBegin(NKJWT)

describe(@"NKJWT", ^{
    context(@"with inline calls", ^{
        it(@"should generate correct signature with payload disctionary", ^{
            NKJWT *nkjwt = [[NKJWT alloc] initWithPayload:@{
                                                            @"a": @"aa",
                                                            @"b": @"bb"
                                                            }];
            
            NSString *correctToken = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhIjoiYWEiLCJiIjoiYmIifQ.A6rD1OxZ_mBeRV4XcEgsnAddi5lmTgoBfoi6-13FbdQ";
            
            [nkjwt signWithKey:@"12345678901234"];
            NSString *token = [nkjwt token];
            
            expect(token).to.equal(correctToken);
        });
        
        it(@"should verify signature", ^{
            NSString *token = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhIjoiYWEiLCJiIjoiYmIifQ.A6rD1OxZ_mBeRV4XcEgsnAddi5lmTgoBfoi6-13FbdQ";
            NKJWT *nkjwt = [[NKJWT alloc] initWithJWT:token];
            
            BOOL positive = [nkjwt verifyWithKey:@"12345678901234"];
            expect(positive).to.equal(YES);
            
            BOOL negative = [nkjwt verifyWithKey:@"1234567890123"];
            expect(negative).to.equal(NO);
        });
    });
    
    context(@"with delayed calls", ^{
        it(@"should generate correct signature with payload disctionary", ^{
            NKJWT *nkjwt = [[NKJWT alloc] initWithPayload:@{
                                                            @"a": @"aa",
                                                            @"b": @"bb"
                                                            }];
            
            NSString *correctToken = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhIjoiYWEiLCJiIjoiYmIifQ.A6rD1OxZ_mBeRV4XcEgsnAddi5lmTgoBfoi6-13FbdQ";
            
            [nkjwt setKey:@"12345678901234"];
            [nkjwt sign];
            NSString *token = [nkjwt token];
            
            expect(token).to.equal(correctToken);
        });
        
        it(@"should verify signature", ^{
            NSString *token = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhIjoiYWEiLCJiIjoiYmIifQ.A6rD1OxZ_mBeRV4XcEgsnAddi5lmTgoBfoi6-13FbdQ";
            NKJWT *nkjwt = [[NKJWT alloc] initWithJWT:token];
            
            [nkjwt setKey:@"12345678901234"];
            BOOL positive = [nkjwt verify];
            expect(positive).to.equal(YES);
            
            [nkjwt setKey:@"1234567890123"];
            BOOL negative = [nkjwt verify];
            expect(negative).to.equal(NO);
        });
    });
    
    it(@"should replace old payload with new", ^{
        NKJWT *nkjwt = [[NKJWT alloc] initWithPayload:@{
                                                        @"a": @"aa",
                                                        @"b": @"bb"
                                                        }];
        
        NSString *correctToken = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhIjoiYWEiLCJiIjoiYmIifQ.A6rD1OxZ_mBeRV4XcEgsnAddi5lmTgoBfoi6-13FbdQ";
        
        [nkjwt setKey:@"12345678901234"];
        [nkjwt sign];
        
        NSString *token = [nkjwt token];
        expect(token).to.equal(correctToken);
        
        [nkjwt setPayload:@{
                            @"a":@"aaa",
                            @"b":@"bbb"
                            }];
        [nkjwt sign];
        NSString *newToken = [nkjwt token];
        expect(newToken).to.equal(@"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhIjoiYWFhIiwiYiI6ImJiYiJ9.kHF8HbAJRNzDCSbeDexri88uXfl60by64gkvU4V0jRk");
    });
});

SpecEnd