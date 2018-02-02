
//
//  GetStartedVC.m
//  RYFLCT
//
//  Created by Tops on 1/10/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import "GetStartedVC.h"
#import "LoginVC.h"
#import "RegisterVC.h"

@interface GetStartedVC ()

@end

@implementation GetStartedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClickedJoin:(id)sender
{
    RegisterVC *RegisterVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterVC"];
    RegisterVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:RegisterVC animated:YES completion:nil];
}

- (IBAction)btnClickedLogin:(id)sender
{
    LoginVC *LoginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    LoginVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:LoginVC animated:YES completion:nil];
}
@end
