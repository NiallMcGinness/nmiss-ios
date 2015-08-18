//
//  IncEntryViewController.m
//  nmiss-ios
//
//  Created by NIall McGinness on 2015-04-20.
//  Copyright (c) 2015 Niall McGinness. All rights reserved.
//

#import "IncEntryViewController.h"
#import "UIElements.h"
#import "CoreDataStack.h"
#import "IncData.h"

#define kOFFSET_FOR_KEYBOARD 200.0


@interface IncEntryViewController () <NSFetchedResultsControllerDelegate, UITextViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *resolutionTextView;

@property (weak, nonatomic) IBOutlet UITextView *incTextView;

@property (weak, nonatomic) IBOutlet UISwitch *statusSwitch;
@property (strong, nonatomic) NSNumber *keyboardHeight;
@property (strong, nonatomic) NSMutableDictionary *incEntryDict;
@property (strong, nonatomic) NSMutableDictionary *incResolutionDict;

@property (weak, nonatomic) IBOutlet UILabel *resolvedStatusLabel;

@end

@implementation IncEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self checkSubviews];
    [self incEntryDict];
    [self checkStatus];
    [self.view addSubview:[self incTextView]];
    [self.view addSubview:[self editToolbar]];
    self.resolutionTextView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getKeyboardHeight:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}

-(void)getKeyboardHeight:(NSNotification *)notification{
    CGRect keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardBeginFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    CGRect keyboardFrameEnd = [self.view convertRect:keyboardEndFrame toView:nil];
    CGRect keyboardFrameBegin = [self.view convertRect:keyboardBeginFrame toView:nil];
    CGFloat keyboardHeight = (keyboardFrameBegin.origin.y - keyboardFrameEnd.origin.y);
    [self keyboardHeight:keyboardHeight];
    NSLog(@"keyboard height : %f",[_keyboardHeight floatValue]);
}

-(NSNumber *)keyboardHeight:(CGFloat)keyboardHeightFloat{
    NSNumber *keyboardHeight = [NSNumber numberWithFloat:keyboardHeightFloat];
    _keyboardHeight = keyboardHeight;
    return _keyboardHeight;
}


-(NSMutableDictionary *)incEntryDict {
    NSMutableDictionary *incEntryDict = [[NSMutableDictionary alloc] init];
    _incEntryDict = incEntryDict;
    return _incEntryDict;
}

-(void)checkStatus{
    BOOL resolutionStatus = [_statusSwitch isOn];
    if (!resolutionStatus) {
        [_resolvedStatusLabel setText:@"UNRESOLVED"];
        [_resolvedStatusLabel setTextColor:[UIColor redColor]];
    } else {
        [_resolvedStatusLabel setText:@"RESOLVED"];
        [_resolvedStatusLabel setTextColor:[UIColor greenColor]];
    }
}


-(void)checkSubviews{
    //NSLog(@" description of inc add %@" , [[self.view subviews] description]);
    for (UIToolbar *item in [self.view subviews]){
        if (item.tag == 123) {
            
            [item removeFromSuperview];
        }
    }
     
}

- (void)dismissSelf {
    
    
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)saveWasPressed{
    if (self.entry != nil) {
        [self updateInc];
    } else {
        [self insertInc];
    }
    [self dismissSelf];
}

-(void)updateInc{
    self.entry.body = _incEntryDict[@"body"];
    CoreDataStack *incCoreData = [CoreDataStack defaultStack];
    [incCoreData saveContext];
}

-(void)insertInc{
    
    if (_incEntryDict[@"body"] != nil) {
        
    
    CoreDataStack *incCoreData = [CoreDataStack defaultStack];
    IncData *newentry = [NSEntityDescription insertNewObjectForEntityForName:@"IncData" inManagedObjectContext:incCoreData.managedObjectContext];
    
    newentry.body = _incEntryDict[@"body"];
    
    [incCoreData saveContext];
    
    }
}

