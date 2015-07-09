//
//  UIElements.m
//  nmiss-ios
//
//  Created by NIall McGinness on 2015-04-17.
//  Copyright (c) 2015 Niall McGinness. All rights reserved.
//

#import "UIElements.h"
#import "IconMaker.h"

@implementation UIElements


-(UIToolbar *)createMainToolbar{
    
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    float heightOfToolbar = 50.0;
    float yPositionOfToolbar = screenBounds.size.height - heightOfToolbar;
    
    UIToolbar *mainToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, yPositionOfToolbar, screenBounds.size.width, heightOfToolbar)];
    
    UIColor *nmissOrange = [UIColor colorWithRed:255.0/255.0 green:70.0/255.0 blue:0.0/255.0 alpha:1.0];
    UIColor *pzomeWhite = [UIColor whiteColor];
    mainToolbar.barTintColor = nmissOrange;
    
    UIImage *maintIcon = [[IconMaker new] createMaintIconImage];
    UIImage *incIcon = [[IconMaker new] createIncIconImage];
    
    
    UIBarButtonItem *maintButton = [[UIBarButtonItem alloc] initWithImage:[maintIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:nil action:nil];
    maintButton.imageInsets = UIEdgeInsetsMake(12.0, 0 , -12.0, 0);
    maintButton.tintColor = pzomeWhite;
    maintButton.tag = 1;
    
    UIBarButtonItem *flexibleButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    UIBarButtonItem *incButton = [[UIBarButtonItem alloc] initWithImage:incIcon style:UIBarButtonItemStylePlain target:nil action:nil];
    incButton.imageInsets = UIEdgeInsetsMake(9.0, 10.0 , -9.0, -20.0);
    incButton.tintColor = pzomeWhite;
    incButton.tag = 2;
    
    [mainToolbar setItems:@[maintButton,flexibleButton, incButton] animated:false];
    mainToolbar.tag = 123;
    
    //_mainToolbar = mainToolbar;
    
    return mainToolbar;
}


-(UIToolbar *)createTopToolBar{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    UIToolbar *topToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 20, screenBounds.size.width, screenBounds.size.height *0.07)];
    UIColor *white = [UIColor whiteColor];
    UIColor *nmissOrange = [UIColor colorWithRed:255.0/255.0 green:70.0/255.0 blue:0.0/255.0 alpha:1.0];
    topToolbar.tintColor = nmissOrange;
    topToolbar.barTintColor = white;
    
    return topToolbar;
}


-(UIToolbar *)createBottomToolBar{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat yFraction = screenBounds.size.height *0.1;
     UIToolbar *bottomToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, screenBounds.size.height - yFraction, screenBounds.size.width, yFraction)];
    
    UIColor *white = [UIColor whiteColor];
    UIColor *nmissOrange = [UIColor colorWithRed:255.0/255.0 green:70.0/255.0 blue:0.0/255.0 alpha:1.0];
    bottomToolbar.tintColor = white;
    bottomToolbar.barTintColor = nmissOrange;
    
    return bottomToolbar;

}


@end
