//
//  tokenStorage.h
//  nmiss-ios
//
//  Created by NIall McGinness on 2015-07-09.
//  Copyright (c) 2015 Niall McGinness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface tokenStorage : NSObject

+(void)storeTokenSecurely:(NSString *)token;
+(NSDictionary *)getToken;
+(void)deleteToken;

@end
