//
//  TabViewController.m
//  nmiss-ios
//
//  Created by NIall McGinness on 2015-05-02.
//  Copyright (c) 2015 Niall McGinness. All rights reserved.
//

#import "TabViewController.h"
#import "UIElements.h"
#import "IconMaker.h"


@interface TabViewController () <UITabBarDelegate>

@end

@implementation TabViewController

- (void)viewDidLoad {
    //[super viewDidLoad];
    UIColor *nmissOrange = [UIColor colorWithRed:255.0/255.0 green:70.0/255.0 blue:0.0/255.0 alpha:1.0];    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor:nmissOrange];
    [[UITabBar appearance] setClipsToBounds:true];
    for (UITabBarItem *item in self.tabBar.items) {
        
            /// this loop will stop unselected tabbar items from being grey
            item.image = [item.image imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            item.selectedImage = [item.image imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
        if (item.tag == 3 ) {
            [item setImage:[UIImage imageNamed:@"backRightPlain.png"]];
            item.image = [item.image imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            item.selectedImage = [item.image imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            }
        }
  }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{

    NSLog(@"viewWillDisappear triggered");
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    NSLog(@"launch options triggered");
    return true;
}

-(void) configTabBar
{
    NSLog(@"launch options triggered");
    UITabBarController *tabBarController = [self tabBarController];
    UITabBar *tabBar = tabBarController.tabBar;
    
    for (UITabBarItem  *tab in tabBar.items) {
        
        tab.image = [tab.image imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
        tab.selectedImage = [tab.image imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
