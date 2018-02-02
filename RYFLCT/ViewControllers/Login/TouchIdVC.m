
//
//  TouchIdVC.m
//  RYFLCT
//
//  Created by admin on 24/01/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import "TouchIdVC.h"
#import "EHFAuthenticator.h"
#import "HomeVC.h"
#import "Header.h"

@interface TouchIdVC ()
{
     AppDelegate *app;
}

@end

@implementation TouchIdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSError * error = nil;
    
    [[EHFAuthenticator sharedInstance] setReason:@"Authenticate to Login"];
    [[EHFAuthenticator sharedInstance] setFallbackButtonTitle:@"Enter Password"];
    [[EHFAuthenticator sharedInstance] setUseDefaultFallbackTitle:YES];
    
    /*if (![EHFAuthenticator canAuthenticateWithError:&error]) {
        [self.btnObjTouchId setEnabled:NO];
        NSString * authErrorString = @"Check your Touch ID Settings.";
        
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
                authErrorString = @"No Touch ID fingers enrolled.";
                break;
            case LAErrorTouchIDNotAvailable:
                authErrorString = @"Touch ID not available on your device.";
                break;
            case LAErrorPasscodeNotSet:
                authErrorString = @"Need a passcode set to use Touch ID.";
                break;
            default:
                authErrorString = @"Check your Touch ID Settings.";
                break;
        }
        //[self.btnObjTouchId setTitle:authErrorString forState:UIControlStateDisabled];
        [self presentAlertControllerWithMessage:authErrorString];
    }*/
    
    [[EHFAuthenticator sharedInstance] authenticateWithSuccess:^()
    {
        HomeVC *HomeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
        //HomeVC = UIModalTransitionStyleCoverVertical;
        [self presentViewController:HomeVC animated:YES completion:nil];
        [APP_DELEGATE AlertMessage:@"Successfully Authenticated!"];
    } andFailure:^(LAError errorCode){
        NSString * authErrorString;
        switch (errorCode) {
            case LAErrorSystemCancel:
                authErrorString = @"System canceled auth request due to app coming to foreground or background.";
                break;
            case LAErrorAuthenticationFailed:
                authErrorString = @"User failed after a few attempts.";
                break;
            case LAErrorUserCancel:
                authErrorString = @"User cancelled.";
                break;
                
            case LAErrorUserFallback:
                authErrorString = @"Fallback auth method should be implemented here.";
                break;
            case LAErrorTouchIDNotEnrolled:
                authErrorString = @"No Touch ID fingers enrolled.";
                break;
            case LAErrorTouchIDNotAvailable:
                authErrorString = @"Touch ID not available on your device.";
                break;
            case LAErrorPasscodeNotSet:
                authErrorString = @"Need a passcode set to use Touch ID.";
                break;
            default:
                authErrorString = @"Check your Touch ID Settings.";
                break;
        }
        HomeVC *HomeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
        //HomeVC = UIModalTransitionStyleCoverVertical;
        [self presentViewController:HomeVC animated:YES completion:nil];
        //[APP_DELEGATE AlertMessage:@"Successfully Authenticated!"];
        [self presentAlertControllerWithMessage:authErrorString];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnClickedTouchId:(id)sender
{
    [[EHFAuthenticator sharedInstance] authenticateWithSuccess:^()
    {
        HomeVC *HomeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
        //HomeVC = UIModalTransitionStyleCoverVertical;
        [self presentViewController:HomeVC animated:YES completion:nil];
        [APP_DELEGATE AlertMessage:@"Successfully Authenticated!"];
        //[self presentAlertControllerWithMessage:@"Successfully Authenticated!"];
    } andFailure:^(LAError errorCode){
        NSString * authErrorString;
        switch (errorCode) {
            case LAErrorSystemCancel:
                authErrorString = @"System canceled auth request due to app coming to foreground or background.";
                break;
            case LAErrorAuthenticationFailed:
                authErrorString = @"User failed after a few attempts.";
                break;
            case LAErrorUserCancel:
                authErrorString = @"User cancelled.";
                break;
            case LAErrorUserFallback:
                authErrorString = @"Fallback auth method should be implemented here.";
                break;
            case LAErrorTouchIDNotEnrolled:
                authErrorString = @"No Touch ID fingers enrolled.";
                break;
            case LAErrorTouchIDNotAvailable:
                authErrorString = @"Touch ID not available on your device.";
                break;
            case LAErrorPasscodeNotSet:
                authErrorString = @"Need a passcode set to use Touch ID.";
                break;
            default:
                authErrorString = @"Check your Touch ID Settings.";
                break;
        }
        //HomeVC *HomeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
        //HomeVC = UIModalTransitionStyleCoverVertical;
        //[self presentViewController:HomeVC animated:YES completion:nil];
        [self presentAlertControllerWithMessage:authErrorString];
    }];
}


-(void) presentAlertControllerWithMessage:(NSString *) message{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Touch ID for RYFLCT" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)btnClickedBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}
@end
