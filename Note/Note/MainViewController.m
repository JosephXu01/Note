//
//  MainViewController.m
//  
//
//  Created by Shallong on 15/12/12.
//
//

#import "MainViewController.h"
#import "NoteService.h"
#import "Note.h"
#import "EditViewController.h"
#import "MoreActionTableViewController.h"
#import "AttributedBody.h"
#import "SettingViewController.h"

#define ADD @"add"
#define EDIT @"edit"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITableView *noteListTableView;
@property (strong,nonatomic) NSMutableArray *noteArray;
@property (strong,nonatomic) NSMutableArray *searchResultsArray;
@property (strong,nonatomic) UISearchController *searchController;
@property (strong,nonatomic) NoteService *noteService;

@property (strong,nonatomic) UIRefreshControl *refreshControl;
@property (strong,nonatomic) EditViewController *editViewController;

@property (assign) NSUInteger currentIndex;
@end

@implementation MainViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.noteArray = [[self loadNotes] mutableCopy];

    //do this on ipad , if not ,the edit page will be blank, will cause error if click on "Done" button
    //of course we can handle this on button click event , but i think it's better to show something for user
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.editViewController = (EditViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

        self.editViewController.currentNote = [self.noteArray firstObject];
    }

    self.noteListTableView.dataSource = self;
    self.noteListTableView.delegate = self;
    self.noteListTableView.tableHeaderView = self.searchController.searchBar;

    [self.noteListTableView addSubview:self.refreshControl];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor greenColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noteUpdated:) name:NOTE_UPDATED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteNoteFromEditPage:) name:NOTE_DELETED_FROM_EDIT_PAGE object:nil];
}

-(NSArray *)loadNotes{
    return [self.noteService getAllNotes];
}

-(void)refreshData:(UIRefreshControl *)refreshControl{
        refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Syncing..."];
    [refreshControl beginRefreshing];

    self.noteArray = [[self loadNotes] mutableCopy];


    [refreshControl endRefreshing];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Completed load %lu notes.",(unsigned long)self.noteArray.count] ] ;

    [self.noteListTableView reloadData];
}

#pragma mark - cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"note";

    //find cell from the reuse pool
    UITableViewCell *cell = [self.noteListTableView dequeueReusableCellWithIdentifier:cellID];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }

    Note *note = nil;

    if (self.searchController.isActive) {
        note = self.searchResultsArray[indexPath.row];
    }else{
        note = self.noteArray[indexPath.row];
    }

    NSString *preBody = @"";
    if (note.body) {
        AttributedBody *body = [NSKeyedUnarchiver unarchiveObjectWithData:note.body];
        NSString *s = body.body.string;

        preBody = [s substringToIndex:s.length > 100? 100:s.length];
    }

    cell.textLabel.text = note.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@  %@",[self formatDate:note.lastModifiedDate],preBody];

    return cell;
}

-(NSString *)formatDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *strDate = [formatter stringFromDate:date];

    return strDate;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchController.isActive) {
        return self.searchResultsArray.count;
    }
    return self.noteArray.count;
}

#pragma mark - delete note
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        Note *note;
        if (self.searchController.isActive) {
            note = self.searchResultsArray[indexPath.row];

            [self.searchResultsArray removeObject:note];
        }else{
            note = self.noteArray[indexPath.row];
        }

        [_noteService deleteNote:note];

        [self.noteArray removeObject:note];

        [self.noteListTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self performSegueWithIdentifier:EDIT sender:[self.noteListTableView cellForRowAtIndexPath:indexPath]];
}

