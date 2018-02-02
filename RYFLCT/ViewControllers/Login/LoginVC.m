//
//  LoginVC.m
//  RYFLCT
//
//  Created by Tops on 1/10/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import "LoginVC.h"
#import "Header.h"
#import "HomeVC.h"
#import "ProfileVC.h"
#import "TouchIdVC.h"

@interface LoginVC ()
{
    AppDelegate *app;
    NSUserDefaults *prefs;
    BOOL canAction;
    MBProgressHUD * HUD;
}

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClickedBack:(id)sender
{
     [self dismissViewControllerAnimated:YES completion:Nil];
}
- (IBAction)btnClickedSignIn:(id)sender
{
    if (_txtEmail.text.length == 0 && [_txtPassword.text length]== 0)
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"RYFLCT" message:@"Please Enter All Details" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        
        //[APP_DELEGATE AlertMessage:@"Please Enter All Details"];
        return;
    }
    if ([_txtEmail.text isEqualToString:@""]) {
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
        return;
        //[APP_DELEGATE AlertMessage:@"Please Enter Valid Email"];
    }
    else if ([_txtPassword.text length]==0)
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"RYFLCT" message:@"Please Enter Password" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
        //[APP_DELEGATE AlertMessage:@"Please Enter Password"];
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
        //Header Link:  http://13.126.103.158/ryflct/api/1.1/login
        
        NSDictionary *innerDict = @{
                                    @"username":_txtEmail.text,
                                    @"password":_txtPassword.text
                                    };
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        NSString *strUrl=[NSString stringWithFormat:@"%@login",API_SERVER_URL];
        
        [manager POST:strUrl parameters:innerDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
         {
             
         }success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"JSON: %@", responseObject);
             Boolean Status=[[responseObject valueForKey:@"success"]boolValue];
             if(Status==1)
             {
                 app = [[AppDelegate alloc]init];
                 [app setUserDefaults:[NSNumber numberWithBool:YES] andKey:DFL_IS_LOGGED];
                 [app setUserDefaults:LOGIN_LCL andKey:LOGIN_TYPE];
                 
                 [[NSUserDefaults standardUserDefaults]setObject:@"Local" forKey:@"LocalLogin"];
                 
                 [[NSUserDefaults standardUserDefaults]setObject:_txtEmail.text forKey:@"Login_Username"];
                 [[NSUserDefaults standardUserDefaults]setObject:_txtPassword.text forKey:@"Login_Password"];
                 
                 prefs = [NSUserDefaults standardUserDefaults];
                 NSDictionary *json1 = [responseObject objectForKey:@"data"] ;
                 
                 NSString *userToken =[json1 valueForKey:@"userToken"];
                 [[NSUserDefaults standardUserDefaults]setObject:userToken forKey:@"userToken"];
                                
                 TouchIdVC *TouchIdVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TouchIdVC"];
                 //TouchIdVC = UIModalTransitionStyleCoverVertical;
                 [self presentViewController:TouchIdVC animated:YES completion:nil];
                 //[APP_DELEGATE AlertMessage:[responseObject objectForKey:@"message"]];
                 
                 if(canAction!=YES)
                 {
                     
                 }
                 else
                 {
                     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBacktoRelogin:) name:nil object:nil];
                     canAction = YES;
                 }
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
             //[APP_DELEGATE AlertMessage:@"Internal server error"];
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
