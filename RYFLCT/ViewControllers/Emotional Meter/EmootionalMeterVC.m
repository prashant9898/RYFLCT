//
//  EmootionalMeterVC.m
//  RYFLCT
//
//  Created by Tops on 1/13/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import "EmootionalMeterVC.h"
#import "EmotionalMeter_Cell.h"
#import "ScoreEmotionalVC.h"
#import "SettingsVC.h"
#import <QuartzCore/QuartzCore.h>
#import "PCPieChart.h"
#import "MBProgressHUD.h"
#import "Header.h"

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface EmootionalMeterVC ()
{
    MBProgressHUD * HUD;
    NSString *strUserToken;
    NSMutableArray *arrayProfileData,*arrayProfileList;
    NSMutableArray *arrayKeywordData,*arrayKeywordList;
}

@end

@implementation EmootionalMeterVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    strUserToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"userToken"];

    _KeywordView.layer.cornerRadius=20;
    _KeywordView.layer.masksToBounds=YES;
    
    _ScoreView.layer.cornerRadius=20;
    _ScoreView.layer.masksToBounds=YES;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            _scrEmotionalMeter.contentSize = CGSizeMake(_scrEmotionalMeter. frame.size.width,850);
        }
        else if(result.height == 568)
        {
            // iPhone 5
            _scrEmotionalMeter.contentSize = CGSizeMake(_scrEmotionalMeter. frame.size.width,850);
        }
        else if(result.height == 667)
        {
            // iPhone 6
            _scrEmotionalMeter.contentSize = CGSizeMake(_scrEmotionalMeter. frame.size.width,1410);
        }
        else if(result.height == 736)
        {
            _scrEmotionalMeter.contentSize = CGSizeMake(_scrEmotionalMeter. frame.size.width,1515);
        }
    }
    else
    {
        _scrEmotionalMeter.contentSize = CGSizeMake(_scrEmotionalMeter. frame.size.width,850);
    }
    
    /*self.slices = [NSMutableArray arrayWithCapacity:10];
    
    for(int i = 0; i < 5; i ++)
    {
        NSNumber *one = [NSNumber numberWithInt:rand()%60+20];
        [_slices addObject:one];
    }
    
    [self.PiechartEmotional setDataSource:self];
    [self.PiechartEmotional setStartPieAngle:M_PI_2];
    [self.PiechartEmotional setAnimationSpeed:1.0];
    [self.PiechartEmotional setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:12]];
    //[self.PiechartEmotional setLabelRadius:160];
    [self.PiechartEmotional setShowPercentage:YES];
    [self.PiechartEmotional setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    //[self.PiechartEmotional setPieCenter:CGPointMake(240, 240)];
    [self.PiechartEmotional setUserInteractionEnabled:YES];
    [self.PiechartEmotional setLabelShadowColor:[UIColor blackColor]];
    
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithRed:215.0/255.0 green:46.0/255.0 blue:75.0/255.0 alpha:1.0],
                       [UIColor colorWithRed:252.0/255.0 green:184.0/255.0 blue:29.0/255.0 alpha:1.0],
                       [UIColor colorWithRed:244.0/255.0 green:62.0/255.0 blue:39.0/255.0 alpha:1.0],
                       [UIColor colorWithRed:183.0/255.0 green:10.0/255.0 blue:44.0/255.0 alpha:1.0],
                       [UIColor colorWithRed:67.0/255.0 green:14.0/255.0 blue:52.0/255.0 alpha:1.0],nil];
    
    [self.PiechartEmotional reloadData];*/
    
    int height = 150; // 220;
    int width = 300; //320;
    PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(30,575,width,height)];
    [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [pieChart setDiameter:width/2];
    [pieChart setSameColorLabel:YES];
    
    [self.scrEmotionalMeter addSubview:pieChart];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        pieChart.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
        pieChart.percentageFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
    }
    
    NSMutableArray *components = [NSMutableArray array];
    
    for (int i=0; i<5; i++)
    {
        //NSDictionary *item = [[sampleInfo objectForKey:@"data"] objectAtIndex:i];
        PCPieComponent *component = [PCPieComponent pieComponentWithTitle:@"01-20" value:20];
        [components addObject:component];
        
        if (i==0)
        {
            [component setColour:PCColorYellow];
        }
        else if (i==1)
        {
            [component setColour:PCColorGreen];
        }
        else if (i==2)
        {
            [component setColour:PCColorOrange];
        }
        else if (i==3)
        {
            [component setColour:PCColorRed];
        }
        else if (i==4)
        {
            [component setColour:PCColorBlue];
        }
    }
    [pieChart setComponents:components];
    
    //rotate up arrow
    
}

