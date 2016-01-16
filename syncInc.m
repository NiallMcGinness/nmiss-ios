//
//  syncInc.m
//  nmiss-ios
//
//  Created by NIall McGinness on 2015-08-26.
//  Copyright (c) 2015 Niall McGinness. All rights reserved.
//

#import "syncInc.h"
#import "tokenStorage.h"

@interface syncInc()



@end

@implementation syncInc


-(void)getIncsFromServer:(NSMutableDictionary *)resultDict{
    
    NSDictionary *mobileKey = [tokenStorage getToken];
    NSDictionary *uploadDictionary = @{@"type":@"incidentGet",@"data":@{ @"mobileKey":mobileKey[@"token"]} };
    NSError *setDataError;
    NSURL *uploadURL = [NSURL URLWithString:@"https://nearmiss.co/api"];
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
            if (!jsonResponse) {
                NSLog(@" did not recieve confirmation from server ");
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [resultDict setObject:@"error" forKey:@"response"];
                    
                }];
            }
            
            else{
                // nsurl session operates on background thread, to update UI we must pass back to main thread ..
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    NSLog(@" data in response :  %@ ", jsonResponse );
                    [resultDict setObject:jsonResponse forKey:@"response"];
                                  }];
            }
        }
        else {
           
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSLog(@" error from server  :   %@", error);
                [resultDict setObject:@"error" forKey:@"response"];
            }];
            
        }
    }];
    
    [postDataTask resume];
    
}

-(void)getFromServer:(NSMutableDictionary *)resultDict inputCommand:(NSString *)inputString {
    
    NSDictionary *mobileKey = [tokenStorage getToken];
    NSDictionary *uploadDictionary = @{@"type":inputString,@"data":@{ @"mobileKey":mobileKey[@"token"]} };
    NSError *setDataError;
    NSURL *uploadURL = [NSURL URLWithString:@"https://nearmiss.co/api"];
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
            if (!jsonResponse) {
                NSLog(@" did not recieve confirmation from server ");
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [resultDict setObject:@"error" forKey:@"response"];
                    
                }];
            }
            
            else{
                // nsurl session operates on background thread, to update UI we must pass back to main thread ..
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    NSLog(@" data in response :  %@ ", jsonResponse );
                    [resultDict setObject:jsonResponse forKey:@"response"];
                }];
            }
        }
        else {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSLog(@" error from server  :   %@", error);
                [resultDict setObject:@"error" forKey:@"response"];
            }];
            
        }
    }];
    
    [postDataTask resume];
}


@end
