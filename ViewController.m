
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
#import "HelpData.h"
#import "MaintData.h"
#import "textProcessor.h"

@interface ViewController ()  <NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) UIView *registerView;
@property (weak, nonatomic) UITextField *registerTextField;

@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *maintButton;
@property (weak, nonatomic) IBOutlet UIButton *incButton;

@property (strong, nonatomic) NSMutableDictionary *resultFromServer;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController *hsFetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController *clFetchedResultsController;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UIToolbar *mainToolbar = [[[UIElements alloc] createMainToolbar] init];
    [self.view addSubview:mainToolbar];
    for (UIBarButtonItem *item in mainToolbar.items) {
        if (item.tag == 1 ) {
            [item setAction:@selector(loadMaintView)];
        }
        if (item.tag == 2) {
            [item setAction:@selector(loadIncView)];
        }
    }
    
    [self mainButtonSetup];

   // [self loadAll];
    
}

-(void)loadAll{
    
    
    _resultFromServer = [NSMutableDictionary dictionary];
    
    [self.hsFetchedResultsController performFetch:nil];
    [self.clFetchedResultsController performFetch:nil];
    [self.fetchedResultsController performFetch:nil];
    
    [self loadingView];
    NSInteger entries = self.fetchedResultsController.fetchedObjects.count;
    NSLog(@" number of entries in core data %ld", (long)entries);
    
    if (entries == 0) {
        NSLog(@"get all  form server function called ");
        [self getAllFromServer:@"incidentGet"];
        [self getAllFromServer:@"checklistSync"];
        [self getAllFromServer:@"helpsheetSync"];
    
    } else {
        NSLog(@"sync incs with server function called ");
        NSMutableArray *incidentsOnDevice = [NSMutableArray array];
        for (NSInteger i =0; i < entries ; i++) {
            IncData *entry = [[self.fetchedResultsController fetchedObjects] objectAtIndex:i];
            //NSLog(@" incident_id from core data %@ ", entry.incidentId);
            [incidentsOnDevice addObject:entry.incidentId];
        }
        
        NSDictionary *uploadDict = @{@"incidents": incidentsOnDevice };
        NSString *inputCommand = @"incidentSync";
        
        [self syncWithServer:uploadDict inputCommand:inputCommand];
        [self getAllFromServer:@"checklistSync"];
        [self getAllFromServer:@"helpsheetSync"];
    }

}

-(void)viewWillDisappear:(BOOL)animated{
  
    
    if ([self.view viewWithTag:22]) [[self.view viewWithTag:22] removeFromSuperview];
   }


-(NSFetchRequest *)incTitlelistFetchRequest {
    NSFetchRequest *fetchrequest = [NSFetchRequest
                                    fetchRequestWithEntityName:@"IncData" ];
    
    fetchrequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"incDescription" ascending:YES]];
    
    return fetchrequest;
    
}

-(NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    NSFetchRequest *fetchRequest = [self incTitlelistFetchRequest];
    
    _fetchedResultsController =[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
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

-(void)getAllFromServer:(NSString *)inputString{
    NSLog(@" getAllFromServer called in root VC , request type %@", inputString);
    NSDictionary *mobileKey = [tokenStorage getToken];
    NSDictionary *uploadDictionary = @{@"type":inputString,@"data":@{ @"mobileKey":mobileKey[@"token"] } };
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
            
            NSDictionary* jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:kNilOptions
                                                                           error:&error];
            
            if (!jsonResponse) {
                NSLog(@" did not recieve confirmation from server ");
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [_resultFromServer setObject:@{@"type":@"error"} forKey:@"response"];
                    [self checkResponseFromServer];
                }];
            }
            
            else{
                // nsurl session operates on background thread, to update UI we must pass back to main thread ..
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    [_resultFromServer setObject:jsonResponse forKey:@"response"];
                    [self checkResponseFromServer];
                }];
            }
        }
        else {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSLog(@" error from server  :   %@", error);
                [_resultFromServer setObject:@{@"type":@"error"} forKey:@"response"];
                [self checkResponseFromServer];
            }];
            
        }
    }];
    
    [postDataTask resume];
    
}

-(void)syncWithServer:(NSDictionary *)incidents inputCommand:(NSString *)inputString{
    NSLog(@" synWithServer called in root VC , request type %@", inputString);

    NSDictionary *mobileKey = [tokenStorage getToken];
    NSDictionary *uploadDictionary = @{@"type":inputString ,@"data":@{ @"mobileKey":mobileKey[@"token"], @"incident":incidents} };
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
            
            NSDictionary* jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:kNilOptions
                                                                           error:&error];
            
            if (!jsonResponse) {
                NSLog(@" did not recieve confirmation from server ");
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    [_resultFromServer setObject:@{@"type":@"error"} forKey:@"response"];
                    [self checkResponseFromServer];
                }];
            }
            
            else{
                // nsurl session operates on background thread, to update UI we must pass back to main thread ..
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    [_resultFromServer setObject:jsonResponse forKey:@"response"];
                    [self checkResponseFromServer];
                }];
            }
        }
        else {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSLog(@" error from server  :   %@", error);
                [_resultFromServer setObject:@{@"type":@"error"} forKey:@"response"];
                
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
    [self.navigationController.view addSubview:loading];
}

