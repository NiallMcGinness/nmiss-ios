//
//  HelpEntryViewController.h
//  nmiss-ios
//
//  Created by NIall McGinness on 2015-05-05.
//  Copyright (c) 2015 Niall McGinness. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HelpData;
@class HelpDetail;

@interface HelpEntryViewController : UIViewController

@property  (nonatomic,strong) HelpData *entry;
@property  (nonatomic,strong) HelpDetail *entryStep;
@end
