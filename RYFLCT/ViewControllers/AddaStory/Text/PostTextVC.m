
//
//  PostTextVC.m
//  RYFLCT
//
//  Created by Tops on 1/13/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import "PostTextVC.h"
#import "HomeVC.h"
#import "Header.h"
#import "HomeCell.h"
#import "HomeCell_2.h"
#import "HomeCell_3.h"
//#import "CryptLib.h"

@interface PostTextVC ()<UIImagePickerControllerDelegate,YMSPhotoPickerViewControllerDelegate>
{
    NSString *strUserToken;
    UIImage *img1;
    NSData *imageData;
    MBProgressHUD * HUD;
    int flagCameraSelectORnot;
    NSMutableArray *arrayUploadTextData;
    NSMutableArray *mutableImages;
}
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *imagesAdd;
@end

@implementation PostTextVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    flagCameraSelectORnot = 0;
    mutableImages = [NSMutableArray array];
    arrayUploadTextData=[[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    strUserToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"userToken"];
    
    _viewTextSmily.layer.cornerRadius=10;
    _viewTextSmily.layer.masksToBounds=YES;
    
    [_sliderTextSmily addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_sliderTextSmily setThumbImage: [UIImage imageNamed:@"01sad1"] forState:UIControlStateNormal];
    
    _tvTextPost.text = @"Add a Story";
    _tvTextPost.textColor = [UIColor colorWithRed:85.0 / 255.0 green:85.0 / 255.0 blue:85.0 / 255.0 alpha:1.0];
    _tvTextPost.layer.cornerRadius = 5;
    _tvTextPost.layer.borderWidth = 1;
    _tvTextPost.layer.borderColor = [[UIColor colorWithRed:85.0 / 255.0 green:85.0 / 255.0 blue:85.0 / 255.0 alpha:1.0]CGColor];
    _tvTextPost.layer.masksToBounds = YES;
    
    //_tvTextPost.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClickedBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (IBAction)sliderValueChanged:(UISlider *)sender
{
    NSLog(@"slider value = %f", sender.value);
    
    NSString *strValue = [NSString stringWithFormat:@"%d",(int)sender.value];
    NSLog(@"Value %@",strValue);
    
    _lblTextSmilyScore.text = [NSString stringWithFormat:@"%d",(int)sender.value];
    
    if([strValue isEqualToString:@"0"] || [strValue isEqualToString:@"1"] || [strValue isEqualToString:@"2"] || [strValue isEqualToString:@"3"] || [strValue isEqualToString:@"4"] || [strValue isEqualToString:@"5"])
    {
        [_sliderTextSmily setThumbImage: [UIImage imageNamed:@"01sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"6"] || [strValue isEqualToString:@"7"] || [strValue isEqualToString:@"8"] || [strValue isEqualToString:@"9"] || [strValue isEqualToString:@"10"])
    {
        [_sliderTextSmily setThumbImage: [UIImage imageNamed:@"02sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"11"] || [strValue isEqualToString:@"12"] || [strValue isEqualToString:@"13"] || [strValue isEqualToString:@"14"] || [strValue isEqualToString:@"15"])
    {
        [_sliderTextSmily setThumbImage: [UIImage imageNamed:@"03sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"16"] || [strValue isEqualToString:@"17"] || [strValue isEqualToString:@"18"] || [strValue isEqualToString:@"19"] || [strValue isEqualToString:@"20"])
    {
        [_sliderTextSmily setThumbImage: [UIImage imageNamed:@"04sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"21"] || [strValue isEqualToString:@"22"] || [strValue isEqualToString:@"23"] || [strValue isEqualToString:@"24"] || [strValue isEqualToString:@"25"])
    {
        [_sliderTextSmily setThumbImage: [UIImage imageNamed:@"05sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"26"] || [strValue isEqualToString:@"27"] || [strValue isEqualToString:@"28"] || [strValue isEqualToString:@"29"] || [strValue isEqualToString:@"30"])
    {
        [_sliderTextSmily setThumbImage: [UIImage imageNamed:@"06sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"31"] || [strValue isEqualToString:@"32"] || [strValue isEqualToString:@"33"] || [strValue isEqualToString:@"34"] || [strValue isEqualToString:@"35"])
    {
        [_sliderTextSmily setThumbImage: [UIImage imageNamed:@"07sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"36"] || [strValue isEqualToString:@"37"] || [strValue isEqualToString:@"38"] || [strValue isEqualToString:@"39"] || [strValue isEqualToString:@"40"])
    {
        [_sliderTextSmily setThumbImage: [UIImage imageNamed:@"08sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"41"] || [strValue isEqualToString:@"42"] || [strValue isEqualToString:@"43"] || [strValue isEqualToString:@"44"] || [strValue isEqualToString:@"45"])
    {
        [_sliderTextSmily setThumbImage: [UIImage imageNamed:@"09sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"46"] || [strValue isEqualToString:@"47"] || [strValue isEqualToString:@"48"] || [strValue isEqualToString:@"49"] || [strValue isEqualToString:@"50"])
    {
        [_sliderTextSmily setThumbImage: [UIImage imageNamed:@"10sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"51"] || [strValue isEqualToString:@"52"] || [strValue isEqualToString:@"53"] || [strValue isEqualToString:@"54"] || [strValue isEqualToString:@"55"])
    {
        [_sliderTextSmily setThumbImage: [UIImage imageNamed:@"11sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"56"] || [strValue isEqualToString:@"57"] || [strValue isEqualToString:@"58"] || [strValue isEqualToString:@"59"] || [strValue isEqualToString:@"60"])
    {
        [_sliderTextSmily setThumbImage: [UIImage imageNamed:@"12happy1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"61"] || [strValue isEqualToString:@"62"] || [strValue isEqualToString:@"63"] || [strValue isEqualToString:@"64"] || [strValue isEqualToString:@"65"])
    {
        [_sliderTextSmily setThumbImage: [UIImage imageNamed:@"13happy1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"66"] || [strValue isEqualToString:@"67"] || [strValue isEqualToString:@"68"] || [strValue isEqualToString:@"69"] || [strValue isEqualToString:@"70"])
    {
        [_sliderTextSmily setThumbImage: [UIImage imageNamed:@"14happy1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"71"] || [strValue isEqualToString:@"72"] || [strValue isEqualToString:@"73"] || [strValue isEqualToString:@"74"] || [strValue isEqualToString:@"75"])
    {
        [_sliderTextSmily setThumbImage: [UIImage imageNamed:@"15happy1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"76"] || [strValue isEqualToString:@"77"] || [strValue isEqualToString:@"78"] || [strValue isEqualToString:@"79"] || [strValue isEqualToString:@"80"])
    {
        [_sliderTextSmily setThumbImage: [UIImage imageNamed:@"16happy1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"81"] || [strValue isEqualToString:@"82"] || [strValue isEqualToString:@"83"] || [strValue isEqualToString:@"84"] || [strValue isEqualToString:@"85"])
    {
        [_sliderTextSmily setThumbImage: [UIImage imageNamed:@"17happy1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"86"] || [strValue isEqualToString:@"87"] || [strValue isEqualToString:@"88"] || [strValue isEqualToString:@"89"] || [strValue isEqualToString:@"90"])
    {
        [_sliderTextSmily setThumbImage: [UIImage imageNamed:@"18happy1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"91"] || [strValue isEqualToString:@"92"] || [strValue isEqualToString:@"93"] || [strValue isEqualToString:@"94"] || [strValue isEqualToString:@"95"])
    {
        [_sliderTextSmily setThumbImage: [UIImage imageNamed:@"19happy1"] forState:UIControlStateNormal];
    }
    else //if([strValue isEqualToString:@"96"] || [strValue isEqualToString:@"97"] || [strValue isEqualToString:@"98"] || [strValue isEqualToString:@"99"] || [strValue isEqualToString:@"100"])
    {
        [_sliderTextSmily setThumbImage: [UIImage imageNamed:@"20happy1"] forState:UIControlStateNormal];
    }
}

- (IBAction)btnClickedTextPost:(id)sender
{
    if(_txtAddaStoryUploadText.text.length == 0)
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"RYFLCT" message:@"Please Enter Add a Story" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    /*else if ([_tvTextPost.text isEqualToString:@"Add a Story"])
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"RYFLCT" message:@"Please Enter Add a Story" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }*/
    else
    {
        [self showMBProgressWithShow:YES];
        
        NSString *plainText = _txtAddaStoryUploadText.text;
        NSString *key = @"9B307D9DB5EAA3E360338F9AD4218D7E";
        NSString *iv = @"8FB1A2080C648F95";
        
        //CryptLib *cryptoLib = [[CryptLib alloc] init];
        
        //NSString *encryptedString = [cryptoLib encryptPlainTextWith:plainText key:key iv:iv];
        //NSLog(@"encryptedString %@", encryptedString);
        
        //NSString *decryptedString = [cryptoLib decryptCipherTextWith:encryptedString key:key iv:iv];
       // NSLog(@"decryptedString %@", decryptedString);
        
        NSData *imageDataCamera = UIImageJPEGRepresentation(_imgAddCameraText.image,0.5);
        NSData *imageDataPhoto = UIImageJPEGRepresentation(_imgAddPhotoText.image,0.5);
        NSDictionary *innerDict = @{@"heading":@"this is heading",
                                    @"details":_txtAddaStoryUploadText.text,
                                    @"usertoken":strUserToken,
                                    @"description":_txtAddaStoryUploadText.text,
                                    @"moodicon":_lblTextSmilyScore.text
                                    };
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];

        NSString *strUrl=[NSString stringWithFormat:@"%@stories",API_SERVER_URL];
        
        [manager POST:strUrl parameters:innerDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
         {
             for (int i = 0; i < [arrayUploadTextData count]; i++)
             {
                 int randomID = arc4random() % 2000 + 1000;
                 NSString * imageName = [NSString stringWithFormat:@"%d.jpeg",randomID];
                 [formData appendPartWithFileData:[arrayUploadTextData objectAtIndex:i] name:[NSString stringWithFormat:@"media%d",i] fileName:imageName mimeType:@"image/jpeg"];
             }
             
             /*if(imageDataCamera == nil || imageDataCamera == NULL || [imageDataCamera isKindOfClass:[NSNull class]])
             {
                 
             }
             else
             {
                 int randomID = arc4random() % 2000 + 1000;
                 NSString * imageName = [NSString stringWithFormat:@"%d.jpeg",randomID];
                 [formData appendPartWithFileData:imageDataCamera name:@"media1" fileName:imageName mimeType:@"image/jpeg"];
             }
             if(imageDataPhoto == nil || imageDataPhoto == NULL || [imageDataPhoto isKindOfClass:[NSNull class]])
             {
                 
             }
             else
             {
                 int randomID = arc4random() % 2000 + 1000;
                 NSString * imageName = [NSString stringWithFormat:@"%d.jpeg",randomID];
                 [formData appendPartWithFileData:imageDataPhoto name:@"media2" fileName:imageName mimeType:@"image/jpeg"];
             }*/
         } success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"JSON: %@", responseObject);
             Boolean Status=[[responseObject valueForKey:@"success"]boolValue];
             if(Status==1)
             {
                 [self showMBProgressWithShow:NO];
                 [self dismissViewControllerAnimated:YES completion:Nil];
                 
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"RYFLCT" message:[responseObject valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alert show];
                 
             }
             else
             {
                 [self showMBProgressWithShow:NO];
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"RYFLCT" message:[responseObject valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alert show];
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [APP_DELEGATE showMBProgressWithShow:NO];
             NSLog(@"Error: %@", error);
             //  [APP_DELEGATE AlertMessage:@"Internal server error"];
         }];
    }
    
    
}

- (IBAction)btnClickeTextCamera:(id)sender
{
    flagCameraSelectORnot = 0;
    YMSPhotoPickerViewController *pickerViewController = [[YMSPhotoPickerViewController alloc] init];
    UIColor *customColor = [UIColor colorWithRed:224.0/255.0 green:16.0/255.0 blue:79.0/255.0 alpha:1.0];
    pickerViewController.theme.titleLabelTextColor = [UIColor blackColor];
    pickerViewController.theme.tintColor = [UIColor blackColor];
    pickerViewController.theme.orderTintColor = customColor;
    pickerViewController.theme.orderLabelTextColor = [UIColor whiteColor];
    //pickerViewController.theme.cameraVeilColor = customColor;
    pickerViewController.theme.cameraIconColor = [UIColor whiteColor];
    pickerViewController.theme.statusBarStyle = UIStatusBarStyleDefault;
    
    [self yms_presentCustomAlbumPhotoView:pickerViewController delegate:self];
    /*if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        
        [self presentModalViewController:imagePicker animated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"RYFLCT"
                                                       message:@"Unable to find a camera on your device."
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    }*/
}

- (IBAction)btnClickedTextPhoto:(id)sender
{
    flagCameraSelectORnot = 1;
    /*UIImagePickerController *imgpickr1=[[UIImagePickerController alloc]init];
    imgpickr1.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    imgpickr1.delegate =(id)self;
    imgpickr1.allowsEditing=YES;
    [self presentViewController:imgpickr1 animated:YES completion:nil];*/
    
    YMSPhotoPickerViewController *pickerViewController = [[YMSPhotoPickerViewController alloc] init];
    UIColor *customColor = [UIColor colorWithRed:224.0/255.0 green:16.0/255.0 blue:79.0/255.0 alpha:1.0];
    pickerViewController.theme.titleLabelTextColor = [UIColor blackColor];
    pickerViewController.theme.tintColor = [UIColor blackColor];
    pickerViewController.theme.orderTintColor = customColor;
    pickerViewController.theme.orderLabelTextColor = [UIColor whiteColor];
    //pickerViewController.theme.cameraVeilColor = customColor;
    pickerViewController.theme.cameraIconColor = [UIColor whiteColor];
    pickerViewController.theme.statusBarStyle = UIStatusBarStyleDefault;
    [self yms_presentCustomAlbumPhotoView:pickerViewController delegate:self];
}

- (IBAction)btnClcikedTextRecord:(id)sender
{
    
}

#pragma Mark ImagePickerController::

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if(flagCameraSelectORnot == 0)
    {
        img1=[info valueForKey:UIImagePickerControllerEditedImage];
        
        _imgAddCameraText.image = img1;
        
        //    _imgProfile.layer.cornerRadius=_imgProfile.frame.size.height/2;
        //    _imgProfile.layer.borderWidth=1;
        //    _imgProfile.layer.borderColor=[[UIColor blackColor]CGColor];
        
        _imgAddCameraText.clipsToBounds = YES;
        imageData =UIImageJPEGRepresentation(img1, 0.5);
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        img1=[info valueForKey:UIImagePickerControllerEditedImage];
        
        _imgAddPhotoText.image = img1;
        
        //    _imgProfile.layer.cornerRadius=_imgProfile.frame.size.height/2;
        //    _imgProfile.layer.borderWidth=1;
        //    _imgProfile.layer.borderColor=[[UIColor blackColor]CGColor];
        
        _imgAddPhotoText.clipsToBounds = YES;
        imageData =UIImageJPEGRepresentation(img1, 0.5);
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark UITextview Delegate Methods ::

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    //_tvTextPost.text = @"";
    if([textView.text isEqualToString:@"Add a Story"])
    {
        _tvTextPost.text = @"";
    }
    else
    {
        
    }
    _tvTextPost.textColor = [UIColor colorWithRed:85.0 / 255.0 green:85.0 / 255.0 blue:85.0 / 255.0 alpha:1.0];
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(_tvTextPost.text.length == 0)
    {
        _tvTextPost.textColor = [UIColor colorWithRed:85.0 / 255.0 green:85.0 / 255.0 blue:85.0 / 255.0 alpha:1.0];
        _tvTextPost.text = @"Add a Story";
        [_tvTextPost resignFirstResponder];
    }
}

#pragma mark Progressview Method ::

-(void)showMBProgressWithShow:(BOOL)show
{
    if(show == YES)
    {
        [HUD removeFromSuperview];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        HUD  = [[MBProgressHUD alloc]initWithView:self.view];
        HUD.label.text = @"";
        HUD.detailsLabel.text = @"Loading";
        HUD.mode = MBProgressHUDModeIndeterminate;
        [self.view addSubview:HUD];
        [HUD removeFromSuperViewOnHide];
        [HUD showAnimated:YES];
    }
    else
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [HUD hideAnimated:YES afterDelay:1];
        [HUD removeFromSuperview];
    }
}

#pragma mark - YMSPhotoPickerViewControllerDelegate

- (void)photoPickerViewControllerDidReceivePhotoAlbumAccessDenied:(YMSPhotoPickerViewController *)picker
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Allow photo album access?", nil) message:NSLocalizedString(@"Need your permission to access photo albumbs", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Settings", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    [alertController addAction:dismissAction];
    [alertController addAction:settingsAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)photoPickerViewControllerDidReceiveCameraAccessDenied:(YMSPhotoPickerViewController *)picker
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Allow camera access?", nil) message:NSLocalizedString(@"Need your permission to take a photo", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Settings", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    [alertController addAction:dismissAction];
    [alertController addAction:settingsAction];
    
    // The access denied of camera is always happened on picker, present alert on it to follow the view hierarchy
    [picker presentViewController:alertController animated:YES completion:nil];
}

- (void)photoPickerViewController:(YMSPhotoPickerViewController *)picker didFinishPickingImage:(UIImage *)image
{
    [picker dismissViewControllerAnimated:YES completion:^() {
        self.images = @[image];
        [self.tblUploadText reloadData];
    }];
}

- (void)photoPickerViewController:(YMSPhotoPickerViewController *)picker didFinishPickingImages:(NSArray *)photoAssets
{
    //[arrayBookaDesignerImages removeAllObjects];
    [picker dismissViewControllerAnimated:YES completion:^() {
        
        PHImageManager *imageManager = [[PHImageManager alloc] init];
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.networkAccessAllowed = YES;
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.synchronous = YES;
        
        
        for (PHAsset *asset in photoAssets) {
            //CGSize targetSize=CGSizeMake(96, 96);
            CGSize targetSize = CGSizeMake((CGRectGetWidth(self.tblUploadText.bounds)) * [UIScreen mainScreen].scale, (CGRectGetHeight(self.tblUploadText.bounds)) * [UIScreen mainScreen].scale);
            [imageManager requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *image, NSDictionary *info) {
                [mutableImages addObject:image];
                NSData *imgData2 = UIImageJPEGRepresentation(image, 0.5);
                [arrayUploadTextData addObject:imgData2];
            }];
        }
        
        self.images = [mutableImages copy];
        
        //self.imgDefault.hidden=YES;
        self.tblUploadText.hidden=NO;
        NSLog(@"Array : %ld",arrayUploadTextData.count);
        //self.scrBookaDesigner.hidden=NO;
        //_btnObjUpload.hidden=NO;
        [self.tblUploadText reloadData];
    }];
}

#pragma mark UITableview Datasource and Delegate Methods::

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger Data =self.images.count;
    
    if(Data==0)
    {
        static NSString *MyIdentifier = @"HomeCell";
        HomeCell *cellHome = (HomeCell *)[_tblUploadText dequeueReusableCellWithIdentifier:MyIdentifier];
        
        //cellHome.contentView.layer.cornerRadius = 12.0;
        
        cellHome.contentView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        cellHome.contentView.layer.shadowOffset = CGSizeMake(2, 2);
        cellHome.contentView.layer.shadowOpacity = 15;
        cellHome.contentView.layer.shadowRadius = 5.0;
        cellHome.contentView.clipsToBounds = NO;
        
        cellHome.viewHome.layer.cornerRadius = 14.0;
        cellHome.viewHome.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        cellHome.viewHome.layer.shadowOffset = CGSizeMake(2, 2);
        cellHome.viewHome.layer.shadowOpacity = 15;
        cellHome.viewHome.layer.shadowRadius = 5.0;
        cellHome.viewHome.clipsToBounds = NO;
        cellHome.viewHome.layer.masksToBounds = YES;
        
       cellHome.imgHome.image = [self.images objectAtIndex:indexPath.item];
        
        //cellHome.imgHome.image =[UIImage imageNamed:[arrayHomedataList objectAtIndex:indexPath.row]];
        return cellHome;
    }
    else if (Data==1)
    {
        static NSString *MyIdentifier = @"HomeCell";
        HomeCell *cellHome = (HomeCell *)[_tblUploadText dequeueReusableCellWithIdentifier:MyIdentifier];
        
        //cellHome.contentView.layer.cornerRadius = 12.0;
        
        cellHome.contentView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        cellHome.contentView.layer.shadowOffset = CGSizeMake(2, 2);
        cellHome.contentView.layer.shadowOpacity = 15;
        cellHome.contentView.layer.shadowRadius = 5.0;
        cellHome.contentView.clipsToBounds = NO;
        
        cellHome.viewHome.layer.cornerRadius = 14.0;
        cellHome.viewHome.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        cellHome.viewHome.layer.shadowOffset = CGSizeMake(2, 2);
        cellHome.viewHome.layer.shadowOpacity = 15;
        cellHome.viewHome.layer.shadowRadius = 5.0;
        cellHome.viewHome.clipsToBounds = NO;
        cellHome.viewHome.layer.masksToBounds = YES;
        
       cellHome.imgHome.image = [self.images objectAtIndex:indexPath.item];
        
        return cellHome;
    }
    else if (Data==2)
    {
        static NSString *MyIdentifier = @"HomeCell_2";
        HomeCell_2 *cellHome = (HomeCell_2 *)[_tblUploadText dequeueReusableCellWithIdentifier:MyIdentifier];
        
        //cellHome.contentView.layer.cornerRadius = 12.0;
        
        cellHome.contentView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        cellHome.contentView.layer.shadowOffset = CGSizeMake(2, 2);
        cellHome.contentView.layer.shadowOpacity = 15;
        cellHome.contentView.layer.shadowRadius = 5.0;
        cellHome.contentView.clipsToBounds = NO;
        
        cellHome.viewHome2.layer.cornerRadius = 14.0;
        cellHome.viewHome2.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        cellHome.viewHome2.layer.shadowOffset = CGSizeMake(2, 2);
        cellHome.viewHome2.layer.shadowOpacity = 15;
        cellHome.viewHome2.layer.shadowRadius = 5.0;
        cellHome.viewHome2.clipsToBounds = NO;
        cellHome.viewHome2.layer.masksToBounds = YES;
        
        cellHome.imgHome1.image = [self.images objectAtIndex:0];
        cellHome.imgHome2.image = [self.images objectAtIndex:1];
        return cellHome;
    }
    else
    {
        static NSString *MyIdentifier = @"HomeCell_3";
        HomeCell_3 *cellHome = (HomeCell_3 *)[_tblUploadText dequeueReusableCellWithIdentifier:MyIdentifier];
        
        //cellHome.contentView.layer.cornerRadius = 12.0;
        
        if(Data==3)
        {
            cellHome.lblHome3ImageCount.hidden=YES;
        }
        else
        {
            cellHome.lblHome3ImageCount.hidden=NO;
            NSInteger count=Data-3;
            cellHome.lblHome3ImageCount.text=[NSString stringWithFormat:@"+%ld",count];
        }
        
        cellHome.contentView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        cellHome.contentView.layer.shadowOffset = CGSizeMake(2, 2);
        cellHome.contentView.layer.shadowOpacity = 15;
        cellHome.contentView.layer.shadowRadius = 5.0;
        cellHome.contentView.clipsToBounds = NO;
        
        cellHome.viewHomecell3.layer.cornerRadius = 14.0;
        cellHome.viewHomecell3.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        cellHome.viewHomecell3.layer.shadowOffset = CGSizeMake(2, 2);
        cellHome.viewHomecell3.layer.shadowOpacity = 15;
        cellHome.viewHomecell3.layer.shadowRadius = 5.0;
        cellHome.viewHomecell3.clipsToBounds = NO;
        cellHome.viewHomecell3.layer.masksToBounds = YES;
        
        cellHome.imgHome1.image = [self.images objectAtIndex:0];
        cellHome.imgHome2.image = [self.images objectAtIndex:1];
        cellHome.imgHome3.image = [self.images objectAtIndex:2];
    
        return cellHome;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  320;
}
@end