-(void)viewWillAppear:(BOOL)animated
{
    arrayProfileData=[[NSMutableArray alloc]init];
    arrayProfileList=[[NSMutableArray alloc]init];
    arrayKeywordData=[[NSMutableArray alloc]init];
    arrayKeywordList=[[NSMutableArray alloc]init];
    [self getProfileData];
    [self getProfileKeywordData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClickedSetting:(id)sender
{
    SettingsVC *SettingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsVC"];
    SettingsVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:SettingsVC animated:YES completion:nil];
}

#pragma Mark UITableview Datasource and Delegate Methods::

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==_tblKeywords)
    {
        return arrayKeywordData.count;
    }
    else
    {
        return 5;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_tblKeywords)
    {
        static NSString *MyIdentifier = @"EmotionalMeter_Cell";
        
        EmotionalMeter_Cell *cellEmotionalMeter = (EmotionalMeter_Cell *)[_tblKeywords dequeueReusableCellWithIdentifier:MyIdentifier];
    cellEmotionalMeter.lblStoriesCount.layer.cornerRadius=cellEmotionalMeter.lblStoriesCount.bounds.size.width/2;
        cellEmotionalMeter.lblStoriesCount.layer.masksToBounds=YES;
        
        cellEmotionalMeter.lblKeywordName.text=[[arrayKeywordData valueForKey:@"keyword"]objectAtIndex:indexPath.row];
        cellEmotionalMeter.lblStoriesCount.text=[NSString stringWithFormat:@"%@",[[arrayKeywordData valueForKey:@"count"]objectAtIndex:indexPath.row]];
        
        return cellEmotionalMeter;
    }
    else
    {
        static NSString *MyIdentifier = @"EmotionalMeter_Cell";
        
        EmotionalMeter_Cell *cellEmotionalMeter = (EmotionalMeter_Cell *)[_tblScore dequeueReusableCellWithIdentifier:MyIdentifier];
    cellEmotionalMeter.lblScoreStoriesCount.layer.cornerRadius=cellEmotionalMeter.lblScoreStoriesCount.bounds.size.width/2;
        cellEmotionalMeter.lblScoreStoriesCount.layer.masksToBounds=YES;
        
        return cellEmotionalMeter;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_tblKeywords)
    {
        
    }
    else
    {
        ScoreEmotionalVC *ScoreEmotionalVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ScoreEmotionalVC"];
        ScoreEmotionalVC.modalTransitionStyle = UIModalTransitionStylePartialCurl;
        [self presentViewController:ScoreEmotionalVC animated:YES completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_tblKeywords)
    {
        return 42;
    }
    else
    {
        return 42;
    }
}

- (IBAction)btnClickedBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    if(pieChart == self.PiechartEmotional) return nil;
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will select slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will deselect slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did deselect slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %d",index);
    //self.selectedSliceLabel.text = [NSString stringWithFormat:@"$%@",[self.slices objectAtIndex:index]];
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
             
             _lblName.text=strFLname;
             
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

-(void)getProfileKeywordData
{
    [self showMBProgressWithShow:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *strUrl=[NSString stringWithFormat:@"%@keyword_count?token=%@",API_SERVER_URL,strUserToken];
    
    [manager GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         Boolean Status=[[responseObject valueForKey:@"success"]boolValue];
         if(Status==1)
         {
             [arrayKeywordData addObjectsFromArray:[responseObject objectForKey:@"data"]];
             [arrayKeywordList addObjectsFromArray:arrayKeywordData];
             [_tblKeywords reloadData];
             [self showMBProgressWithShow:NO];
         }
         else
         {
             [_tblKeywords reloadData];
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
