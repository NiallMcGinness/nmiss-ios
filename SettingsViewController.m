//
//  SettingsViewController.m
//  nmiss-ios
//
//  Created by NIall McGinness on 2015-06-23.
//  Copyright (c) 2015 Niall McGinness. All rights reserved.
//

#import "SettingsViewController.h"
#import "tokenStorage.h"

@interface SettingsViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UILabel *followUpLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (strong, nonatomic) NSString *emailEntered;
@property (strong, nonatomic) NSString *nextAction;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    UIColor *nmissOrange = [UIColor colorWithRed:235.0/255.0 green:70.0/255.0 blue:0.0/255.0 alpha:1.0];
    [self.view setBackgroundColor:nmissOrange];
    self.emailTextField.delegate = self;
    [self loadIntroButtons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadIntroButtons{
    
    UIColor *white = [UIColor whiteColor];
    self.titleLabel.textColor = white;
    [self.titleLabel setText:@"please enter your work email " ];
    [self.titleLabel setFont:[UIFont systemFontOfSize:20]];
    
    [self.followUpLabel setText:@""];
    self.followUpLabel.textColor = white;
    [self emailEntered];
   
    _actionButton.layer.borderWidth = 1.0;
    _actionButton.layer.borderColor = white.CGColor;
    _actionButton.layer.cornerRadius = 5.0;
    _actionButton.tintColor = white;
    _actionButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"next was pressed ");
   [self actionButtonWasPressed:_actionButton];
   [self.emailTextField setReturnKeyType:UIReturnKeyDefault ];
   [self.emailTextField resignFirstResponder];
   [self.emailTextField becomeFirstResponder];
    return YES;
}

-(NSString *)emailEntered{
    NSString *emailEntered = [[NSString alloc] init];
    _emailEntered = emailEntered;
    return  _emailEntered;
}

-(NSString *)nextAction{
    NSString *nextAction = [[NSString alloc] init];
    _nextAction = nextAction;
    return nextAction;
}

-(void)reloadKeyboard{
    // change return key from 'next ' back to default, must reload keyboard to take effect
    [self.emailTextField setReturnKeyType:UIReturnKeyDefault ];
    [self.emailTextField resignFirstResponder];
    [self.emailTextField becomeFirstResponder];
    [self reloadInputViews];
}

-(CATransition *)textChangeAnimation{
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.duration = 0.75;
    
    return animation;
}

-(void)processRegisterResponse:(NSString *)responseCode{
    
    if (responseCode == nil) {
        [_emailTextField resignFirstResponder];
        NSString *errorString = @"sorry but we have encountered a problem with our registration system, please exit the app and register via our webpage at nearmiss.co/register";
        return [self.view addSubview:[self errorView:errorString]];
       }
    else if ([responseCode  isEqual: @"userRegistered"]){
                [self.titleLabel.layer addAnimation:[self textChangeAnimation] forKey:@"kCATransitionPush"];
        [self.titleLabel setText:@"please enter your password"];
        [self.actionButton setTitle:@"submit" forState:UIControlStateNormal];
        [self.emailTextField setText:@""];
        [self.emailTextField setSecureTextEntry:YES];
        [self.emailTextField setPlaceholder:@"type password here"];
      
        NSLog(@" email retrieved from email string  %@ ", _emailEntered );
        _nextAction = @"passwordRequest";
        return [self reloadKeyboard];
    }
  
    else if ([responseCode  isEqual: @"userUnregistered"]){
        [self.titleLabel setText:@"please choose a password"];
        [self.emailTextField setSecureTextEntry:YES];
        [self.actionButton setTitle:@"submit" forState:UIControlStateNormal];
        [self.emailTextField setText:@""];
        [self.emailTextField setPlaceholder:@"type password here"];
        _nextAction = @"registerAsAdmin";
        return [self reloadKeyboard];
    }
    else if ([responseCode  isEqual: @"userOnActivationListActivated"]){
        [self.titleLabel setText:@"please enter your password"];
        [self.actionButton setTitle:@"submit" forState:UIControlStateNormal];
        [self.emailTextField setText:@""];
        [self.emailTextField setSecureTextEntry:YES];
        [self.emailTextField setPlaceholder:@"type password here"];
        _nextAction = @"passwordRequest";
        return [self reloadKeyboard];
        
    }
    else if ([responseCode  isEqual: @"userOnActivationListUnactivated"]){
        [self.titleLabel setText:@"enter your activation code"];
        [self.actionButton setTitle:@"submit" forState:UIControlStateNormal];
        [self.emailTextField setText:@""];
        [self.emailTextField setPlaceholder:@"enter activation code here"];
        _nextAction = @"activationTokenRequest";
        return [self reloadKeyboard];
    }
    else {
         [_emailTextField resignFirstResponder];
         NSString *errorString = @"sorry but we have encountered a problem with our registration system, please exit the app and register via our webpage at nearmiss.co/register";
         return [self.view addSubview:[self errorView:errorString]];
    }

    
}

