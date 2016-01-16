//
//  HelpStepEntry.h
//  nmiss-ios
//
//  Created by NIall McGinness on 2016-01-13.
//  Copyright © 2016 Niall McGinness. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HelpData;
@class HelpDetail;


@interface HelpStepEntry : UIViewController

@property  (nonatomic,strong) HelpData *titleEntry;
@property (nonatomic, strong) HelpDetail *stepEntry;

@end
