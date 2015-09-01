
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
#import "syncInc.h"
#import "CoreDataStack.h"
#import "IncData.h"

@interface ViewController ()


@property (weak, nonatomic) UIView *registerView;
@property (weak, nonatomic) UITextField *registerTextField;

@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *maintButton;
@property (weak, nonatomic) IBOutlet UIButton *incButton;

@property (strong, nonatomic) NSMutableDictionary *resultFromServer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _resultFromServer = [NSMutableDictionary dictionary];
    
    [self mainButtonSetup];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UIToolbar *mainToolbar = [[[UIElements alloc] createMainToolbar] init];
    [self.view addSubview:mainToolbar];
       NSDictionary *tokenDict = [tokenStorage getToken];
    
    NSLog(@" token is :  %@ , response from server is %@", tokenDict[@"token"], _resultFromServer[@"response"]);
    
    for (UIBarButtonItem *item in mainToolbar.items) {
        if (item.tag == 1 ) {
            [item setAction:@selector(loadMaintView)];
        }
        if (item.tag == 2) {
            [item setAction:@selector(loadIncView)];
        }
     }
    [self loadingView];
    [self getIncsFromServer];
    
}



-(void)viewDidAppear:(BOOL)animated{
    NSLog(@" main screen view did appear");
        [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    
    if ([self.view viewWithTag:22]) [[self.view viewWithTag:22] removeFromSuperview];
}

-(void)notify{
    
    NSLog(@" dictionary has updated, response from server is %@",  _resultFromServer[@"response"]);
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

-(void)getIncsFromServer{
    NSDictionary *mobileKey = [tokenStorage getToken];
    NSDictionary *uploadDictionary = @{@"type":@"incidentGet",@"data":@{ @"mobileKey":mobileKey[@"token"]} };
    NSError *setDataError;
    NSURL *uploadURL = [NSURL URLWithString:@"https://nearmiss.co/api"];
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
                    
                    [_resultFromServer setObject:@"error" forKey:@"response"];
                    [self removeLoadingView];
                }];
            }
            
            else{
                // nsurl session operates on background thread, to update UI we must pass back to main thread ..
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    [_resultFromServer setObject:jsonResponse forKey:@"response"];
                    [self removeLoadingView];
                }];
            }
        }
        else {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSLog(@" error from server  :   %@", error);
                [_resultFromServer setObject:@"error" forKey:@"response"];
                [self removeLoadingView];
            }];
            
        }
    }];
    
    [postDataTask resume];
    
}

-(void)loadingView{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    UIView *loading = [[UIView alloc] initWithFrame:CGRectMake(0.0, 60.0, screenBounds.size.width, screenBounds.size.height)];
    [loading setBackgroundColor:[UIColor blackColor]];
    [loading setTag:10];
    [self.view addSubview:loading];
}

-(void)removeLoadingView{
    for (UIView *i in self.view.subviews){
        if (i.tag == 10 ) {
            [i removeFromSuperview];
        }
    }
    
    [self checkResponseFromServer];
}

-(void)checkResponseFromServer{
    // NSLog(@" data in _result from server :  %@ ", _resultFromServer[@"response"]  );
    //if (!_resultFromServer[@"response"][@"data"][@"indident"]) return;
    
    NSLog(@" check response from server triggered : ");
    NSArray *incList =  _resultFromServer[@"response"][@"data"][@"incident"];
    NSLog(@" data in result from server :  %@ ", incList  );
    NSUInteger itemCount = [incList count];
    NSLog(@" number of data items in result from server :  %d ", itemCount  );
    CoreDataStack *incCoreData = [CoreDataStack defaultStack];
    for (NSUInteger i = 0; i < itemCount; i++){
        NSLog(@" item in list %@ ", incList[i][@"incident_id"]);
        
        IncData *newentry = [NSEntityDescription insertNewObjectForEntityForName:@"IncData" inManagedObjectContext:incCoreData.managedObjectContext];
        
        newentry.title = incList[i][@"description"];
        //newentry.body = incList[i][@"resolution"];
        NSLog(@" saving to coredata  %@ ", newentry.title );
        [incCoreData saveContext];
        
    }
}

@end
