//
//  HelpStepEntry.m
//  nmiss-ios
//
//  Created by NIall McGinness on 2016-01-13.
//  Copyright © 2016 Niall McGinness. All rights reserved.
//

#import "HelpStepEntry.h"
#import "CoreDataStack.h"
#import "HelpData.h"
#import "HelpDetail.h"
#import "textProcessor.h"

@interface HelpStepEntry ()
@property (weak, nonatomic) IBOutlet UITextView *helpStepText;

@end

@implementation HelpStepEntry

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmissKeyboard:)];
    [tap setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:tap];

    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dissmissKeyboard:)];
    [swipe setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [self.view addGestureRecognizer:swipe];
    NSLog(@"help sheet id when detail view loads %@", _titleEntry.helpsheetID);
    if (_titleEntry.helpsheetID == nil) {
        [self dismissSelf];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)disregardWasPressed:(UIBarButtonItem *)sender {
    [self dismissSelf];
}
- (IBAction)saveWasPressed:(id)sender {
    [self insertNewStep];
}
- (void)dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}
-(void)dissmissKeyboard: (UITapGestureRecognizer *)recognizer{
       NSLog(@"gesture detected did end editing");
        [self.view endEditing:true];
}

-(void)insertNewStep{
    
    CoreDataStack *CoreData = [CoreDataStack defaultStack];
    HelpDetail *newentry = [NSEntityDescription insertNewObjectForEntityForName:@"HelpDetail" inManagedObjectContext:CoreData.managedObjectContext];
    
    NSString *helpsheetID = _titleEntry.helpsheetID;
    newentry.helpsheetID = helpsheetID;
    
    NSString *text = _helpStepText.text;
    newentry.body = text;
    NSMutableString *helpsheetStepID  = [textProcessor generateID];
    NSLog(@"helpsheetstepid generated %@ ", helpsheetStepID);
    newentry.helpsheetStepID = helpsheetStepID;
    NSLog(@"save step trigered with helpsheetID %@, helpsheetStepID %@, body %@", newentry.helpsheetID, newentry.helpsheetStepID, newentry.body);
    [CoreData saveContext];
    
    return [self dismissSelf];
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
