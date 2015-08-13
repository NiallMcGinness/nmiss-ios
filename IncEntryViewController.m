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
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
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

- (void)keyboardFrameWillChange:(NSNotification *)notification
{
    
    
    CGRect keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardBeginFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    UIViewAnimationCurve animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] integerValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = self.view.frame;
    
    if (!CGRectContainsPoint(newFrame, self.incTextView.frame.origin) ) {
    
    CGRect keyboardFrameEnd = [self.view convertRect:keyboardEndFrame toView:nil];
    CGRect keyboardFrameBegin = [self.view convertRect:keyboardBeginFrame toView:nil];
    
    newFrame.origin.y -= (keyboardFrameBegin.origin.y - keyboardFrameEnd.origin.y);
    self.view.frame = newFrame;
    
    [UIView commitAnimations];
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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
   return YES;
    
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@" text view has begun editing");
    [textView becomeFirstResponder];
    if (textView == self.resolutionTextView) {
        [_resolutionTextView becomeFirstResponder];
    } else {
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


-(void)keyboardWillShow{
    // Animate the current view out of the way
    NSLog(@" is view2 first repsonder ? %d ", [_resolutionTextView isFirstResponder] );
    if (self.view.frame.origin.y >= 0 && [_resolutionTextView isFirstResponder] )
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}



//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}



@end
