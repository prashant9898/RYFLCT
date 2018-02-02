
//
//  SettingsVC.m
//  RYFLCT
//
//  Created by Tops on 1/13/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import "SettingsVC.h"
#import "EditProfileVC.h"
#import "GetStartedVC.h"

@interface SettingsVC ()

@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)btnClickedDone:(id)sender
{
     [self dismissViewControllerAnimated:YES completion:Nil];
}

- (IBAction)btnClickedEditProfile:(id)sender
{
    EditProfileVC *EditProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileVC"];
    [self presentViewController:EditProfileVC animated:YES completion:nil];
}

- (IBAction)btnClickedPushNotifications:(id)sender
{
    
}

- (IBAction)btnClickedShareApp:(id)sender {
}

- (IBAction)btnClickedSignOut:(id)sender
{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"RYFLCT"
                                                                  message:@"Are you sure you want to logout?"
                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                {
                                    //[self LogoutUser];
                                    [[NSUserDefaults standardUserDefaults]setObject:@"Logout" forKey:@"LocalLogin"];
                                    GetStartedVC *GetStartedVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GetStartedVC"];
                                   // LoginVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                                    [self presentViewController:GetStartedVC animated:YES completion:nil];
                                }];
    
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"No"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action)
                               {
                                   
                               }];
    [alert addAction:yesButton];
    [alert addAction:noButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)btnClickedAbout:(id)sender {
}

- (IBAction)btnClickedFeedback:(id)sender
{
    
}

- (IBAction)btnClickedTerms:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.google.com"]];
}
- (IBAction)btnClickedPrivacy:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.google.com"]];
}
@end
