#import <XCTest/XCTest.h>
#import <XNGAPIClient/XNGOAuthHandler.h>
#import <SAMKeychain/SAMKeychain.h>

#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

@interface XNGOAuthHandlerTests : XCTestCase

@end

@implementation XNGOAuthHandlerTests

- (void)testUserIDGettingWhenNotInKeychain {
    [SAMKeychain deletePasswordForService:@"com.xing.iphone-app-2010" account:@"UserID"];

    XNGOAuthHandler *classUnderTest = [[XNGOAuthHandler alloc] init];
    expect(classUnderTest.userID).to.beNil;
}

- (void)testUserIDGettingWhenInKeychain {
    [SAMKeychain setPassword:@"3" forService:@"com.xing.iphone-app-2010" account:@"UserID"];

    XNGOAuthHandler *classUnderTest = [[XNGOAuthHandler alloc] init];
    expect(classUnderTest.userID).to.equal(@"3");
}

- (void)testAccessTokenGettingWhenNotInKeychain {
    [SAMKeychain deletePasswordForService:@"com.xing.iphone-app-2010" account:@"AccessToken"];

    XNGOAuthHandler *classUnderTest = [[XNGOAuthHandler alloc] init];
    expect(classUnderTest.accessToken).to.beNil;
}

- (void)testAccessTokenGettingWhenInKeychain {
    [SAMKeychain setPassword:@"12345" forService:@"com.xing.iphone-app-2010" account:@"AccessToken"];

    XNGOAuthHandler *classUnderTest = [[XNGOAuthHandler alloc] init];
    expect(classUnderTest.accessToken).to.equal(@"12345");
}

- (void)testTokenSecretGettingWhenNotInKeychain {
    [SAMKeychain deletePasswordForService:@"com.xing.iphone-app-2010" account:@"TokenSecret"];

    XNGOAuthHandler *classUnderTest = [[XNGOAuthHandler alloc] init];
    expect(classUnderTest.tokenSecret).to.beNil;
}

- (void)testTokenSecretGettingWhenInKeychain {
    [SAMKeychain setPassword:@"65785" forService:@"com.xing.iphone-app-2010" account:@"TokenSecret"];

    XNGOAuthHandler *classUnderTest = [[XNGOAuthHandler alloc] init];
    expect(classUnderTest.tokenSecret).to.equal(@"65785");
}

- (void)testXAuthSavingToKeychain {
    NSDictionary *responseParameters = @{@"user_id": @"123", @"oauth_token": @"45678", @"oauth_token_secret": @"54321"};

    XNGOAuthHandler *classUnderTest = [[XNGOAuthHandler alloc] init];
    [classUnderTest saveXAuthResponseParametersToKeychain:responseParameters success:nil failure:nil];

    NSString *userID = [SAMKeychain passwordForService:@"com.xing.iphone-app-2010" account:@"UserID"];
    expect(userID).to.equal(@"123");

    NSString *accessToken = [SAMKeychain passwordForService:@"com.xing.iphone-app-2010" account:@"AccessToken"];
    expect(accessToken).to.equal(@"45678");

    NSString *tokenSecret = [SAMKeychain passwordForService:@"com.xing.iphone-app-2010" account:@"TokenSecret"];
    expect(tokenSecret).to.equal(@"54321");
}

- (void)testSaving
{
    XNGOAuthHandler *classUnderTest = [[XNGOAuthHandler alloc] init];
    [classUnderTest saveUserID:@"3" accessToken:@"1234567" secret:@"890" success:nil failure:nil];

    NSString *userID = [SAMKeychain passwordForService:@"com.xing.iphone-app-2010" account:@"UserID"];
    expect(userID).to.equal(@"3");

    NSString *accessToken = [SAMKeychain passwordForService:@"com.xing.iphone-app-2010" account:@"AccessToken"];
    expect(accessToken).to.equal(@"1234567");

    NSString *tokenSecret = [SAMKeychain passwordForService:@"com.xing.iphone-app-2010" account:@"TokenSecret"];
    expect(tokenSecret).to.equal(@"890");
}

- (void)testDeleting {
    XNGOAuthHandler *classUnderTest = [[XNGOAuthHandler alloc] init];
    [classUnderTest deleteKeychainEntries];

    NSString *userID = [SAMKeychain passwordForService:@"com.xing.iphone-app-2010" account:@"UserID"];
    expect(userID).to.beNil;

    NSString *accessToken = [SAMKeychain passwordForService:@"com.xing.iphone-app-2010" account:@"AccessToken"];
    expect(accessToken).to.beNil;

    NSString *tokenSecret = [SAMKeychain passwordForService:@"com.xing.iphone-app-2010" account:@"TokenSecret"];
    expect(tokenSecret).to.beNil;
}

@end
