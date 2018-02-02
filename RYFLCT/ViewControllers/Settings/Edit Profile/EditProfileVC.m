
//
//  EditProfileVC.m
//  RYFLCT
//
//  Created by admin on 25/01/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import "EditProfileVC.h"
#import "MBProgressHUD.h"
#import "Header.h"
#import <coreLocation/CoreLocation.h>

@interface EditProfileVC ()<UIPickerViewDelegate,UIPickerViewDataSource,CLLocationManagerDelegate>
{
    UIPickerView *PickerviewMaleorFemale;
    NSMutableArray *arrayMaleorFemale;
    MBProgressHUD * HUD;
    NSString *strUserToken;
    NSMutableArray *arrayProfileData,*arrayProfileList;
    UIImage *img1;
    NSData *imageData;
    CLLocationManager *locationManager;
    NSString *strLatitude,*strLongitude;
}
@property (nonatomic, retain) CLLocationManager *locationManager;
@end

@implementation EditProfileVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    strUserToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"userToken"];
    PickerviewMaleorFemale=[[UIPickerView alloc]init];
    PickerviewMaleorFemale.dataSource = self;
    PickerviewMaleorFemale.delegate = self;
    PickerviewMaleorFemale.showsSelectionIndicator = YES;
    [_txtGender setInputView:PickerviewMaleorFemale];
    
    arrayMaleorFemale = [[NSMutableArray alloc]initWithObjects:@"Male",@"Female",nil];
    
    _imgProfile.layer.cornerRadius=_imgProfile.frame.size.height/2;
    _imgProfile.clipsToBounds = YES;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    // Configure the new event with information from the location
    CLLocationCoordinate2D coordinate = [location coordinate];
    strLatitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    strLongitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
}

-(void)viewWillAppear:(BOOL)animated
{
    arrayProfileData=[[NSMutableArray alloc]init];
    arrayProfileList=[[NSMutableArray alloc]init];
    [self getProfileData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClickedBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (IBAction)btnClickedUpdate:(id)sender
{
    if ([_txtFirstName.text isEqualToString:@""] && [_txtLastName.text isEqualToString:@""]  && [_txtGender.text isEqualToString:@""])
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"RYFLCT" message:@"Please Enter All Informations" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        
        // [APP_DELEGATE AlertMessage:@"Please Enter All Informations"];
        return;
    }
    if ([_txtFirstName.text isEqualToString:@""])
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"RYFLCT" message:@"Please Enter First Name" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        //[APP_DELEGATE AlertMessage:@"Please Enter First Name"];
        return;
    }
    if ([_txtLastName.text isEqualToString:@""])
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"RYFLCT" message:@"Please Enter Last Name" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        //[APP_DELEGATE AlertMessage:@"Please Enter Last Name"];
        return;
    }
    if ([_txtGender.text isEqualToString:@""])
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"RYFLCT" message:@"Please Enter Gender" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        //[APP_DELEGATE AlertMessage:@"Please Enter Gender"];
        return;
    }
    else
    {
        NSData *imageData1 = UIImagePNGRepresentation(_imgProfile.image);
        if(imageData1 == nil || imageData1 == NULL || [imageData1 isKindOfClass:[NSNull class]])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"RYFLCT" message:@"Please Enter Profile Image" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            [self showMBProgressWithShow:YES];
            NSDictionary *innerDict = @{
                                        @"first_name":_txtFirstName.text,
                                        @"last_name":_txtLastName.text,
                                        @"latitude":strLatitude,
                                        @"longitude":strLongitude,
                                        @"gender":_txtGender.text,
                                        @"dob":@""
                                        };
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            
            NSString *strUrl=[NSString stringWithFormat:@"%@edituser?token=%@",API_SERVER_URL,strUserToken];
            
            [manager POST:strUrl parameters:innerDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
             {
                 int randomID = arc4random() % 2000 + 1000;
                 NSString * imageName = [NSString stringWithFormat:@"%d.jpeg",randomID];
                 [formData appendPartWithFileData:imageData1 name:@"profile_image" fileName:imageName mimeType:@"image/jpeg"];
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
                 [self showMBProgressWithShow:NO];
                 NSLog(@"Error: %@", error);
                 //  [APP_DELEGATE AlertMessage:@"Internal server error"];
             }];
        }
    }
    
    //[self dismissViewControllerAnimated:YES completion:Nil];
}

