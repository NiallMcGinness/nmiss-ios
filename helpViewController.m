//
//  helpViewController.m
//  nmiss-ios
//
//  Created by NIall McGinness on 2015-05-04.
//  Copyright (c) 2015 Niall McGinness. All rights reserved.
//

#import "helpViewController.h"
#import "UIElements.h"
#import "IconMaker.h"
#import "textProcessor.h"
#import "CoreDataStack.h"
#import "HelpData.h"
#import "HelpEntryViewController.h"
#import "HelpCell.h"

@interface helpViewController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *helpTable;

@end

@implementation helpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateTableView];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor blackColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor whiteColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    //[self.view addSubview:[self helpToolbar]];
    [self.fetchedResultsController performFetch:nil];

}

-(void)viewWillAppear:(BOOL)animated{
    [self.helpTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

-(void)updateTableView {
    
    self.helpTable.dataSource = self;
    self.helpTable.delegate = self;
}

-(void)loadAddHelpView{
    
    NSString *storyboardName =  @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    HelpEntryViewController * helpvc = [storyboard instantiateViewControllerWithIdentifier:@"helpEdit"];
    [self presentViewController:helpvc animated:NO completion:nil];

}

-(UIToolbar *)helpToolbar{
    UIToolbar *helpToolbar = [[UIElements alloc] createTopToolBar];
    helpToolbar.clipsToBounds = true;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(dismissSelf)];   
    
    UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithTitle:@"help sheets" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIBarButtonItem *flexibleButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:@selector(loadAddHelpView)];
    
    [helpToolbar setItems:@[backButton,flexibleButton,titleButton,flexibleButton,addButton] animated:false];
    return helpToolbar;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"helpSegue"]) {
        NSLog(@" segue to load existing help sheet triggered ");
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.helpTable indexPathForCell:cell];
        UINavigationController *navigationController = segue.destinationViewController;
        HelpEntryViewController *helpEntryViewController = (HelpEntryViewController *)
        navigationController.topViewController;
        helpEntryViewController.entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
    } else if ([segue.identifier isEqualToString:@"addNewHelpSheet"]){
        NSLog(@" segue to load new help sheet triggered ");        NSMutableString *sheetID = [textProcessor generateID];
        CoreDataStack *CoreData = [CoreDataStack defaultStack];
        HelpData *newSheet = [NSEntityDescription insertNewObjectForEntityForName:@"HelpData" inManagedObjectContext:CoreData.managedObjectContext];
        newSheet.title = @"Untitled";
        newSheet.helpsheetID = sheetID;
        [CoreData saveContext];
        
        UINavigationController *navigationController = segue.destinationViewController;
        HelpEntryViewController *helpEntryViewController = (HelpEntryViewController *)
        navigationController.topViewController;
        helpEntryViewController.entry = newSheet;

    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.fetchedResultsController.sections.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
    
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID =  @"helpCell";
    
    HelpCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil ) {
        
        cell = [[HelpCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    HelpData *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = entry.title;
    
    return cell;
}

#pragma -- delete data

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}



-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.helpTable beginUpdates];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.helpTable endUpdates];
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HelpData *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [[coreDataStack managedObjectContext] deleteObject:entry];
    [coreDataStack saveContext];
}


-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.helpTable insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.helpTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.helpTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}


-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.helpTable insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.helpTable deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
        default:
            break;
    }
}

#pragma fetchrequest

-(NSFetchRequest *)helpTitlelistFetchRequest {
    NSFetchRequest *fetchrequest = [NSFetchRequest
                                    fetchRequestWithEntityName:@"HelpData" ];
    
    fetchrequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO]];
    
    return fetchrequest;
    
}

-(NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    NSFetchRequest *fetchRequest = [self helpTitlelistFetchRequest];
    
    _fetchedResultsController =[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

@end
