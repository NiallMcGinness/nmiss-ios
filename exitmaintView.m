//
//  exitmaintView.m
//  nmiss-ios
//
//  Created by NIall McGinness on 2015-05-09.
//  Copyright (c) 2015 Niall McGinness. All rights reserved.
//

#import "exitmaintView.h"

@interface exitmaintView ()

@end

@implementation exitmaintView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
