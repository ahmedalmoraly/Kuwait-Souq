//
//  NetworkOperations.m
//  Woman'sMagazine
//
//  Created by Ahmad al-Moraly on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NetworkOperations.h"
#import "NetworkClient+Private.h"
#import "NSString+HTML.h"

@interface NetworkOperations()<NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableArray *responseArrayOfRecords;

-(id)parseResponseData:(NSData *)responseData ;

@end

@implementation NetworkOperations

@synthesize responseArrayOfRecords = _responseArrayOfRecords;

+(void)POSTResponseWithURL:(NSString *)url andParameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSHTTPURLResponse *, NSError *))failure {
    //NSLog(@"Start Uploading");
    [[NetworkClient_Private sharedClient] postPath:[NSString stringWithFormat:@"mobile.php?%@", url]  parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NetworkOperations *magazineClient = [[NetworkOperations alloc] init];
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"From Net %@", str);
       magazineClient.responseArrayOfRecords = [magazineClient parseResponseData:responseObject];
        success(magazineClient.responseArrayOfRecords);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(nil,error);
    }];
    //NSLog(@"Finish Uploading, waiting for response");
}

+(void)uploadImage:(UIImage *)image withParameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSHTTPURLResponse *, NSError *))failure {
    NSString *mimeType;
    NSData *imageData = UIImagePNGRepresentation(image);
    mimeType = @"image/png";
    if (!imageData) {
        imageData = UIImageJPEGRepresentation(image, 0.7);
        mimeType = @"image/jpg";
    }
    NSMutableURLRequest *request = [[NetworkClient_Private sharedClient] multipartFormRequestWithMethod:@"POST" path:@"mobile.php?" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"upload" fileName:@"test.png" mimeType:mimeType];
    }];
    
    AFHTTPRequestOperation *operation = [[[AFHTTPRequestOperation alloc] initWithRequest:request] autorelease];
    [operation setUploadProgressBlock:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
        //NSLog(@"Sent %d of %d bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation.responseString);
        //NSLog(@"success with response: %@", operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"[ERROR]: %@", error.description);
        failure(operation.response, error);
    }];
    
    NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
    [queue addOperation:operation];
}



#pragma mark - Getters:

-(NSMutableArray *)responseArrayOfRecords {
    if (!_responseArrayOfRecords) {
        _responseArrayOfRecords = [NSMutableArray array];
    }
    return _responseArrayOfRecords;
}


-(id)parseResponseData:(NSData *)responseData {
    if (!responseData) {
        return nil;
    }
    // get responseString form the responseData
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    
    if (!responseString) {
        //NSLog(@"[ERROR]: Encoding is Not Supported");
        return nil;
    }
    
    //responseString = [responseString stringByConvertingHTMLToPlainText];
    
    //NSLog(@"Response String: %@", responseString);
    // split the string by #@
    NSArray *splittedStrings = [responseString componentsSeparatedByString:@"#@"];
    
    if (!splittedStrings) {
        //NSLog(@"[ERROR]: input string wasn't in the right format");
        return nil;
    }
    
    
    NSMutableArray *parsedItems = [NSMutableArray array];
    
    for (NSString *objectStr in splittedStrings) {
        NSString *item = [NSString stringWithString:objectStr];
        if ([item hasPrefix:@"@"]) {
            item = [item substringFromIndex:1];
        }
        
        if ([item hasSuffix:@"#"]) {
            item = [item substringToIndex:item.length-1];
        }
        
        if (![item isEqualToString:@""]) {
            NSArray *splittedItem = [item componentsSeparatedByString:@","];
            if (splittedItem) {                
                [parsedItems addObject:splittedItem];
            }
        }
    }
    return parsedItems;
}


@end
