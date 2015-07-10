//
//  tokenStorage.m
//  nmiss-ios
//
//  Created by NIall McGinness on 2015-07-09.
//  Copyright (c) 2015 Niall McGinness. All rights reserved.
//

#import "tokenStorage.h"

@implementation tokenStorage

+(void)storeTokenSecurely:(NSString *)token{
  
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    NSLog(@" token is : %@ ", token );
    NSString *website = @"https://nearmiss.co";
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword;
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked;
    keychainItem[(__bridge id)kSecAttrServer] = website;
    
    if(SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr)
    {
        NSLog(@"token already exists");
        NSMutableDictionary *attributesToUpdate = [NSMutableDictionary dictionary];
        attributesToUpdate[(__bridge id)kSecValueData] = [token dataUsingEncoding:NSUTF8StringEncoding];
        
        OSStatus sts = SecItemUpdate((__bridge CFDictionaryRef)keychainItem, (__bridge CFDictionaryRef)attributesToUpdate);
        
        NSLog(@"when updating token error code is : %d", (int)sts);
        
    }else
    {
        keychainItem[(__bridge id)kSecValueData] = [token dataUsingEncoding:NSUTF8StringEncoding];
        
        OSStatus sts = SecItemAdd((__bridge CFDictionaryRef)keychainItem, NULL);
        NSLog(@"when storing token for the first time error code is : %d", (int)sts);
    }
}


+(NSDictionary *)getToken{

    NSDictionary *token = [NSDictionary dictionary];
    
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    NSString *website = @"https://nearmiss.co";
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword;
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked;
    keychainItem[(__bridge id)kSecAttrServer] = website;
    
    keychainItem[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    keychainItem[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
    
    CFDictionaryRef result = nil;
    
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, (CFTypeRef *)&result);
    NSLog(@"when getting token error code is : %d", (int)status);
    
    if (status == noErr){
        NSDictionary *resultDict = (__bridge_transfer NSDictionary *)result;
        NSData *tknData = resultDict[(__bridge id)kSecValueData];
        NSString *tokenString = [[NSString alloc] initWithData:tknData encoding:NSUTF8StringEncoding];
        token = @{@"token" : tokenString };
    
    } else
    {
        
        NSLog(@"log in/registration token not found ");
    }
    
    return token;

}

+(void)deleteToken{
    
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    NSString *website = @"https://nearmiss.co";
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword;
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked;
    keychainItem[(__bridge id)kSecAttrServer] = website;
    
    if(SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr)
    {
        OSStatus sts = SecItemDelete((__bridge CFDictionaryRef)keychainItem);
        NSLog(@"When deleting token, error code is : %d", (int)sts);
    }else
    {
        NSLog(@" could not find token when tryign to delete it ");
    }
    
}

@end
