//
//  HelpStepEntry.m
//  nmiss-ios
//
//  Created by NIall McGinness on 2016-01-13.
//  Copyright © 2016 Niall McGinness. All rights reserved.
//

#import "HelpStepEntry.h"
#import "CoreDataStack.h"
#import "HelpDetail.h"

@interface HelpStepEntry ()
@property (weak, nonatomic) IBOutlet UITextView *helpStepText;

@end

@implementation HelpStepEntry

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmissKeyboard:)];
    [self.view addGestureRecognizer:tap];

    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dissmissKeyboard:)];
    [self.view addGestureRecognizer:swipe];
    
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)disregardWasPressed:(UIBarButtonItem *)sender {
    [self dismissSelf];
}
- (IBAction)saveWasPressed:(id)sender {
}
- (void)dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}
-(void)dissmissKeyboard: (UITapGestureRecognizer *)recognizer{
    NSLog(@"tap detected , is first responder %hhd",[self.view isFirstResponder] );
    if ([self.view isFirstResponder] == true) {
         [self.view resignFirstResponder];
    } else {
         NSLog(@"tap detected did end editing");
        [self.view endEditing:true];
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
