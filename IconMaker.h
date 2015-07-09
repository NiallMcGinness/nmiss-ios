//
//  IconMaker.h
//  nmiss-ios
//
//  Created by NIall McGinness on 2015-04-15.
//  Copyright (c) 2015 Niall McGinness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IconMaker : NSObject

@property UIImage *image;

+ (UIColor*)colorWhite;
+ (UIColor*)colorBlack;

-(UIImage *)createBackIconImage;
-(UIImage *)createBackChevronImage;
-(UIImage *)createMaintIconImage;
-(UIImage *)createIncIconImage;
-(UIImage *)logIncImage;

@end