#pragma mark - prepareforsegue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue.destinationViewController topViewController] isKindOfClass:[EditViewController class]]) {
        EditViewController *editViewController = (EditViewController *)[segue.destinationViewController topViewController];

        if ([segue.identifier isEqualToString:ADD]) {
            Note *newNote = [_noteService newNote];
            editViewController.currentNote = newNote;

            //insert new note to the fist of the array
            [self.noteArray insertObject:newNote atIndex:0];
            [self.noteListTableView insertRowsAtIndexPaths:@[[self firstRow]] withRowAnimation:NO];
            self.currentIndex = 0;
        }else if([segue.identifier isEqualToString:EDIT]){
            NSIndexPath *indexPath = [self.noteListTableView indexPathForCell:(UITableViewCell *)sender];
            Note *selectedNote = self.noteArray[indexPath.row];
            editViewController.currentNote = selectedNote;
            self.currentIndex = indexPath.row;

            //select note in search page
            if (self.searchController.isActive) {
                Note *searchNote = self.searchResultsArray[indexPath.row];
                editViewController.currentNote = searchNote;
                self.currentIndex = [self.noteArray indexOfObject:searchNote];

                self.searchController.searchBar.text = nil;
                [self.searchController dismissViewControllerAnimated:YES completion:NULL];
            }
        }

        //for split view
        editViewController.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        editViewController.navigationItem.leftItemsSupplementBackButton = YES;
    }
}
- (IBAction)settings:(UIBarButtonItem *)sender {
    SettingViewController *settings = [self.storyboard instantiateViewControllerWithIdentifier:SETTINGS_STORYBOARD_ID];

    [self.navigationController pushViewController:settings animated:YES];
}

#pragma mark - notification
//when note updated , move it to the first row
-(void)noteUpdated:(NSNotification *)notification{
    NSUInteger index = self.currentIndex;
    Note *updatedNote = self.noteArray[index];

    if (!index == 0) {
        [self.noteArray removeObjectAtIndex:index];
        [self.noteListTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]] withRowAnimation:NO];

        [self.noteArray insertObject:updatedNote atIndex:0];
        [self.noteListTableView insertRowsAtIndexPaths:@[[self firstRow]] withRowAnimation:NO];
    }else{
        [self.noteListTableView reloadRowsAtIndexPaths:@[[self firstRow]] withRowAnimation:NO];
    }
}

//note delet from edit page
-(void)deleteNoteFromEditPage:(NSNotification *)notification{
    NSUInteger index = self.currentIndex;
    Note *noteToDelete = self.noteArray[index];

    [_noteService deleteNote:noteToDelete];
    [self.noteArray removeObject:noteToDelete];
    [self.noteListTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];

    //on ipad, switch to the next one
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self performSegueWithIdentifier:EDIT sender:[self.noteListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]]];
    }
}

-(NSIndexPath *)firstRow{
    return [NSIndexPath indexPathForItem:0 inSection:0];
}

- (IBAction)editNote:(UIBarButtonItem *)sender {

}

- (IBAction)setting:(UIBarButtonItem *)sender {
}

#pragma mark - searchUpdateResults delegate
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    [self.searchResultsArray removeAllObjects];

    NSString *searchText = searchController.searchBar.text.lowercaseString;

    [self.noteArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Note *note = (Note *)obj;
        if ([note.title.lowercaseString containsString:searchText]) {

            [self.searchResultsArray addObject:note];
        }else if (note.body) {
            AttributedBody *body = [NSKeyedUnarchiver unarchiveObjectWithData:note.body];

            if ([body.body.string.lowercaseString containsString:searchText]) {
                [self.searchResultsArray addObject:note];
            }

        }
    }];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.noteListTableView reloadData];
    });
}

#pragma mark - init
-(UISearchController *)searchController{
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        [_searchController.searchBar sizeToFit];
    }
    return _searchController;
}

-(NSMutableArray *)searchResultsArray{
    if (!_searchResultsArray) {
        _searchResultsArray = [[NSMutableArray alloc] init];
    }
    return _searchResultsArray;
}

-(NSMutableArray *)noteArray{
    if (!_noteArray) {
        _noteArray = [[NSMutableArray alloc] init];
    }
    return _noteArray;
}

-(NoteService *)noteService{
    if (!_noteService) {
        _noteService = [[NoteService alloc] init];
    }
    return _noteService;
}

-(UIRefreshControl *)refreshControl{
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];

        [_refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
