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
#import "HelpDetail.h"
#import "textProcessor.h"
#import "HelpStepEntry.h"
#import "HelpStepCell.h"

@interface HelpEntryViewController () <UITableViewDelegate, UITableViewDataSource,UITextViewDelegate,NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedStepResultsController;
@property (weak, nonatomic) IBOutlet UITableView *hsDetailTable;
@property (weak, nonatomic) IBOutlet UITextField *hsTitleField;


@end

@implementation HelpEntryViewController


- (void)viewDidLoad {
    //[super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    // Do any additional setup after loading the view.
    _hsDetailTable.delegate = self;
    _hsDetailTable.dataSource = self;
    NSLog(@"step list loaded ");
    if (_entry == nil){
        NSLog(@"entry is nil");
    }
    
    if (self.entry.title !=nil) {
        _hsTitleField.text = self.entry.title;
    }
    
    NSLog(@"helpsheet id %@", _entry.helpsheetID);
    [self.fetchedStepResultsController performFetch:nil];

    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.hsDetailTable reloadData];
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
- (IBAction)backWasPressed:(UIBarButtonItem *)sender {
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

/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"number of rows in table %u", self.fetchedResultsController.sections.count);
    //return self.fetchedResultsController.sections.count;
    if (!self.fetchedStepResultsController.sections.count) {
        NSLog(@"null result for fetchedStepresults controller");
        return 5;
    } else {
        NSLog(@"fetched results number of sections %u",self.fetchedStepResultsController.sections.count  );
        return  self.fetchedStepResultsController.sections.count ;
    }
    
}
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedStepResultsController sections][section];
    return [sectionInfo numberOfObjects];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSString *text = _entry.helpsheetID;
    //id textinstance = [[textProcessor alloc] init];
    //CGFloat height =  [textProcessor textBoxHeight:text];
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID =  @"hsDetailCell";
    
    HelpStepCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil ) {
        
        cell = [[HelpStepCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    HelpDetail *entryStep = [self.fetchedStepResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = entryStep.body;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addHelpStepSegue"]) {
        NSLog(@" segue triggered ");
        //UITableViewCell *cell = sender;
        //NSIndexPath *indexPath = [self.hsDetailTable indexPathForCell:cell];
        UINavigationController *navigationController = segue.destinationViewController;
        HelpStepEntry *helpStepEntryViewController = (HelpStepEntry *)
        navigationController.topViewController;
        if (self.entry.helpsheetID !=nil) {
            NSLog(@"help sheet id when detail view segue is triggerred %@", _entry.helpsheetID);

            helpStepEntryViewController.titleEntry = self.entry;
        }
    }
    
}

#pragma fetchrequest

-(NSFetchRequest *)helpStepFetchRequest {
    NSFetchRequest *fetchrequest = [NSFetchRequest
                                    fetchRequestWithEntityName:@"HelpDetail" ];
    
   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"helpsheetID == %@", _entry.helpsheetID];
    fetchrequest.predicate = predicate;
    
    NSLog(@" search term : %@",fetchrequest.predicate);
    fetchrequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"helpsheetID" ascending:NO]];
    
    return fetchrequest;
    
}

-(NSFetchedResultsController *)fetchedStepResultsController {
    if (_fetchedStepResultsController != nil) {
        return _fetchedStepResultsController;
    }
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    NSFetchRequest *fetchRequest = [self helpStepFetchRequest];
    
    _fetchedStepResultsController =[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedStepResultsController.delegate = self;
    
    return _fetchedStepResultsController;
}

@end