-(void)storeTokenSecurely:(NSString *)token{
   
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    NSLog(@" token is : %@ ", token );
    NSString *website = @"https://nearmiss.co";
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword;
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked;
    keychainItem[(__bridge id)kSecAttrServer] = website;

    if(SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"a token has already been entered", nil)
                                                        message:NSLocalizedString(@"Please update it instead.", )
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
        
    }else
    {
        keychainItem[(__bridge id)kSecValueData] = [token dataUsingEncoding:NSUTF8StringEncoding];
        
        OSStatus sts = SecItemAdd((__bridge CFDictionaryRef)keychainItem, NULL);
        NSLog(@"Error Code: %d", (int)sts);
    }
}

-(void)processPasswordResponse:(NSDictionary *)responseDict{
    
    NSString *responseCode = responseDict[@"type"];
    
    if (responseCode == nil) {
        [_emailTextField resignFirstResponder];
        NSString *errorString = @"sorry but we have encountered a problem, we cannot check your password at the moment  please exit the app and access nearmiss via our webpage at www.nearmiss.co";
        return [self.view addSubview:[self errorView:errorString]];
    }
    
    else if ([responseCode isEqualToString:@"passwordCorrect"]) {
        
        [tokenStorage storeTokenSecurely:responseDict[@"data"][@"token"]];
        [_emailTextField setHidden:YES];
        [_actionButton setHidden:YES];
        [_titleLabel setText:@" You are registered "];
        NSString *successString = @"You can now view trending incidents, create & share help sheets and complete checklists.                                   For more information visit wwww.nearmiss.co/info ";
        [self.view addSubview:[self successView:successString]];
        [_emailTextField resignFirstResponder];
        return;
    }
    
    else if ([responseCode isEqualToString:@"passwordIncorrect"]) {
         [_titleLabel setText:@" incorrect password, try again "];
         [_emailTextField setText:@""];
    }
    
    else if ([responseCode isEqualToString:@"tokenCorrect"]) {
        NSLog(@" mobile key is : %@ ", responseDict[@"data"][@"mobileKey"] );
        [tokenStorage storeTokenSecurely:responseDict[@"data"][@"mobileKey"]];
        [_emailTextField setHidden:YES];
        [_actionButton setHidden:YES];
        [_titleLabel setText:@" You are registered "];
        NSString *successString = @"This device is now registered, to use the website or to register another device please visit wwww.nearmiss.co to set your password ";
        [self.view addSubview:[self successView:successString]];
        [_emailTextField resignFirstResponder];
        return;
        
    }
    
    else if ([responseCode isEqualToString:@"tokenIncorrect"]) {
        [_titleLabel setText:@" token is incorrect, try again "];
        [_emailTextField setText:@""];
    }
    
    else if ([responseCode isEqualToString:@"registeredSuccessfully"]) {
        NSLog(@" mobile key is : %@ ", responseDict[@"data"][@"mobileKey"] );
        [tokenStorage storeTokenSecurely:responseDict[@"data"][@"mobileKey"]];
        NSDictionary *tokenDict = [tokenStorage getToken];
        NSLog(@" stored token is :  %@  --- token from server is : %@", tokenDict[@"token"], responseDict[@"data"][@"mobileKey"]);
        
        [_emailTextField setHidden:YES];
        [_actionButton setHidden:YES];
        [_titleLabel setText:@" Your account is now active "];
        NSString *successString = @"You have set up your account successfully and can add up to ten users to your group. To administer your group, sign in at wwww.nearmiss.co and click on the admin icon on the sidebar ";
        [self.view addSubview:[self successView:successString]];
        [_emailTextField resignFirstResponder];
        return;
        
    }
    
    else  {
        [_emailTextField resignFirstResponder];
        NSString *errorString = @"sorry but we have encountered a problem, we cannot check your password at the moment  please exit the app and access nearmiss via our webpage at www.nearmiss.co";
        return [self.view addSubview:[self errorView:errorString]];
    }
    
    
}


