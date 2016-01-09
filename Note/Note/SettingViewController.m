//
//  SettingViewController.m
//  Note
//
//  Created by Shallong on 15/12/12.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import "SettingViewController.h"
#import "User.h"
#import "NSUserDefaultsHelper.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UserService.h"
#import "NoteUtil.h"
#import "ReadingPasswordViewController.h"
#import "LoginPasswordTableViewController.h"
#import "HelpViewController.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;
@property (weak, nonatomic) IBOutlet UILabel *nickNamelabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UIView *faceView;
@property (strong,nonatomic) UIImageView *faceImageView;
@property (strong,nonatomic) UIImage *faceImage;
@property (strong,nonatomic) UIImagePickerController *imagePicker;
@property (strong,nonatomic) UIButton *logoutButton;

@property (strong,nonatomic) UserService *userService;

@property (strong,nonatomic) NSArray *settingsArray;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.nickNamelabel.text = [NSString stringWithFormat:@"Welcome, %@", [NSUserDefaultsHelper getUserName]];
    self.accountLabel.text = [NSString stringWithFormat:@"Account: %@", [NSUserDefaultsHelper getUserAccount]];

    self.settingsTableView.dataSource = self;
    self.settingsTableView.delegate = self;
    [self.settingsTableView setTableFooterView:self.logoutButton];

    [self initFaceImage];
}

-(void)viewWillAppear:(BOOL)animated{
    //TODO: when back,should deselect row
    [self.settingsTableView reloadData];
}

#pragma mark - tableview datasource/delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.settingsArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = (NSArray *)self.settingsArray[section];
    return array.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"settings";

    //find cell from the reuse pool
    UITableViewCell *cell = [self.settingsTableView dequeueReusableCellWithIdentifier:cellID];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    NSArray *section = (NSArray *)self.settingsArray[indexPath.section];
    cell.textLabel.text = section[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *selectedCell = [self.settingsTableView cellForRowAtIndexPath:indexPath];
    NSString *label = selectedCell.textLabel.text;

    if([label isEqualToString:@"Login Password"]) {
        LoginPasswordTableViewController *loginPasswordViewController = [[LoginPasswordTableViewController alloc] init];

        [self.navigationController pushViewController:loginPasswordViewController animated:YES];

    }else if ([label isEqualToString:@"Reading Password"]){
        ReadingPasswordViewController *readingPasswordViewController = [[ReadingPasswordViewController alloc] init];

        [self.navigationController pushViewController:readingPasswordViewController animated:YES];
    }else if ([label isEqualToString:@"Help"]){
        HelpViewController *helpViewController = [[HelpViewController alloc] init];

        [self.navigationController pushViewController:helpViewController animated:YES];
    }

}

#pragma mark - log out
- (IBAction)logOut:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure to log out?" preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Log Out" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self confirmedLogOut];
    }];

    [alertController addAction:cancelAction];
    [alertController addAction:yesAction];

//reason: 'Your application has presented a UIAlertController (<UIAlertController: 0x7facb843b4f0>) of style UIAlertControllerStyleActionSheet. The modalPresentationStyle of a UIAlertController with this style is UIModalPresentationPopover. You must provide location information for this popover through the alert controller's popoverPresentationController. You must provide either a sourceView and sourceRect or a barButtonItem.  If this information is not known when you present the alert controller, you may provide it in the UIPopoverPresentationControllerDelegate method -prepareForPopoverPresentation.'

    alertController.popoverPresentationController.sourceView = self.view;
    alertController.popoverPresentationController.sourceRect = CGRectMake(self.view.center.x, self.view.center.y, 1.0, 1.0);

    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)confirmedLogOut{
    [self presentViewController:[NoteUtil jumpToView:LOGIN] animated:YES completion:^{

        [NSUserDefaultsHelper removeAccount];

    }];
}

#pragma mark - take photo
-(void)takePhoto:(UITapGestureRecognizer *)gesture{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        [self takePhotoFromCamera];
    }];
    UIAlertAction *pictureAction = [UIAlertAction actionWithTitle:@"Photos Album" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        [self pickPhotoFromAlbums];
    }];

    [alertController addAction:cancelAction];
    [alertController addAction:cameraAction];
    [alertController addAction:pictureAction];

    //to support ipad
    alertController.popoverPresentationController.sourceView = self.view;
    alertController.popoverPresentationController.sourceRect = CGRectMake(self.faceView.frame.origin.x + self.faceView.frame.size.width, self.faceView.frame.origin.y + self.faceView.frame.size.height, 1.0, 1.0);

    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)takePhotoFromCamera{
    BOOL isCameraSupport = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (isCameraSupport) {
        self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        self.imagePicker.allowsEditing = YES;

        [self presentViewController:self.imagePicker animated:YES completion:NULL];
    }else{
        UIAlertController *alertController = [NoteUtil okButtonAlertControllerWithWarningTitleAndMessage:@"The camera is not available!"];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

-(void)pickPhotoFromAlbums{
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:self.imagePicker animated:YES completion:NULL];

}

#pragma mark - imagepicker delegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }

    //if camera ,save photo
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }

    self.faceImage = image;

    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - init
-(NSArray *)settingsArray{
    if (!_settingsArray) {
        NSString *settingsPlistPath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
        _settingsArray = [[NSArray alloc] initWithContentsOfFile:settingsPlistPath];

        NSLog(@"%@",_settingsArray);
    }
    return _settingsArray;
}

-(UIButton *)logoutButton{
    if (!_logoutButton) {
        _logoutButton = [[UIButton alloc] init];

        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        _logoutButton.frame = CGRectMake(0, 0, screenWidth, 30);

        [_logoutButton setTitle:@"Log Out" forState:UIControlStateNormal];
        [_logoutButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_logoutButton setBackgroundColor:[UIColor redColor]];

        [_logoutButton addTarget:self action:@selector(logOut:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutButton;
}

-(void)initFaceImage{
    self.faceImageView.contentMode = UIViewContentModeScaleToFill;

    NSData *faceImageData = [NSUserDefaultsHelper getFaceImage];
    if (faceImageData) {
        self.faceImageView.image =[UIImage imageWithData:faceImageData];
    }else{
        self.faceImageView.image = [UIImage imageNamed:@"camera.png"];
    }

    [self.faceView addSubview:self.faceImageView];

    UITapGestureRecognizer *tapFace = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhoto:)];
    [self.faceView addGestureRecognizer:tapFace];
    
}

-(void)setFaceImage:(UIImage *)faceImage{
    self.faceImageView.image = faceImage;

    User *user = [self.userService getUser];
    user.faceImage = UIImagePNGRepresentation(faceImage);
    [self.userService updateUser];

    [NSUserDefaultsHelper setFaceImage:user.faceImage];

    //[self.view setNeedsDisplay];
}

-(UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}

-(UIImageView *)faceImageView{
    if (!_faceImageView) {
        _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.faceView.bounds.size.width, self.faceView.bounds.size.height)];
    }
    return _faceImageView;
}

-(UserService *)userService{
    if (!_userService) {
        _userService = [[UserService alloc] init];
    }
    return _userService;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
