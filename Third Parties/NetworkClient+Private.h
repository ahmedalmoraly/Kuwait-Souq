//
//  NetworkClient+Private.h
//  Woman'sMagazine
//
//  Created by Ahmad al-Moraly on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"


NSString * const kAFGowallaClientID = @"e7ccb7d3d2414eb2af4663fc91eb2793";

NSString * const kNetworkBaseURLString = @"http://sooqalq8.com/";

@interface NetworkClient_Private : AFHTTPClient

+(NetworkClient_Private *)sharedClient;

@end

@implementation NetworkClient_Private

+(NetworkClient_Private *)sharedClient {
    static NetworkClient_Private *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kNetworkBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
    }   
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"text/*"];
    
    // X-Gowalla-API-Key HTTP Header; see http://api.gowalla.com/api/docs
	[self setDefaultHeader:@"X-Gowalla-API-Key" value:kAFGowallaClientID];
	
	// X-Gowalla-API-Version HTTP Header; see http://api.gowalla.com/api/docs
	[self setDefaultHeader:@"X-Gowalla-API-Version" value:@"1"];
    
    return self;
}

@end