-(void)checkResponseFromServer{
    
    for (UIView *i in self.navigationController.view.subviews){
        if (i.tag == 10 ) {
            [i removeFromSuperview];
        }
    }
    
    //NSLog(@" check response from server triggered %@", _resultFromServer[@"response"] );
    NSString *responseType =  _resultFromServer[@"response"][@"type"];
    
    if ([responseType isEqualToString:@"error"]) {
    
        NSLog(@" error when trying to connect to server ");
        return;
    }
    else if ([responseType isEqualToString:@"noUpdate"]) {
        // no data to update
        NSLog(@" server reported that there are no data updates ");
        return;
    }
    else if ([responseType isEqualToString:@"incidentListUpdate"]){
        return [self incUpdate];
    }
    else if ([responseType isEqualToString:@"hsListUpdate"]){
        NSLog(@" hsListUpdate triggered ");
        return [self hsUpdate];
    }
    else if ([responseType isEqualToString:@"clListUpdate"]){
        NSLog(@" clListUpdate triggered ");
        return [self clUpdate];
    }
    
    else {
        NSLog(@" type supplied is not recognised  ");
        return;
    }
    
}
    
    

-(void)incUpdate{
   if (!_resultFromServer[@"response"][@"data"][@"incident"]) {
        NSLog(@" no incidents listed ");
        return;
    }
    NSArray *incList = _resultFromServer[@"response"][@"data"][@"incident"];
    NSUInteger itemCount = [incList count];
    NSLog(@" number of inc data items in result from server :  %lu ", (unsigned long)itemCount  );
    
    for (NSUInteger i = 0; i < itemCount; i++){
        CoreDataStack *incCoreData = [CoreDataStack defaultStack];
        IncData *newentry = [NSEntityDescription insertNewObjectForEntityForName:@"IncData" inManagedObjectContext:incCoreData.managedObjectContext];
        
        newentry.incidentId = incList[i][@"incident_id"];
        newentry.status = incList[i][@"status"];
        newentry.incDescription = incList[i][@"description"];
        if (incList[i][@"resolution"] == [NSNull null]) {
            newentry.incResolution = nil;
            
        } else {
            newentry.incResolution = incList[i][@"resolution"];
        }
        [incCoreData saveContext];
        
    }
    return;
}

-(void)hsUpdate{
    //NSLog(@" helpsheet data  %@ ", _resultFromServer[@"response"][@"data"][@"helpsheet"]);
    if (!_resultFromServer[@"response"][@"data"][@"helpsheet"]) {
        NSLog(@" no incidents listed ");
        return;
    }
    
    
    NSUInteger itemCount = [_resultFromServer[@"response"][@"data"][@"helpsheet"] count];
    NSArray *hsList = _resultFromServer[@"response"][@"data"][@"helpsheet"];
    NSMutableDictionary *hsHash = [NSMutableDictionary dictionary];

    for (NSUInteger j = 0; j < itemCount; j++) {
        NSLog(@" checklist value %@ , checklist key %@ ", _resultFromServer[@"response"][@"data"][@"helpsheet"][j], _resultFromServer[@"response"][@"data"][@"helpsheet"][j][@"helpsheet_id"]);
        [hsHash setObject:_resultFromServer[@"response"][@"data"][@"helpsheet"][j] forKey:_resultFromServer[@"response"][@"data"][@"helpsheet"][j][@"helpsheet_id"]];
    }
    
    NSLog(@" number of hs data items in result from server :  %lu ", (unsigned long)itemCount  );
    
    if (_hsFetchedResultsController.fetchedObjects.count == 0){
        
        for (NSUInteger i = 0; i < itemCount; i++){
           CoreDataStack *hsCoreData = [CoreDataStack defaultStack];
           HelpData *newentry = [NSEntityDescription insertNewObjectForEntityForName:@"HelpData" inManagedObjectContext:hsCoreData.managedObjectContext];
           newentry.helpsheetID = hsList[i][@"helpsheet_id"];
           newentry.title = hsList[i][@"title"];
           [hsCoreData saveContext];
         }
    } else {
        
        
        for (NSUInteger i = 0; i < itemCount; i++){
            
            if (![_hsFetchedResultsController.fetchedObjects objectAtIndex:i]) {
                return NSLog(@"no row in fetch result controller to check ");
            }
            NSLog(@" checklist in server %@ , checklist from core data %@ ", hsList[i][@"helpsheet_id"], [_hsFetchedResultsController.fetchedObjects objectAtIndex:i]);
            HelpData *existingEntry = [_hsFetchedResultsController.fetchedObjects objectAtIndex:i];
            
            NSLog(@" cross referencing dictionary retrieved form server with core data  %@  ", hsHash[existingEntry.helpsheetID] );
            NSLog(@"checking null reference in dict %@", hsHash[existingEntry.location]);
            
            if (!hsHash[existingEntry.helpsheetID]) {
                CoreDataStack *hsCoreData = [CoreDataStack defaultStack];
                HelpData *newentry = [NSEntityDescription insertNewObjectForEntityForName:@"HelpData" inManagedObjectContext:hsCoreData.managedObjectContext];
                
                newentry.helpsheetID = hsList[i][@"helpsheet_id"];
                newentry.title = hsList[i][@"title"];
                [hsCoreData saveContext];
            }
            else {
               NSLog(@"hs entry id already found , updating title ");
                
                CoreDataStack *hsCoreData = [CoreDataStack defaultStack];
                existingEntry.title = hsList[i][@"title"];
                [hsCoreData saveContext];
                
            }
        }
        
    }
}

