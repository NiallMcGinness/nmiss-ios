
//
//  ViewController.m
//  nmiss-ios
//
//  Created by NIall McGinness on 2015-04-15.
//  Copyright (c) 2015 Niall McGinness. All rights reserved.
//

#import "ViewController.h"
#import "incViewContoller.h"
#import "maintViewController.h"
#import "UIElements.h"
#import "JSONUpload.h"
#import "tokenStorage.h"

@interface ViewController ()


@property (weak, nonatomic) UIView *registerView;
@property (weak, nonatomic) UITextField *registerTextField;

@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *maintButton;
@property (weak, nonatomic) IBOutlet UIButton *incButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self mainButtonSetup];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UIToolbar *mainToolbar = [[[UIElements alloc] createMainToolbar] init];
    [self.view addSubview:mainToolbar];
    
    //[tokenStorage deleteToken];
    NSDictionary *tokenDict = [tokenStorage getToken];
    
    NSLog(@" token is :  %@ ", tokenDict[@"token"]);
    
    for (UIBarButtonItem *item in mainToolbar.items) {
        if (item.tag == 1 ) {
            [item setAction:@selector(loadMaintView)];
        }
        if (item.tag == 2) {
            [item setAction:@selector(loadIncView)];
        }
     }
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@" main screen view did appear");
     [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    
    if ([self.view viewWithTag:22]) [[self.view viewWithTag:22] removeFromSuperview];
}

-(void)mainButtonSetup{
    
    
    [self.maintButton setTitle:@"Checklists & Helpsheets" forState:UIControlStateNormal];
     self.maintButton.tintColor = [UIColor blackColor];
    //
    [self.incButton setTitle:@"Incident Board" forState:UIControlStateNormal];
     self.incButton.tintColor = [UIColor blackColor];
    //
    
    [self.settingsButton setTitle:@"Press Here to Register" forState:UIControlStateNormal];
     self.settingsButton.tintColor = [UIColor blackColor];
    //
}

- (IBAction)settingsWasPressed:(id)sender {
}

- (IBAction)maintWasPressed:(id)sender {
}

- (IBAction)incWasPressed:(id)sender {
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


-(UITextField *)registerTextField{
    
    
    
    UITextField *registerTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 50, 250.0, 35.0 )];
    [registerTextField setBackgroundColor:[UIColor whiteColor]];
    
    _registerTextField = registerTextField;
    
    
    return _registerTextField;
}

-(void)registerWasPressed{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"userprofile.plist"];
    NSDictionary *dictionary3 = [NSDictionary dictionaryWithContentsOfFile:path];
    NSLog(@"contents of plist after write %@ " , dictionary3 );
    
    
  }

-(void)triggerRegisterView{
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    UIView *registerView = [[UIView alloc] initWithFrame:CGRectMake(screenBounds.size.width * 0.075, screenBounds.size.height * 0.1, screenBounds.size.width * 0.85, screenBounds.size.height * 0.65)];
    UIColor *nmissOrange = [UIColor colorWithRed:255.0/255.0 green:100.0/255.0 blue:0.0/255.0 alpha:1.0];
    [registerView setBackgroundColor:nmissOrange];
    [registerView setTag:22];
    
    UILabel *emailTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, screenBounds.size.width * 0.85, screenBounds.size.height * 0.1)];
    [emailTitle setText:@"enter your work email "];
    [emailTitle setTintColor:[UIColor whiteColor]];
    
    UIButton *regButton = [self mainButton:CGRectMake(15, screenBounds.size.height * 0.3, screenBounds.size.width * 0.85, 70.0)];
    [regButton setTitle:@" Save " forState:UIControlStateNormal];
    [regButton addTarget:nil action:@selector(saveWasPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [registerView addSubview:emailTitle];
    [registerView addSubview:[self registerTextField]];
    [registerView addSubview:regButton];
    
    [self.view addSubview:registerView];
   
    
    [self registerWasPressed];

}

-(void)saveWasPressed{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"userprofile.plist"];
    
    NSString *currentText = _registerTextField.text;
    
    NSDictionary *plistDict = [NSDictionary dictionaryWithObject:currentText
                                                          forKey:@"email"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        NSError *errorStr;
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"userprofile" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath:path error:&errorStr];
    }
    
    
    NSLog(@" documents directory file path %@", path);
    
    NSDictionary *dataDict = @{@"email": currentText,
                               @"device":[self deviceDetails]};
    NSDictionary *uploadDict = @{@"type":@"registerNewDevice", @"data":dataDict};
    
    [JSONUpload loadJSON:uploadDict];
       
    NSError *error;
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
    
    if(plistData) {
       
        [plistData writeToFile:path atomically:YES];
    }
    else {
        NSLog(@"error when serialising data for plist write for user settings : %@" , error);
        
    }
   
    if ([self.view viewWithTag:22]) [[self.view viewWithTag:22] removeFromSuperview];
        
}

-(void)uploadEmail:(NSDictionary *)uploadDictionary{
    
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
            
        }
        else {
            NSLog(@" error from server  :   %@", error);        }
    }];
    
    [postDataTask resume];

}



-(UIButton *)mainButton:(CGRect)sizeOfButton{
    UIButton *mainButton = [[UIButton alloc] initWithFrame:sizeOfButton];
    return mainButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadIncView{
   
    NSString *storyboardName =  @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * inc = [storyboard instantiateViewControllerWithIdentifier:@"inc"];
    [self presentViewController:inc animated:NO completion:nil];
}

-(void)loadMaintView{
      NSString *storyboardName =  @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * maint = [storyboard instantiateViewControllerWithIdentifier:@"tabView"];
    [self presentViewController:maint animated:NO completion:nil];
}


@end
