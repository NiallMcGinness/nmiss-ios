//
//  LoadingScreen.m
//  nmiss-ios
//
//  Created by NIall McGinness on 2015-09-08.
//  Copyright (c) 2015 Niall McGinness. All rights reserved.
//

#import "LoadingScreen.h"

@implementation LoadingScreen

-(UIView *)loadingView{

    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    UIView *loading = [[UIView alloc] initWithFrame:CGRectMake(0.0, 60.0, screenBounds.size.width, screenBounds.size.height)];
    [loading setBackgroundColor:[UIColor blackColor]];
    [loading setTag:10];
    return loading;
}

@end
