//
//  incViewContoller.m
//  nmiss-ios
//
//  Created by NIall McGinness on 2015-04-17.
//  Copyright (c) 2015 Niall McGinness. All rights reserved.
//

#import "incViewContoller.h"
#import "IncEntryViewController.h"
#import "UIElements.h"
#import "IconMaker.h"
#import "CoreDataStack.h"
#import "IncData.h"

@interface incViewContoller () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *IncTable;

@end

@implementation incViewContoller

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self updateTableView];
    [self.view addSubview:[self incToolbar]];
    [self.view addSubview:[self bottomToolbar]];
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
    
    self.IncTable.dataSource = self;
    self.IncTable.delegate = self;
}


-(UIToolbar *)incToolbar{
    UIToolbar *incToolbar = [[UIElements alloc] createTopToolBar];
    incToolbar.clipsToBounds = true;
    
    UIImage *backButtonImage = [[IconMaker alloc] createBackChevronImage];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(dismissSelf)];
    backButton.imageInsets = UIEdgeInsetsMake(6.0, 0 , -6.0, 0);
    
    UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithTitle:@"incidents" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIBarButtonItem *flexibleButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [incToolbar setItems:@[backButton,flexibleButton,titleButton,flexibleButton] animated:false];
    return incToolbar;
}

-(UIToolbar *)bottomToolbar{
    UIToolbar *bottomToolbar = [[UIElements alloc] createBottomToolBar];
    bottomToolbar.clipsToBounds = true;
    
    UIImage *backButtonImage = [[IconMaker alloc] createBackChevronImage];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(dismissSelf)];
    backButton.imageInsets = UIEdgeInsetsMake(6.0, 0 , -6.0, 0);
    
    UIBarButtonItem *flexibleButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
   
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(loadAddIncView)];
    
    [bottomToolbar setItems:@[backButton,flexibleButton, addButton] animated:false];
    return bottomToolbar;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"incSegue"]) {
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.IncTable indexPathForCell:cell];
        UINavigationController *navigationController = segue.destinationViewController;
        IncEntryViewController *IncTitleViewController = (IncEntryViewController *) navigationController.topViewController;
        IncTitleViewController.entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    }
    
}


-(void)loadAddIncView{
    NSString *storyboardName =  @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * incvc = [storyboard instantiateViewControllerWithIdentifier:@"incEntry"];
    [self presentViewController:incvc animated:NO completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchedResultsController.sections.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController
                                                    sections][section];
    return [sectionInfo numberOfObjects];
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID =  @"IncCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    //cell.textLabel.text = self.protEntry.protocolTitle;
    IncData *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = entry.body;
    //cell.textLabel.text = @" No Incidents Entered ";
    return cell;
}

#pragma -- delete data

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    IncData *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [[coreDataStack managedObjectContext] deleteObject:entry];
    [coreDataStack saveContext];
}

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.IncTable beginUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.IncTable insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.IncTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.IncTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    NSLog(@"controller did chnage content called");
    [self.IncTable endUpdates];
    
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.IncTable insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.IncTable deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
        default:
            break;
    }
}


-(NSFetchRequest *)incTitlelistFetchRequest {
    NSFetchRequest *fetchrequest = [NSFetchRequest
                                    fetchRequestWithEntityName:@"IncData" ];
    
    fetchrequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"body" ascending:NO]];
    
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
    [self numberOfEntries];
    return _fetchedResultsController;
}


-(NSInteger)numberOfEntries {
    NSInteger entries = self.fetchedResultsController.fetchedObjects.count;
    return entries;
}

@end