-(NSFetchRequest *)hsFetchRequest {
    NSFetchRequest *hsFetchrequest = [NSFetchRequest
                                    fetchRequestWithEntityName:@"HelpData" ];
    
    hsFetchrequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO]];
    
    return hsFetchrequest;
    
}

-(NSFetchedResultsController *)hsFetchedResultsController {
    if (_hsFetchedResultsController != nil) {
        return _hsFetchedResultsController;
    }
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    NSFetchRequest *hsFetchRequest = [self hsFetchRequest];
    
    _hsFetchedResultsController =[[NSFetchedResultsController alloc] initWithFetchRequest:hsFetchRequest managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    _hsFetchedResultsController.delegate = self;
    
    return _hsFetchedResultsController;
}


-(void)clUpdate{
    NSLog(@" checklist data  %@ ", _resultFromServer[@"response"][@"data"][@"checklist"]);
    if (!_resultFromServer[@"response"][@"data"][@"checklist"]) {
        NSLog(@" no incidents listed ");
        return;
    }
    NSArray *clList = _resultFromServer[@"response"][@"data"][@"checklist"];
    NSUInteger itemCount = [clList count];
    NSUInteger cdCount = _clFetchedResultsController.fetchedObjects.count;
    NSMutableDictionary *clHash = [NSMutableDictionary dictionary];
    
    for (NSUInteger j = 0; j < itemCount; j++) {
        NSLog(@" checklist value %@ , checklist key %@ ", clList[j], clList[j][@"checklist_id"]);
        [clHash setObject:clList[j] forKey:clList[j][@"checklist_id"]];
    }
    NSLog(@" number of data items in result from server :  %lu , number in core data  %lu ", (unsigned long)itemCount, _clFetchedResultsController.fetchedObjects.count  );
    
    if (cdCount == 0){
        
        for (NSUInteger i = 0; i < itemCount; i++){
            CoreDataStack *hsCoreData = [CoreDataStack defaultStack];
            MaintData *newentry = [NSEntityDescription insertNewObjectForEntityForName:@"MaintData" inManagedObjectContext:hsCoreData.managedObjectContext];
            newentry.checklistID = clList[i][@"checklist_id"];
            newentry.title = clList[i][@"title"];
            [hsCoreData saveContext];
        }
    }

    
    else {
        for (NSUInteger j =0; j < cdCount; j++) {
            MaintData *existingEntry = [_clFetchedResultsController.fetchedObjects objectAtIndex:j];
            if (clHash[existingEntry.checklistID]) {
                // if object is already in coredata, removine from dreceived form server ictionary and update contents
                [clHash removeObjectForKey:existingEntry.checklistID];
                CoreDataStack *clCoreData = [CoreDataStack defaultStack];
                existingEntry.title = clList[j][@"title"];
                [clCoreData saveContext];
                }
        }
        
        for (id key in clHash ){
            id clValue =  [clHash objectForKey:key];
            NSLog(@" cross referencing dictionary retrieved form server with core data  %@  ", clValue );
            CoreDataStack *clCoreData = [CoreDataStack defaultStack];
            MaintData *newentry = [NSEntityDescription insertNewObjectForEntityForName:@"MaintData" inManagedObjectContext:clCoreData.managedObjectContext];
            newentry.checklistID = clValue[@"checklist_id"];
            newentry.title = clValue[@"title"];
            [clCoreData saveContext];
           }
        
    }


}

-(NSFetchRequest *)clFetchRequest {
    NSFetchRequest *clFetchrequest = [NSFetchRequest
                                      fetchRequestWithEntityName:@"MaintData" ];
    
    clFetchrequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO]];
    
    return clFetchrequest;
    
}

-(NSFetchedResultsController *)clFetchedResultsController {
    if (_clFetchedResultsController != nil) {
        return _clFetchedResultsController;
    }
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    NSFetchRequest *clFetchRequest = [self clFetchRequest];
    
    _clFetchedResultsController =[[NSFetchedResultsController alloc] initWithFetchRequest:clFetchRequest managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    _clFetchedResultsController.delegate = self;
    
    return _clFetchedResultsController;
}



@end