-(UIView *)errorView:(NSString *)errorMessage{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    UIView *errorView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 60.0, screenBounds.size.width, screenBounds.size.height)];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    
    
    NSAttributedString *errorText = [[NSAttributedString alloc] initWithString:errorMessage
                                                                    attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Verdana"  size:18],
                                                                                 NSParagraphStyleAttributeName : paragraph }];
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:errorText];
    
    NSLayoutManager *textLayout = [[NSLayoutManager alloc]init];
    [textStorage addLayoutManager:textLayout];
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.view.bounds.size];
    [textContainer setLineFragmentPadding:30.0];
    [textLayout addTextContainer:textContainer];
    
    UITextView *errorTextView = [[UITextView alloc] initWithFrame:CGRectMake(5.0, screenBounds.size.height *0.45, screenBounds.size.width - 10.0 , screenBounds.size.height - 20.0 )
                                                    textContainer:textContainer];
    
    
    [errorTextView setEditable:NO];
    [errorTextView setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:70.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [errorTextView setTextColor:[UIColor whiteColor]];
    [errorView addSubview:errorTextView];

    return errorView;
}

-(UIView *)successView:(NSString *)successMessage{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    UIView *successView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 60.0, screenBounds.size.width, screenBounds.size.height)];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    
    
    NSAttributedString *errorText = [[NSAttributedString alloc] initWithString:successMessage
                                                                    attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Verdana"  size:16],
                                                                                 NSParagraphStyleAttributeName :paragraph }];
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:errorText];
    
    NSLayoutManager *textLayout = [[NSLayoutManager alloc]init];
    [textStorage addLayoutManager:textLayout];
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.view.bounds.size];
    [textContainer setLineFragmentPadding:30.0];
    [textLayout addTextContainer:textContainer];
    
    UITextView *successTextView = [[UITextView alloc] initWithFrame:CGRectMake(0.0, screenBounds.size.height *0.2, screenBounds.size.width - 10.0 , screenBounds.size.height - 20.0 )
                                                    textContainer:textContainer];
    
    [successTextView setEditable:YES];
    [successTextView setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:70.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [successTextView setTextColor:[UIColor whiteColor]];
    [successView addSubview:successTextView];
    
    return successView;
    
}

-(NSDictionary *)deviceDetails{
    
    UIDevice *deviceType = [UIDevice currentDevice];
    
    NSString *deviceModel = deviceType.model.description;
    NSString *deviceOSVersion = deviceType.systemVersion.description;
    NSString *UUID = [[NSUUID UUID] UUIDString];
    
    NSArray *objectArray = @[UUID,deviceModel,deviceOSVersion];
    NSArray *keyArray = @[@"UUID",@"deviceModel",@"OSVersion"];
    
    NSDictionary *ddets = [[NSDictionary alloc] initWithObjects:objectArray forKeys:keyArray];
    
    return ddets;
    
}

