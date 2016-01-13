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

@interface MaintEntryViewController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (strong, nonatomic) IBOutlet UITableView *clTableDetail;

@end

@implementation MaintEntryViewController


- (void)viewDidLoad {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if (_entry.title) {
        _titleField.text = _entry.title;
    }
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

- (IBAction)saveWasPressed:(id)sender {
    if (self.entry != nil) {
        [self updateMaintEntry];
    } else {
        [self insertMaint];
    }
    [self dismissSelf];
}
- (IBAction)cancelwasPressed:(id)sender {
    [self dismissSelf];
}

/*
-(void)saveWasPressed{
    if (self.entry != nil) {
        [self updateMaintEntry];
    } else {
        [self insertMaint];
    }
    [self dismissSelf];
}
 
 */
- (IBAction)closeWasPressed:(id)sender {
    [self dismissSelf];
}

-(void)updateMaintEntry{
    self.entry.title = _titleField.text;
    CoreDataStack *maintCoreData = [CoreDataStack defaultStack];
    [maintCoreData saveContext];
}

-(void)insertMaint{
    if ( _titleField.text != nil) {
        
        CoreDataStack *maintCoreData = [CoreDataStack defaultStack];
        MaintData *newentry = [NSEntityDescription insertNewObjectForEntityForName:@"MaintData" inManagedObjectContext:maintCoreData.managedObjectContext];
        newentry.title = _titleField.text;
        [maintCoreData saveContext];
    }
    
}

- (void)dismissSelf {
    
    
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID =  @"maintDetailCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil ) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSLog(@"index path %ld", (long)indexPath.row);
    cell.textLabel.text = _entry.checklistID;
    
    return cell;
}


@end
