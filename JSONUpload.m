//
//  JSONUpload.m
//  nmiss-ios
//
//  Created by NIall McGinness on 2015-06-03.
//  Copyright (c) 2015 Niall McGinness. All rights reserved.
//

#import "JSONUpload.h"

@implementation JSONUpload

+(void)loadJSON:(NSDictionary *)uploadDictionary{
    
    NSError *setDataError;
    NSURL *uploadURL = [NSURL URLWithString:@"https://nearmiss.co/mobileRegister"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:uploadDictionary options:NSJSONWritingPrettyPrinted error:&setDataError];
    NSMutableURLRequest *uploadRequest = [NSMutableURLRequest requestWithURL:uploadURL];
    
    if (!jsonData) NSLog(@" JSON data is nil %@ ", setDataError);
    
    [uploadRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    uploadRequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:uploadDictionary options:NSJSONWritingPrettyPrinted error:&setDataError];
    uploadRequest.HTTPMethod = @"PUT";
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:uploadRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            
            NSLog(@" request response from server is :  %@   :  and description of response  %@", response, response.description);
            NSDictionary* jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&error];
            NSLog(@" data in response :  %@ ", jsonResponse);
        }
        else {
            NSLog(@" error from server  :   %@", error);        }
    }];
    
    [postDataTask resume];
    
}


@end