-(void)noReponseToAddFromServer{
    
    if (_incEntryDict[@"body"] != nil) {
        
        
        CoreDataStack *incCoreData = [CoreDataStack defaultStack];
        IncData *newentry = [NSEntityDescription insertNewObjectForEntityForName:@"IncData" inManagedObjectContext:incCoreData.managedObjectContext];
        
        newentry.body = _incEntryDict[@"body"];
        
        [incCoreData saveContext];
    }

}


 
- (IBAction)resolutionSwitchPressed:(UISwitch *)sender {
    
    [self checkStatus];
    NSLog(@" state of switch %hhd",[sender isOn]);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UIToolbar *)editToolbar{
    UIToolbar *editToolbar = [[UIElements alloc] createTopToolBar];
    editToolbar.clipsToBounds = true;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:nil    action:@selector(saveWasPressed)];
    
    UIBarButtonItem *flexibleButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:nil action:@selector(dismissSelf)];
    
    
    [editToolbar setItems:@[saveButton, flexibleButton, cancelButton] animated:false];
    [self.incTextView setInputAccessoryView:editToolbar];
    
    return editToolbar;
    
}

-(UITextView *)incTextView {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    UITextView *incTextView = [[UITextView alloc] initWithFrame:CGRectMake(5.0, 60.0, screenBounds.size.width , screenBounds.size.height *0.25)];
    incTextView.delegate = self;
    if (self.entry) {
        
        incTextView.text = self.entry.body;
    
    }
    
   return incTextView;
}

-(UIButton *)moveDownButton{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat keyboardHeight = [_keyboardHeight floatValue];
    UIButton *movedown = [[UIButton alloc] initWithFrame:CGRectMake(screenBounds.size.width - 50.0 , keyboardHeight + 5.0, 50.0, 50.0)];
    [movedown setTitle:@"down" forState:UIControlStateNormal];
    [movedown setBackgroundColor:[UIColor redColor]];
    [movedown addTarget:self action:@selector(moveDownWasPressed) forControlEvents:UIControlEventTouchUpInside];
    return movedown;
}

-(void)moveDownWasPressed{
    NSLog(@" down was pressed ");
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    [_resolutionTextView becomeFirstResponder];
    CGRect rect = self.view.frame;
    rect.origin.y -= [_keyboardHeight floatValue];
    self.view.frame = rect;
    NSLog(@"keyboard height : %f",[_keyboardHeight floatValue]);
    [UIView commitAnimations];
}

-(UIButton *)moveUpButton{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    UIButton *moveUpButton = [[UIButton alloc] initWithFrame:CGRectMake(screenBounds.size.width - 50.0 , screenBounds.size.height - 50.0, 50.0, 50.0)];
    [moveUpButton setTitle:@"up" forState:UIControlStateNormal];
    [moveUpButton setBackgroundColor:[UIColor redColor]];
    [moveUpButton addTarget:self action:@selector(moveUpWasPressed) forControlEvents:UIControlEventTouchUpInside];
    return moveUpButton;
}

-(void)moveUpWasPressed{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    CGRect rect = self.view.frame;
    rect.origin.y = -1.0;
    self.view.frame = rect;
    [_incTextView becomeFirstResponder];
    [UIView commitAnimations];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
   return YES;
    
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@" text view has begun editing");
    [textView becomeFirstResponder];
    if (textView == self.resolutionTextView) {
        [self.view addSubview:[self moveUpButton]];
        [_resolutionTextView becomeFirstResponder];
    } else {
        [self.view addSubview:[self moveDownButton]];
        [textView becomeFirstResponder];
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    
    NSString *currenttext = textView.text;
    NSLog(@" textview did change %@", textView.text);
    [_incEntryDict setObject:currenttext forKey:@"body"];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    

    NSLog(@" textview did end editing ");
    [textView resignFirstResponder];
}




@end
