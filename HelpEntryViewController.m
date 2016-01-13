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
#import "textProcessor.h"

@interface HelpEntryViewController () <UITableViewDelegate, UITableViewDataSource,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *hsDetailTable;
@property (weak, nonatomic) IBOutlet UITextField *hsTitleField;


@end

@implementation HelpEntryViewController

- (void)viewDidLoad {
    //[super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    // Do any additional setup after loading the view.
    if (self.entry.title !=nil) {
        _hsTitleField.text = self.entry.title;
    }
   
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissSelf {
    
    
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)saveWasPressed:(id)sender {
    
    if (self.entry.helpsheetID != nil) {
        [self updateHelpEntry];
    } else {
        [self insertHelp];
    }

}
- (IBAction)cancelWasPressed:(id)sender {
     [self dismissSelf];
}

-(void)insertHelp{
    if(_hsTitleField.text !=nil){
        CoreDataStack *helpCoreData = [CoreDataStack defaultStack];
        HelpData *newentry = [NSEntityDescription insertNewObjectForEntityForName:@"HelpData" inManagedObjectContext:helpCoreData.managedObjectContext];
        newentry.title = _hsTitleField.text;
        [helpCoreData saveContext];
    }
    [self dismissSelf];
}

-(void)updateHelpEntry{
    self.entry.title = _hsTitleField.text;
    
    CoreDataStack *helpCoreData=[CoreDataStack defaultStack];
    [helpCoreData saveContext];
    
    [self dismissSelf];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = _entry.helpsheetID;
    //id textinstance = [[textProcessor alloc] init];
    CGFloat height =  [textProcessor textBoxHeight:text];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID =  @"hsDetailCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil ) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = _entry.helpsheetID;
    
    return cell;
}


@end
