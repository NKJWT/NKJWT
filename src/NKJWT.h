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

@interface NKJWT : NSObject

#pragma mark - properties
/**
 *  Token Payload
 */
@property (nonatomic, strong, getter = _JWTPayload, readonly) NSDictionary *payload;
/**
 *  Token Header
 */
@property (nonatomic, strong, getter = _JWTHeader, readonly ) NSDictionary *header;

#pragma mark - Constructors
/**
 *  Create NKJWT with payload dictionary
 *
 *  @param payload Payload dictionary
 *
 *  @return NKJWT object
 */
- (instancetype)initWithPayload:(NSDictionary *)payload;

/**
 *  Create NKJWT with token string
 *
 *  @param string token string
 *
 *  @return NKJWT object
 */
- (instancetype)initWithJWT:(NSString *)string;

#pragma mark - General actions

/**
 *  Set secret key for signing or verification
 *
 *  @param key Secret Key
 */
- (void)setKey:(NSString *)key;

/**
 *  Set new payload and generate a new signature
 *
 *  @param payload Payload to set
 */
- (void)setPayload:(NSDictionary *)payload;

/**
 *  Get current JWT token
 *
 *  @return token
 */
- (NSString *)token;

#pragma mark - Signing
/**
 *  Generate a new signature
 */
- (void)sign;

/**
 *  Set secret Key and generate a new signature
 *
 *  @param key secret key
 */
- (void)signWithKey:(NSString *)key;

#pragma mark - Verification
/**
 *  Verify signature
 *
 *  @return Verification status
 */
- (BOOL)verify;

/**
 *  Set a secret key and verify signature
 *
 *  @param key secret key
 *
 *  @return verification status
 */
- (BOOL)verifyWithKey:(NSString *)key;

/**
 *  Calculate signature
 *
 *  @return signature
 */
- (NSString *)calculateSignature;

@end