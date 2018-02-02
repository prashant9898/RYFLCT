//
//  PageViewController.m
//  RYFLCT
//
//  Created by Tops on 1/10/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import "PageViewController.h"
#import "GetStartedVC.h"

@interface PageViewController ()

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _contentImageView.image = [UIImage imageNamed:_imageName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Content

- (void)setImageName:(NSString *)name
{
    _imageName = name;
    _contentImageView.image = [UIImage imageNamed:_imageName];
}

- (IBAction)btnClickedGetStarted:(id)sender
{
    GetStartedVC *GetStartedVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GetStartedVC"];
    [self.navigationController pushViewController:GetStartedVC animated:YES];
}
@end
