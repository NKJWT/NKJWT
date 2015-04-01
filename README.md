![pod version](https://img.shields.io/cocoapods/v/NKJWT.svg) ![pod license](https://img.shields.io/cocoapods/l/NKJWT.svg) ![pod platform](https://img.shields.io/cocoapods/p/NKJWT.svg)

# NKJWT

## Contents:

- [Why NKJWT?](#why-nkjwt)
- [User Guide](#user-guide)
    - [Installation](#installation)
    - [Verifying Token](#verifying-token)
    - [Getting Payload from token](#getting-payload-from-token)
    - [Creating token](#creating-token)
    - [Signing and getting signed token](#signing-and-getting-signed-token)
    - [Updating payload](#updating-payload)

## Why NKJWT?

JWT (JSON Web Token) is an amazing technology, which makes network / API integration extremely easy and fast. This library allows you to get all benefits of JWT with only a few lines of code.

## User Guide

### Installation

Add to your Podfile:

```ruby
pod 'NKJWT', '~> 0.1'
```

### Verifying Token

```objective-c
NSString *token = @"xxxxxxxxxxxx";
NKJWT *jwt = [[NKJWT alloc] initWithJWT:token];
isValid = [jwt verifyWithKey:key];
```

or if you do not prefer stateless expressions:

```objective-c
NSString *token = @"xxxxxxxxxxxx";
NKJWT *jwt = [[NKJWT alloc] initWithJWT:token];
[jwt setKey:key];
isValid = [jwt verify];
```

### Getting Payload from token

```objective-c
NKJWT *jwt = [[NKJWT alloc] initWithJWT:token];
isValid = [jwt verifyWithKey:key];
NSDictionary *payload = jwt.payload;
```

### Creating token

```objective-c
NKJWT *jwt = [[NKJWT alloc] initWithPayload:payloadDictionary];
```

### Signing and getting signed token

```objective-c
NKJWT *jwt = [[NKJWT alloc] initWithPayload:payloadDictionary];
[jwt signWithKey:key];
NSString *token = [jwt token];
```

or without stateless expressions:

```objective-c
NKJWT *jwt = [[NKJWT alloc] initWithPayload:payloadDictionary];
[jwt setKey:key];
[jwt sign];
NSString *token = [jwt token];
```

### Updating payload

```objective-c
NKJWT *jwt = [[NKJWT alloc] initWithPayload:payloadDictionary];
[jwt signWithKey:key];
NSString *token = [jwt token];

[jwt setPayload:newPayloadDictionary];
[jwt signWithKey:key];
NSString *newToken = [jwt token];
```

