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



@interface IncEntryViewController () <NSFetchedResultsControllerDelegate, UITextViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *resolutionTextView;

@property (weak, nonatomic) IBOutlet UITextView *incTextView;

@property (weak, nonatomic) IBOutlet UISwitch *statusSwitch;
@property (strong, nonatomic) NSNumber *keyboardHeight;
@property (strong, nonatomic) NSMutableDictionary *incEntryDict;
@property (strong, nonatomic) NSMutableDictionary *resolutionEntryDict;

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
    NSLog(@" insert called ... title %@ ... body %@ ",_incEntryDict[@"title"],_incEntryDict[@"body"]);
    
    if (_incEntryDict[@"title"] != nil) {
        self.entry.title = _incEntryDict[@"title"];
    }
    if (_incEntryDict[@"body"] != nil ) {
        self.entry.body = _incEntryDict[@"body"];
    }
    self.entry.status = [_statusSwitch isOn];
    
    CoreDataStack *incCoreData = [CoreDataStack defaultStack];
    [incCoreData saveContext];
}

-(void)insertInc{
    
    if (_incEntryDict[@"title"] != nil) {
        
    
    CoreDataStack *incCoreData = [CoreDataStack defaultStack];
    IncData *newentry = [NSEntityDescription insertNewObjectForEntityForName:@"IncData" inManagedObjectContext:incCoreData.managedObjectContext];
    
    newentry.title = _incEntryDict[@"title"];
    newentry.body = _incEntryDict[@"body"];
    newentry.status = [_statusSwitch isOn];
    [incCoreData saveContext];
    
    }
}
/*
-(void)sendNewIncToServer{
    
    if (_incEntryDict[@"title"] != nil) {
        NSString *title = _incEntryDict[@"title"];
    } else {
        return;
    }

    if ([_statusSwitch isOn]) {
        NSString *status = @"resolved";
    } else {
        NSString *status = @"unresolved";
    }
    
   
    
    if (_incEntryDict[@"body"] != nil ) {
        NSString *resolution = _incEntryDict[@"body"];
    }
        
    
}
*/
- (IBAction)resolutionSwitchPressed:(UISwitch *)sender {
    
    [self checkStatus];
    NSLog(@" state of switch %d",[sender isOn]);
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
    UITextView *incTextView = [[UITextView alloc] initWithFrame:CGRectMake(8.0, 90.0, screenBounds.size.width , screenBounds.size.height *0.24)];
    [incTextView setFont:[UIFont fontWithName:@"ArialMT" size:14.0]];
    incTextView.delegate = self;
    if (self.entry) {
        
        incTextView.text = self.entry.title;
        _resolutionTextView.text = self.entry.body;
        [_statusSwitch setOn:self.entry.status animated:NO];
        [self checkStatus];
}
    
   return incTextView;
}

-(UIButton *)moveDownButton{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat keyboardHeight = [_keyboardHeight floatValue];
    UIButton *movedown = [[UIButton alloc] initWithFrame:CGRectMake(screenBounds.size.width - 55.0 , keyboardHeight + 5.0, 45.0, 45.0)];
    movedown.layer.cornerRadius = 25.0;
   
    UIImage *downImage = [UIImage imageNamed:@"down.png"];
    [movedown setImage:downImage forState:UIControlStateNormal];
    UIColor *nmissOrange = [UIColor colorWithRed:255.0/255.0 green:70.0/255.0 blue:0.0/255.0 alpha:1.0];
    [movedown setBackgroundColor:nmissOrange];
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
    NSLog(@"down button pressed: %f", rect.size.height);
    self.view.frame = rect;
    NSLog(@"keyboard height : %f",[_keyboardHeight floatValue]);
    [UIView commitAnimations];
}

-(UIButton *)moveUpButton{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    UIButton *moveUpButton = [[UIButton alloc] initWithFrame:CGRectMake(screenBounds.size.width - 55.0 , screenBounds.size.height - 55.0, 45.0, 45.0)];
    moveUpButton.layer.cornerRadius = 25.0;
    UIImage *upImage = [UIImage imageNamed:@"up.png"];
    [moveUpButton setImage:upImage forState:UIControlStateNormal];
    UIColor *nmissOrange = [UIColor colorWithRed:255.0/255.0 green:70.0/255.0 blue:0.0/255.0 alpha:1.0];
    [moveUpButton setBackgroundColor:nmissOrange];
    [moveUpButton addTarget:self action:@selector(moveUpWasPressed) forControlEvents:UIControlEventTouchUpInside];
    return moveUpButton;
}

-(void)moveUpWasPressed{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    CGRect rect = self.view.frame;
    rect.origin.y = -0.001;
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
    
    if (textView == self.resolutionTextView) {
        CGRect rect = self.view.frame;
        NSLog(@" y origin %f", rect.origin.y);
        if (rect.origin.y == 0) {
            [self moveDownWasPressed];
            [self.view addSubview:[self moveDownButton]];
        }
        [self.view addSubview:[self moveUpButton]];
        [_resolutionTextView becomeFirstResponder];
        
    } else {
        CGRect rect = self.view.frame;
        rect.origin.y = -0.001;
        self.view.frame = rect;
        [self.view addSubview:[self moveDownButton]];
        [textView becomeFirstResponder];
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    
    NSString *currenttext = textView.text;
    NSLog(@" textview did change %@", textView.text);
    
   
    if (textView == _resolutionTextView){
        NSLog(@"resolutionTextView is being edited");
        [_incEntryDict setObject:currenttext forKey:@"body"];

    } else {
        [_incEntryDict setObject:currenttext forKey:@"title"];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    NSLog(@" textview did end editing ");
    [textView resignFirstResponder];
}

#pragma mark  --- networking

-(void)sendNewInc:(NSDictionary *)uploadDictionary{
    
    NSError *setDataError;
    NSURL *uploadURL = [NSURL URLWithString:@"https://nearmiss.co/mobileRegister"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:uploadDictionary options:NSJSONWritingPrettyPrinted error:&setDataError];
    NSMutableURLRequest *uploadRequest = [NSMutableURLRequest requestWithURL:uploadURL];
    
    if (!jsonData) NSLog(@" JSON data is nil %@ ", setDataError);
    
    [uploadRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    uploadRequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:uploadDictionary options:NSJSONWritingPrettyPrinted error:&setDataError];
    uploadRequest.HTTPMethod = @"PUT";
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:uploadRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            
            NSLog(@" request response from server is :  %@   :  and description of response  %@", response, response.description);
            NSDictionary* jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:kNilOptions
                                                                           error:&error];
            NSLog(@" data in response :  %@ ", jsonResponse);
            if (!jsonResponse) {
                NSLog(@" did not recieve confirmation from server ");
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not sync with server"
                                                                    message:@"please check your internet connection"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];                }];
            }
            
            else{
                // nsurl session operates on background thread, to update UI we must pass back to main thread ..
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    NSLog(@" data in response :  %@ ", jsonResponse[@"type"] );
                                    }];
            }
        }
        else {
            NSLog(@" error from server  :   %@", error);        }
    }];
    
    [postDataTask resume];
    
}


@end
