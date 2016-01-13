//
//  maintViewController.m
//  nmiss-ios
//
//  Created by NIall McGinness on 2015-04-17.
//  Copyright (c) 2015 Niall McGinness. All rights reserved.
//

#import "maintViewController.h"
#import "UIElements.h"
#import "IconMaker.h"
#import "CoreDataStack.h"
#import "MaintData.h"
#import "MaintEntryViewController.h"
#import "maintCell.h"

@interface maintViewController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *MaintTable;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation maintViewController

- (void)viewDidLoad {
    //[super viewDidLoad];
    [self updateTableView];
    //[self.navigationController setNavigationBarHidden:YES animated:NO];
    // Do any additional setup after loading the view.
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor blackColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor whiteColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    [self.view addSubview:[self maintToolbar]];
    [self.fetchedResultsController performFetch:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

-(void)updateTableView {
    
    self.MaintTable.dataSource = self;
    self.MaintTable.delegate = self;
}

-(UIToolbar *)maintToolbar{
    UIToolbar *maintToolbar = [[UIElements alloc] createTopToolBar];
    maintToolbar.clipsToBounds = true;
    
    //UIImage *backButtonImage = [[IconMaker alloc] createBackChevronImage];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:nil];
    //backButton.imageInsets = UIEdgeInsetsMake(6.0, 0 , -6.0, 0);
    
    UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithTitle:@"checklists" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIBarButtonItem *flexibleButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:@selector(loadAddMaintView)];
    
    [maintToolbar setItems:@[backButton,flexibleButton,titleButton,flexibleButton,addButton] animated:false];
    return maintToolbar;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"maintSegue"]) {
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.MaintTable indexPathForCell:cell];
        UINavigationController *navigationController = segue.destinationViewController;
        MaintEntryViewController *maintTitleViewController = (MaintEntryViewController *) navigationController.topViewController;
        maintTitleViewController.entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
}


-(void)loadAddMaintView{
    NSString *storyboardName =  @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * maintvc = [storyboard instantiateViewControllerWithIdentifier:@"maintEdit"];
    [self presentViewController:maintvc animated:NO completion:nil];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.fetchedResultsController.sections.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController                                                     sections][section];
    return [sectionInfo numberOfObjects];

    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID =  @"maintCell";
    
    maintCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil ) {
    
    cell = [[maintCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    MaintData *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = entry.title;
    
    return cell;
}
#pragma -- delete data

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}



-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.MaintTable beginUpdates];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.MaintTable endUpdates];
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MaintData *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [[coreDataStack managedObjectContext] deleteObject:entry];
    [coreDataStack saveContext];
}


-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.MaintTable insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.MaintTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.MaintTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}


-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.MaintTable insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.MaintTable deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
        default:
            break;
    }
}

#pragma fetchrequest

-(NSFetchRequest *)maintTitlelistFetchRequest {
    NSFetchRequest *fetchrequest = [NSFetchRequest
                                    fetchRequestWithEntityName:@"MaintData" ];
    
    fetchrequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO]];
    
    return fetchrequest;
    
}

-(NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    NSFetchRequest *fetchRequest = [self maintTitlelistFetchRequest];
    
    _fetchedResultsController =[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}


@end