- (IBAction)actionButtonWasPressed:(UIButton *)sender {
    
    
    NSLog(@"button was pressed, email entered %@ ", _emailEntered );

    NSLog(@"nextAction string value is %@ ", _nextAction);
    
    if ([_nextAction  isEqual: @"passwordRequest"]){
        NSDictionary *ddets = [self deviceDetails];
        
        NSDictionary *dataDict = @{@"email": _emailEntered,
                                   @"password":self.emailTextField.text,
                                   @"UUID": ddets[@"UUID"],
                                   @"deviceModel":ddets[@"deviceModel"],
                                   @"OSVersion":ddets[@"OSVersion"]};
        
        NSDictionary *uploadDict = @{@"type":@"passwordCheck", @"data":dataDict};
        [self sendPassword:uploadDict];
    }
    
    
    else if ([_nextAction  isEqual: @"activationTokenRequest"]) {
        
        NSDictionary *ddets = [self deviceDetails];
        
        NSDictionary *dataDict = @{@"email": _emailEntered,
                                   @"token":self.emailTextField.text,
                                   @"UUID": ddets[@"UUID"],
                                   @"deviceModel":ddets[@"deviceModel"],
                                   @"OSVersion":ddets[@"OSVersion"]};

        NSDictionary *uploadDict = @{@"type":@"activationTokenCheck", @"data":dataDict};
        [self sendPassword:uploadDict];
        
    }
    
    else if ([_nextAction  isEqual: @"registerAsAdmin"]) {
        
        NSDictionary *ddets = [self deviceDetails];
        
        NSDictionary *dataDict = @{@"email": _emailEntered,
                                   @"password":self.emailTextField.text,
                                   @"UUID": ddets[@"UUID"],
                                   @"deviceModel":ddets[@"deviceModel"],
                                   @"OSVersion":ddets[@"OSVersion"]};
        
        NSDictionary *uploadDict = @{@"type":@"registerAsAdmin", @"data":dataDict};
        [self sendPassword:uploadDict];
        
    }
    
    else {
    
    _emailEntered = self.emailTextField.text;
    
    
    NSDictionary *dataDict = @{@"email": _emailEntered,
                               @"device":[self deviceDetails]};
    NSDictionary *uploadDict = @{@"type":@"register", @"data":dataDict};
    
    [self loadJSON:uploadDict];
        
    }
    
   
    
}

-(void)loadJSON:(NSDictionary *)uploadDictionary{
    
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
                    
                    [_emailTextField resignFirstResponder];
                    NSString *errorString = @"sorry, we are having technical trouble at present,  please exit the app and access nearmiss via our webpage at www.nearmiss.co";
                    return [self.view addSubview:[self errorView:errorString]];

                }];
            }
            
            else{
                // nsurl session operates on background thread, to update UI we must pass back to main thread ..
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    NSLog(@" data in response :  %@ ", jsonResponse[@"type"] );
                    [self processRegisterResponse:jsonResponse[@"type"]];
                }];
            }
        }
        else {
            NSLog(@" error from server  :   %@", error);
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                [_emailTextField resignFirstResponder];
                NSString *errorString = @"cannot communicate with server,  please exit the app and access nearmiss via our webpage at www.nearmiss.co";
                return [self.view addSubview:[self errorView:errorString]];
                
            }];
        
        }
    }];
    
    [postDataTask resume];
    
}

-(void)sendPassword:(NSDictionary *)uploadDictionary{
    
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
            
            //NSLog(@" request response from server is :  %@   :  and description of response  %@", response, response.description);
            NSDictionary* jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:kNilOptions
                                                                           error:&error];
            //NSLog(@" data in response :  %@ ", jsonResponse);
            if (!jsonResponse) {
                NSLog(@" did not recieve confirmation from server ");
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    [_emailTextField resignFirstResponder];
                    NSString *errorString = @"we can't connect to the server for some reason,  please check your internet connection or go to www.nearmiss.co";
                    return [self.view addSubview:[self errorView:errorString]];
                    
                }];
            }
            
            else{
                // nsurl session operates on background thread, to update UI we must pass back to main thread ..
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    NSLog(@" data in response :  %@ ", jsonResponse[@"type"] );
                    [self processPasswordResponse:jsonResponse];
                }];
            }
        }
        else {
            NSLog(@" error from server  :   %@", error);        }
    }];
    
    [postDataTask resume];
    
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
