//
//  HelpEntryViewController.m
//  nmiss-ios
//
//  Created by NIall McGinness on 2015-05-05.
//  Copyright (c) 2015 Niall McGinness. All rights reserved.
//

#import "HelpEntryViewController.h"
#import "UIElements.h"
#import "CoreDataStack.h"
#import "HelpData.h"

@interface HelpEntryViewController () <UITextViewDelegate>

@property (strong, nonatomic) NSMutableDictionary *helpEntryDict;
@property (strong, nonatomic) UITextView *helpTextView;

@end

@implementation HelpEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.entry !=nil) {
        NSLog(@"started textView %@ ", self.entry.body);
        //self.helpTextView.text = self.entry.body;
        [self.helpTextView setText:self.entry.body];
    }
    [self helpEntryDict];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.view addSubview:[self helpTextView]];
    [self.view addSubview:[self editToolbar]];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissSelf {
    
    
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

-(UIToolbar *)editToolbar{
    UIToolbar *editToolbar = [[UIElements alloc] createTopToolBar];
    editToolbar.clipsToBounds = true;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self    action:@selector(saveWasPressed)];
    
    UIBarButtonItem *flexibleButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismissSelf)];
    
    //[cancelButton set
    
    [editToolbar setItems:@[saveButton, flexibleButton, cancelButton] animated:false];
    //[self.textView setInputAccessoryView:editToolbar];
    
    return editToolbar;
    
}

-(UITextView *)helpTextView{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    UITextView *helpTextView = [[UITextView alloc] initWithFrame:CGRectMake(10.0, 50.0, screenBounds.size.width - 10 , 50.0)];
    helpTextView.delegate = self;
    if (self.entry) {
       
        helpTextView.text = self.entry.body;
    }
    _helpTextView = helpTextView;
    return helpTextView;
}

-(NSMutableDictionary *)helpEntryDict{
    NSMutableDictionary *helpEntryDict = [[NSMutableDictionary alloc] init];
    _helpEntryDict = helpEntryDict;
    return _helpEntryDict;

}

-(void)saveWasPressed{
    if (self.entry != nil) {
        [self updateHelpEntry];
    } else {
        [self insertHelp];
    }
    [self dismissSelf];
}

-(void)insertHelp{
        if(_helpEntryDict[@"body"] !=nil){
                CoreDataStack *helpCoreData = [CoreDataStack defaultStack];
        HelpData *newentry = [NSEntityDescription insertNewObjectForEntityForName:@"HelpData" inManagedObjectContext:helpCoreData.managedObjectContext];
        newentry.body = _helpEntryDict[@"body"];
        [helpCoreData saveContext];
        } else {
         
        NSLog(@" insert help sheet activated but help entry dict is nil  %@ ", _helpEntryDict[@"body"]);
        }
    
   
}

-(void)updateHelpEntry{
    self.entry.body = _helpEntryDict[@"body"];
    
    CoreDataStack *helpCoreData=[CoreDataStack defaultStack];
    [helpCoreData saveContext];
}

- (void)textViewDidChange:(UITextView *)textView{
    
    NSString *currenttext = textView.text;
    NSLog(@" textview did change %@", textView.text);
    [_helpEntryDict setObject:currenttext forKey:@"body"];
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
