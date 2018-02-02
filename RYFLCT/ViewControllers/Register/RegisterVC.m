//
//  RegisterVC.m
//  RYFLCT
//
//  Created by Tops on 1/10/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import "RegisterVC.h"
#import "Header.h"
#import "HomeVC.h"
#import "TouchIdVC.h"
#import <coreLocation/CoreLocation.h>

@interface RegisterVC ()<UIPickerViewDelegate,UIPickerViewDataSource,CLLocationManagerDelegate>
{
    UIPickerView *PickerviewMaleorFemale;
    NSMutableArray *arrayMaleorFemale;
    
    AppDelegate *app;
    NSUserDefaults *prefs;
    BOOL canAction;
    MBProgressHUD * HUD;
    CLLocationManager *locationManager;
    NSString *strLatitude,*strLongitude;
}
@property (nonatomic, retain) CLLocationManager *locationManager;
@end

@implementation RegisterVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PickerviewMaleorFemale=[[UIPickerView alloc]init];
    PickerviewMaleorFemale.dataSource = self;
    PickerviewMaleorFemale.delegate = self;
    PickerviewMaleorFemale.showsSelectionIndicator = YES;
    [_txtGender setInputView:PickerviewMaleorFemale];
    
    arrayMaleorFemale = [[NSMutableArray alloc]initWithObjects:@"Male",@"Female",nil];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClickedBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:Nil];
     //[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnClickedSignUp:(id)sender
{
//    HomeVC *HomeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
//    HomeVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    [self presentViewController:HomeVC animated:YES completion:nil];
    
    if ([_txtFirstName.text isEqualToString:@""] && [_txtLastName.text isEqualToString:@""] && [_txtEmail.text isEqualToString:@""] && [_txtPassword.text isEqualToString:@""] && [_txtConfirmPassword.text isEqualToString:@""] && [_txtGender.text isEqualToString:@""])
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
    if ([_txtEmail.text isEqualToString:@""])
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"RYFLCT" message:@"Please Enter Email" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        //[APP_DELEGATE AlertMessage:@"Please Enter Email"];
        return;
    }
    BOOL isValid = NO;
    isValid = [Validate isValidEmailAddress:_txtEmail.text];
    if (isValid==NO)
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"RYFLCT" message:@"Please Enter Valid Email" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        //[APP_DELEGATE AlertMessage:@"Please Enter Valid Email"];
        return;
    }
    if ([_txtPassword.text length]==0)
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"RYFLCT" message:@"Please Enter Password" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
       // [APP_DELEGATE AlertMessage:@"Please Enter Password"];
        return;
    }
    else if (_txtPassword.text.length <=5)
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"RYFLCT" message:@"Password must be minimum 6 Characters long" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
       // [APP_DELEGATE AlertMessage:[NSString stringWithFormat:@"Password must be minimum 6 Characters long"]];
        return;
    }
    else if ([_txtConfirmPassword.text length]==0)
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"RYFLCT" message:@"Please Enter Confirm Password" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        //[APP_DELEGATE AlertMessage:@"Please Enter Confirm Password"];
        return;
    }
    else if (![_txtPassword.text isEqualToString:_txtConfirmPassword.text])
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"RYFLCT" message:@"Password Does not match" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
       // [APP_DELEGATE AlertMessage:[NSString stringWithFormat:@"Password Does not match"]];
        return;
    }
    else if ([_txtGender.text isEqualToString:@""])
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"RYFLCT" message:@"Please Enter Gender" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        //[APP_DELEGATE AlertMessage:@"Please Enter Gender"];
        return;
    }
    else
    {
        [self showMBProgressWithShow:YES];
        
        NSUserDefaults *prefsGCMID = [NSUserDefaults standardUserDefaults];
        NSString *setid=[prefsGCMID stringForKey:@"MyAppSpecificGloballyUniqueString"];
        
        if(setid == nil || setid == NULL || [setid isEqualToString:@""] || [setid isKindOfClass:[NSNull class]])
        {
            setid = @"MyAppSpecificGloballyUniqueString";
        }
        
        NSDictionary *innerDict = @{
                                    @"username":_txtEmail.text,
                                    @"password":_txtPassword.text,
                                    @"deviceid":setid,
                                    @"first_name":_txtFirstName.text,
                                    @"last_name":_txtLastName.text,
                                    @"latitude":strLatitude,
                                    @"longitude":strLongitude
                                    };
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        NSString *strUrl=[NSString stringWithFormat:@"%@signup",API_SERVER_URL];
        
        [manager POST:strUrl parameters:innerDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
         {
         } success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"JSON: %@", responseObject);
             Boolean Status=[[responseObject valueForKey:@"success"]boolValue];
             if(Status==1)
             {
                 //app = [[AppDelegate alloc]init];
                 //[app setUserDefaults:[NSNumber numberWithBool:YES] andKey:DFL_IS_LOGGED];
                 //[app setUserDefaults:LOGIN_LCL andKey:LOGIN_TYPE];
                 
                 //[[NSUserDefaults standardUserDefaults]setObject:@"Local" forKey:@"LocalLogin"];
                 
                 //[[NSUserDefaults standardUserDefaults]setObject:_txtEmail.text forKey:@"Login_Username"];
                 //[[NSUserDefaults standardUserDefaults]setObject:_txtPassword.text forKey:@"Login_Password"];
                 
                // prefs = [NSUserDefaults standardUserDefaults];
                 NSDictionary *json1 = [responseObject objectForKey:@"data"] ;
                 
                 NSString *userToken =[json1 valueForKey:@"userToken"];
                 [[NSUserDefaults standardUserDefaults]setObject:userToken forKey:@"userToken"];
                 
                 [self dismissViewControllerAnimated:YES completion:Nil];
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"RYFLCT" message:[responseObject valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alert show];
                 //[APP_DELEGATE AlertMessage:[responseObject valueForKey:@"message"]];
                 
                 /*if(canAction!=YES)
                 {
                     
                 }
                 else
                 {
                     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBacktoRelogin:) name:nil object:nil];
                     canAction = YES;
                 }*/
                 
                 [self showMBProgressWithShow:NO];
             }
             else
             {
                 [self showMBProgressWithShow:NO];
                 UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"RYFLCT" message:[responseObject valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                 [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
                 [self presentViewController:alertController animated:YES completion:nil];
                 //[APP_DELEGATE AlertMessage:[responseObject valueForKey:@"message"]];
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [self showMBProgressWithShow:NO];
             NSLog(@"Error: %@", error);
             // [APP_DELEGATE AlertMessage:@"Internal server error"];
         }];
    }
}

#pragma mark Custom method ::
    
-(void)goBacktoRelogin:(NSNotification *)notif
{
    if(canAction == YES)
    {
        canAction = NO;
        [APP_DELEGATE setViewControllerAccordingToStatus];
    }
}
    
- (IBAction)btnClickedTermsAndCondition:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.google.com"]];
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

@end
