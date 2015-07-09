//
//  UIElements.h
//  nmiss-ios
//
//  Created by NIall McGinness on 2015-04-17.
//  Copyright (c) 2015 Niall McGinness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIElements : NSObject

@property UIToolbar *mainToolbar;

-(UIToolbar *)createMainToolbar;
-(UIToolbar *)createTopToolBar;
-(UIToolbar *)createBottomToolBar;

@end
