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

@interface IncEntryViewController () <NSFetchedResultsControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) UITextView *incTextView;

@property (strong, nonatomic) NSMutableDictionary *incEntryDict;


@end

@implementation IncEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self checkSubviews];
    [self incEntryDict];
    [self.view addSubview:[self incTextView]];
    [self.view addSubview:[self editToolbar]];
    
    
}

-(NSMutableDictionary *)incEntryDict {
    NSMutableDictionary *incEntryDict = [[NSMutableDictionary alloc] init];
    _incEntryDict = incEntryDict;
    return _incEntryDict;
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
    
    //[cancelButton set

    [editToolbar setItems:@[saveButton, flexibleButton, cancelButton] animated:false];
    [self.incTextView setInputAccessoryView:editToolbar];
    
    return editToolbar;
    
}

-(UITextView *)incTextView {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    UITextView *incTextView = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 50.0, screenBounds.size.width , screenBounds.size.height *0.75)];
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
    [textView becomeFirstResponder];
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
