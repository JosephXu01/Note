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

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITableView *noteListTableView;
@property (strong,nonatomic) NSMutableArray *noteArray;
@property (strong,nonatomic) NSMutableArray *searchResultsArray;
@property (strong,nonatomic) UISearchController *searchController;
@property (strong,nonatomic) NoteService *noteService;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.noteArray = [[self loadNotes] mutableCopy];

    self.noteListTableView.dataSource = self;
    self.noteListTableView.delegate = self;
    self.noteListTableView.tableHeaderView = self.searchController.searchBar;

    [self.navigationController.navigationBar setBarTintColor:[UIColor greenColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

}

-(NSArray *)loadNotes{
    return [self.noteService getAllNotes];
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

    cell.textLabel.text = note.title;
    cell.detailTextLabel.text = [self formatDate:note.lastModifiedDate];

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
-(void)viewWillAppear:(BOOL)animated{
    self.noteArray = [[self loadNotes] mutableCopy];

    [self.noteListTableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.destinationViewController isKindOfClass:[EditViewController class]]) {
        EditViewController *editViewController = segue.destinationViewController;

        if ([segue.identifier isEqualToString:@"add"]) {
            Note *newNote = [_noteService newNote];
            editViewController.currentNote = newNote;

        }else if([segue.identifier isEqualToString:@"edit"]){
            NSIndexPath *indexPath = [self.noteListTableView indexPathForCell:(UITableViewCell *)sender];
            Note *selectedNote = self.noteArray[indexPath.row];
            editViewController.currentNote = selectedNote;
        }
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.searchController.isActive) {
        self.searchController.searchBar.text = nil;
        [self dismissViewControllerAnimated:self.searchController completion:NULL];
    }

    [self performSegueWithIdentifier:@"edit" sender:[self.noteListTableView cellForRowAtIndexPath:indexPath]];
}

- (IBAction)editNote:(UIBarButtonItem *)sender {

}

- (IBAction)setting:(UIBarButtonItem *)sender {
}

#pragma mark - searchUpdateResults delegate
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    [self.searchResultsArray removeAllObjects];

    NSString *searchText = searchController.searchBar.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title CONTAINS[C] %@ OR SELF.body CONTAINS[C] %@ ",searchText,searchText];

    self.searchResultsArray = [[self.noteArray filteredArrayUsingPredicate:predicate] mutableCopy];

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
