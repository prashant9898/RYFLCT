
//
//  ScoreEmotionalVC.m
//  RYFLCT
//
//  Created by Tops on 1/13/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import "ScoreEmotionalVC.h"
#import "HomeCell.h"
#import "PostDetailVC.h"

@interface ScoreEmotionalVC ()

@end

@implementation ScoreEmotionalVC

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

#pragma Mark UITableview Datasource and Delegate Methods::

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"HomeCell";
    
    HomeCell *cellHome = (HomeCell *)[_tblScoreEmotional dequeueReusableCellWithIdentifier:MyIdentifier];
    
    /*cellHome.contentView.layer.cornerRadius = 12.0;
     
     cellHome.contentView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
     cellHome.contentView.layer.shadowOffset = CGSizeMake(2, 2);
     cellHome.contentView.layer.shadowOpacity = 15;
     cellHome.contentView.layer.shadowRadius = 5.0;
     cellHome.contentView.clipsToBounds = NO;*/
    
    cellHome.viewScoreEmotional.layer.cornerRadius = 20.0;
    cellHome.viewScoreEmotional.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    cellHome.viewScoreEmotional.layer.shadowOffset = CGSizeMake(2, 2);
    cellHome.viewScoreEmotional.layer.shadowOpacity = 15;
    cellHome.viewScoreEmotional.layer.shadowRadius = 5.0;
    cellHome.viewScoreEmotional.clipsToBounds = NO;
    cellHome.viewScoreEmotional.layer.masksToBounds = YES;
    
    cellHome.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cellHome;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostDetailVC *PostDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PostDetailVC"];
    PostDetailVC.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self presentViewController:PostDetailVC animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  400;
}
@end
