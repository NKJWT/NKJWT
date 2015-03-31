//
//
//  ,--.  ,--.,--. ,--.     ,--.,--.   ,--.,--------.
//  |  ,'.|  ||  .'   /     |  ||  |   |  |'--.  .--'
//  |  |' '  ||  .   ' ,--. |  ||  |.'.|  |   |  |
//  |  | `   ||  |\   \|  '-'  /|   ,'.   |   |  |
//  `--'  `--'`--' '--' `-----' '--'   '--'   `--'
//
//

#import "NKJWT.h"
#import "NSString+NKJWTBase64.h"
#import "NSString+NKJWTHmacSha256.h"

@interface NKJWT()
#pragma mark - properties

@property (nonatomic, strong, getter=_JWTPayload, setter=_JWTPayload:) NSDictionary *payload;
@property (nonatomic, strong, getter=_JWTHeader, setter=_JWTHeader:) NSDictionary *header;

@property (nonatomic, copy, getter=_JWTKey, setter=_JWTKey:) NSString *key;

@property (nonatomic, copy) NSString *jsonHeader;
@property (nonatomic, copy) NSString *jsonPayload;
@property (nonatomic, copy) NSString *base64Header;
@property (nonatomic, copy) NSString *base64Payload;

@property (nonatomic, copy) NSString *signature;
@end

@implementation NKJWT

#pragma mark - Constructors

- (instancetype)initWithPayload:(NSDictionary *)payload
{
    if (!(self = [super init])) {
        return nil;
    }
    
    NSError *error;
    
    /**
     *  For now, only general HS256 tokens are supported
     */
    _header       = @{@"alg": @"HS256", @"typ": @"JWT"};
    _jsonHeader   = @"{\"alg\":\"HS256\",\"typ\":\"JWT\"}";
    _base64Header = [_jsonHeader safeBase64Encode];
    
    _payload      = payload;
    NSData *jsonPayloadData = [NSJSONSerialization dataWithJSONObject:_payload options:0 error:&error];
    if (error) {
        [NSException raise:@"NKJWTInvalidPayloadException" format:@"Could not serialize payload to JSON"];
        return nil;
    }
    
    _jsonPayload  = [[NSString alloc] initWithData:jsonPayloadData encoding:NSUTF8StringEncoding];
    _base64Payload = [_jsonPayload safeBase64Encode];
    
    return self;
}


- (instancetype)initWithJWT:(NSString *)string
{
    if (!(self = [super init])) {
        return nil;
    }
    NSArray *components = [string componentsSeparatedByString:@"."];
    if (!components || [components count] != 3) {
        [NSException raise:@"NKJWTInvalidInputFormatException" format:@"Specified JWT has invalid token"];
        return nil;
    }
    
    self.base64Header  = components[0];
    self.base64Payload = components[1];
    self.signature     = components[2];
    self.jsonPayload   = [self.base64Payload safeBase64Decode];
    self.jsonHeader    = [self.base64Header safeBase64Decode];
    
    NSError *error;
    self.header = [NSJSONSerialization JSONObjectWithData:[self.jsonHeader dataUsingEncoding:NSUTF8StringEncoding]
                                                  options:0
                                                    error:&error];
    
    if (error) {
        [NSException raise:@"NKJWTInvalidHeaderException" format:@"Could not decode JWT header"];
        return nil;
    }
    
    self.payload = [NSJSONSerialization JSONObjectWithData:[self.jsonPayload dataUsingEncoding:NSUTF8StringEncoding]
                                                   options:0
                                                     error:&error];
    
    if (error) {
        [NSException raise:@"NKJWTInvalidPayloadException" format:@"Could not decode JWT payload"];
        return nil;
    }
    
    return self;
}

#pragma mark - General actions

- (void)setKey:(NSString *)key
{
    self.key = key;
}

- (void)setPayload:(NSDictionary *)payload
{
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:payload
                                                   options:0
                                                     error:&error];
    
    if (error) {
        [NSException raise:@"NKJWTInvalidPayloadException" format:@"Could not serialize payload to JSON"];
        return;
    }
    
    self.jsonPayload   = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.base64Payload = [self.jsonPayload safeBase64Encode];
    self.payload       = payload;
    
    if (self.key) {
        [self sign];
    }
}

#pragma mark - Signing

- (void)sign
{
    if (!self.key || [self.key isEqualToString:@""]) {
        [NSException raise:@"NKJWTKeyIsNotSetException" format:@"Failed to sign the token because the key is not set"];
        return;
    }
    
    self.signature = [self calculateSignature];
}

- (void)signWithKey:(NSString *)key
{
    [self setKey:key];
    [self sign];
}

#pragma mark - Verification

- (BOOL)verify
{
    NSString *sig = [self calculateSignature];
    return [self.signature isEqualToString:sig];
}

- (BOOL)verifyWithKey:(NSString *)key
{
    [self setKey:key];
    return [self verify];
}

- (NSString *)calculateSignature
{
    if (!self.key || [self.key isEqualToString:@""]) {
        [NSException raise:@"NKJWTNoKeyException" format:@"Key is not specified"];
    }
    NSString *input = [NSString stringWithFormat:@"%@.%@", self.base64Header, self.base64Payload];
    NSData *sigData = [input NKWTHmacSha256:self.key];
    NSString *sig   = [[sigData base64EncodedStringWithOptions:0] cleanupResultingBase64];
    
    return sig;
}

- (NSString *)token {
    if (!self.signature) {
        [self sign];
    }
    return [NSString stringWithFormat:@"%@.%@.%@", self.base64Header, self.base64Payload, self.signature];
}

@end