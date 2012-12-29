//
//  NetworkOperations.h
//  Woman'sMagazine
//
//  Created by Ahmad al-Moraly on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "AFNetworking.h"

@interface NetworkOperations : AFHTTPClient

+(void)POSTResponseWithURL:(NSString *)url 
             andParameters:(NSDictionary *)parameters 
                   success:(void (^)(id response))success 
                   failure:(void (^)(NSHTTPURLResponse *urlResponse, NSError *error))failure;

+(void)uploadImage:(UIImage *)image 
    withParameters:(NSDictionary *)parameters 
           success:(void (^)(id response))success 
           failure:(void (^)(NSHTTPURLResponse *urlResponse, NSError *error))failure;

@end
