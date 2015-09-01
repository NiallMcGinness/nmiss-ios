//
//  MaintEntryViewController.m
//  nmiss-ios
//
//  Created by NIall McGinness on 2015-04-30.
//  Copyright (c) 2015 Niall McGinness. All rights reserved.
//

#import "MaintEntryViewController.h"
#import "UIElements.h"
#import "CoreDataStack.h"
#import "MaintData.h"

@interface MaintEntryViewController () <UITextViewDelegate>

@property (weak, nonatomic) UITextView *textView;
@property (strong, nonatomic) NSMutableDictionary *maintEntryDict;
@end

@implementation MaintEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self checkSubviews];
    [self maintEntryDict];
    [self.view addSubview:[self textView]];
    [self.view addSubview:[self editToolbar]];
        
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)checkSubviews{
    
    for (UIToolbar *item in [self.view subviews]){
        if (item.tag == 123) {
            
            [item removeFromSuperview];
        }
    }
    
}

-(NSMutableDictionary *)maintEntryDict{
    NSMutableDictionary *maintEntryDict = [[NSMutableDictionary alloc] init];
    
    _maintEntryDict = maintEntryDict;
    
    return _maintEntryDict;
}

-(void)saveWasPressed{
    if (self.entry != nil) {
        [self updateMaintEntry];
    } else {
        [self insertMaint];
    }
    [self dismissSelf];
}

-(void)updateMaintEntry{
    self.entry.body = _maintEntryDict[@"body"];
    CoreDataStack *maintCoreData = [CoreDataStack defaultStack];
    [maintCoreData saveContext];
}

-(void)insertMaint{
    if (_maintEntryDict[@"body"] != nil) {
        
        CoreDataStack *maintCoreData = [CoreDataStack defaultStack];
        MaintData *newentry = [NSEntityDescription insertNewObjectForEntityForName:@"MaintData" inManagedObjectContext:maintCoreData.managedObjectContext];
        newentry.body = _maintEntryDict[@"body"];
        [maintCoreData saveContext];
    }
    
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

-(UITextView *)textView{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10.0, 50.0, screenBounds.size.width - 10 , 50.0)];
    textView.delegate = self;
    if (self.entry) {
        textView.text = self.entry.body;
    }
    return textView;

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    [_maintEntryDict setObject:currenttext forKey:@"body"];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    
    
    NSLog(@" textview did end editing ");
    [textView resignFirstResponder];
}


@end