- (IBAction)btnClickedEditProfile:(id)sender
{
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"RYFLCT"
                                                                       message:@"If you want to use your camera or choose one from your phones photo gallery"
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  
                                                                  UIImagePickerController *imgpickr1=[[UIImagePickerController alloc]init];
                                                                  
                                                                  imgpickr1.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                                                                  
                                                                  imgpickr1.delegate =(id)self;
                                                                  
                                                                  imgpickr1.allowsEditing=YES;
                                                                  
                                                                  //SrtFlag=@"123";
                                                                  [self presentViewController:imgpickr1 animated:YES completion:nil];
                                                                  
                                                                  return ;
                                                              }];
        UIAlertAction* defaultAction1 = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
                                                                   
                                                                   if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                                                                   {
                                                                       UIImagePickerController *imgpickr1=[[UIImagePickerController alloc]init];
                                                                       
                                                                       imgpickr1.sourceType=UIImagePickerControllerSourceTypeCamera;
                                                                       
                                                                       imgpickr1.delegate =(id)self;
                                                                       
                                                                       imgpickr1.allowsEditing=YES;
                                                                       //SrtFlag=@"1234";
                                                                       [self presentViewController:imgpickr1 animated:YES completion:nil];
                                                                       
                                                                   }
                                                                   else
                                                                   {
                                                                       UIAlertController* alert2 = [UIAlertController alertControllerWithTitle:@"RYFLCT"
                                                                                                                                       message:@"Camera not available"
                                                                                                                                preferredStyle:UIAlertControllerStyleAlert];
                                                                       
                                                                       UIAlertAction* defaultAction2 = [UIAlertAction actionWithTitle:@"Dissmiss" style:UIAlertActionStyleDestructive
                                                                                                                              handler:^(UIAlertAction * action) {
                                                                                                                                  
                                                                                                                                  return ;
                                                                                                                              }];
                                                                       [alert2 addAction:defaultAction2];
                                                                       [self presentViewController:alert2 animated:YES completion:nil];
                                                                   }
                                                               }];
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive
                                                       handler:^(UIAlertAction * action) {
                                                           return ;
                                                       }];
        
        [alert addAction:defaultAction];
        [alert addAction:defaultAction1];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma Mark ImagePickerController::

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    img1=[info valueForKey:UIImagePickerControllerEditedImage];
    
    _imgProfile.image = img1;
    
    //    _imgProfile.layer.cornerRadius=_imgProfile.frame.size.height/2;
    //    _imgProfile.layer.borderWidth=1;
    //    _imgProfile.layer.borderColor=[[UIColor blackColor]CGColor];
    
    _imgProfile.clipsToBounds = YES;
    imageData =UIImageJPEGRepresentation(img1, 50.0);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Picker View Data Source

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [arrayMaleorFemale count];
}

#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [_txtGender setText:[arrayMaleorFemale objectAtIndex:row]];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    [_txtGender setText:[arrayMaleorFemale objectAtIndex:0]];
    return [arrayMaleorFemale objectAtIndex:row];
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

#pragma mark Custom Methods ::

-(void)getProfileData
{
    [self showMBProgressWithShow:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *strUrl=[NSString stringWithFormat:@"%@edituser?token=%@",API_SERVER_URL,strUserToken];
    
    [manager GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         Boolean Status=[[responseObject valueForKey:@"success"]boolValue];
         if(Status==1)
         {
             [arrayProfileData addObject:[responseObject objectForKey:@"data"]];
             [arrayProfileList addObjectsFromArray:arrayProfileData];
             
             NSString *strFLname=[NSString stringWithFormat:@"%@ %@",[[[arrayProfileList valueForKey:@"UserDetail"]valueForKey:@"first_name"]objectAtIndex:0],[[[arrayProfileList valueForKey:@"UserDetail"]valueForKey:@"last_name"]objectAtIndex:0]];
             
             _txtFirstName.text=[NSString stringWithFormat:@"%@",[[[arrayProfileList valueForKey:@"UserDetail"]valueForKey:@"first_name"]objectAtIndex:0]];
             _txtLastName.text=[NSString stringWithFormat:@"%@",[[[arrayProfileList valueForKey:@"UserDetail"]valueForKey:@"last_name"]objectAtIndex:0]];
             //_txtEmail.text=[NSString stringWithFormat:@"%@",[[[arrayProfileList valueForKey:@"UserDetail"]valueForKey:@"last_name"]objectAtIndex:0]];
             _txtGender.text=[NSString stringWithFormat:@"%@",[[[arrayProfileList valueForKey:@"UserDetail"]valueForKey:@"gender"]objectAtIndex:0]];
             
             [self showMBProgressWithShow:NO];
         }
         else
         {
             UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"RYFLCT" message:[responseObject valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
             [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
             [self presentViewController:alertController animated:YES completion:nil];
             [APP_DELEGATE showMBProgressWithShow:NO];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [APP_DELEGATE showMBProgressWithShow:NO];
         NSLog(@"Error: %@", error);
         //[APP_DELEGATE AlertMessage:@"Internal server error"];
     }];
}


@end
