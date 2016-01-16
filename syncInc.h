//
//  syncInc.h
//  nmiss-ios
//
//  Created by NIall McGinness on 2015-08-26.
//  Copyright (c) 2015 Niall McGinness. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface syncInc : NSObject

-(void)getIncsFromServer:(NSMutableDictionary *)resultDict;

-(void)getFromServer:(NSMutableDictionary *)resultDict inputCommand:(NSString *)inputString;

@end
