
//
//  SearchVC.m
//  RYFLCT
//
//  Created by admin on 03/02/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import "SearchVC.h"
#import "HomeCell.h"
#import "HomeCell_2.h"
#import "HomeCell_3.h"
#import "PostDetailVC.h"
#import "EmootionalMeterVC.h"
#import "PostTextVC.h"
#import "PostCameraVC.h"
#import "PostSmilyVC.h"
#import "PostRecordVC.h"
#import "MBProgressHUD.h"
#import "Header.h"
#import "HomeRecord_Cell.h"

@interface SearchVC ()
{
    NSMutableArray *arrayDayTime,*arrayToday;
    NSMutableArray *arrayHomedataList;
    WSCalendarView *calendarView;
    WSCalendarView *calendarViewEvent;
    NSMutableArray *eventArray;
    
    NSMutableArray *arrayStoryData,*arrayStoryList;
    MBProgressHUD * HUD;
    NSString *strUserToken;
    int page;
    BOOL isPageRefreshing;
}

@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    strUserToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"userToken"];
    calendarView = [[[NSBundle mainBundle] loadNibNamed:@"WSCalendarView" owner:self options:nil] firstObject];
    //calendarView.dayColor=[UIColor blackColor];
    //calendarView.weekDayNameColor=[UIColor purpleColor];
    //calendarView.barDateColor=[UIColor purpleColor];
    //calendarView.todayBackgroundColor=[UIColor blackColor];
    calendarView.tappedDayBackgroundColor=[UIColor colorWithRed:217.0 / 255.0 green:47.0 / 255.0 blue:78.0 / 255.0 alpha:1.0];
    calendarView.calendarStyle = WSCalendarStyleDialog;
    calendarView.isShowEvent=false;
    [calendarView setupAppearance];
    [self.view addSubview:calendarView];
    calendarView.delegate=self;
    
    eventArray=[[NSMutableArray alloc] init];
    NSDate *lastDate;
    NSDateComponents *dateComponent=[[NSDateComponents alloc] init];
    for (int i=0; i<10; i++) {
        
        if (!lastDate) {
            lastDate=[NSDate date];
        }
        else{
            [dateComponent setDay:1];
        }
        NSDate *datein = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponent toDate:lastDate options:0];
        lastDate=datein;
        [eventArray addObject:datein];
    }
    [calendarViewEvent reloadCalendar];
    
    NSLog(@"%@",[eventArray description]);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    page=1;
    isPageRefreshing=NO;
    arrayStoryData=[[NSMutableArray alloc]init];
    arrayStoryList=[[NSMutableArray alloc]init];
    [self getStoryList];
}

#pragma mark UITableview Datasource and Delegate Methods::

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayStoryData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger Data =[[[arrayStoryData valueForKey:@"StoryFile"]objectAtIndex:indexPath.row] count];
    
    NSString *strDate=[NSString stringWithFormat:@"%@",[[[arrayStoryData valueForKey:@"Story"] valueForKey:@"modified"] objectAtIndex:indexPath.row]];
    
    //NSString *myString = @"2012-11-22 10:19:04";
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *yourDate = [dateFormatter dateFromString:strDate];
    dateFormatter.dateFormat = @"EEEE dd MMMM";
    NSLog(@"%@",[dateFormatter stringFromDate:yourDate]);
    
    NSString *strFinalDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:yourDate]];
    NSLog(@"%@",strFinalDate);
    
    _lblDayTime.text = [strFinalDate uppercaseString];
    
    
    NSString *strDateAgo=[NSString stringWithFormat:@"%@",[[[arrayStoryData valueForKey:@"Story"] valueForKey:@"modified"] objectAtIndex:indexPath.row]];
    
    //Dateformatter as per the response date
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    
    // Set the date format according to your needs
    
    NSString * TimeZoneName=[[NSTimeZone localTimeZone]name];
    [df setTimeZone:[NSTimeZone timeZoneWithName:TimeZoneName]];
    
    //[df setDateFormat:@"MM/dd/YYYY HH:mm "]  // for 24 hour format
    [df setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // 12 hour format
    
    //converting the date to required format.
    NSDate *date1 = [df dateFromString:strDateAgo];
    NSDate *date2 = [df dateFromString:[df stringFromDate:[NSDate date]]];
    
    //Calculating the time interval
    NSTimeInterval secondsBetween = [date2 timeIntervalSinceDate:date1];
    
    int numberOfDays = secondsBetween / 86400;
    int timeResult = ((int)secondsBetween % 86400);
    int hour = timeResult / 3600;
    int hourResult = ((int)timeResult % 3600);
    int minute = hourResult / 60;
    
    
    if(numberOfDays >= 0)
    {
        if(numberOfDays == 0)
        {
            NSString *strTodayValue=@"Today";
            _lblToday.text=[strTodayValue uppercaseString];
        }
        else if(numberOfDays == 1)
        {
            NSString *strTodayValue=[NSString stringWithFormat:@"%d %@",numberOfDays,@"Day ago"];
            _lblToday.text=[strTodayValue uppercaseString];
            
        }
        else
        {
            NSString *strTodayValue=[NSString stringWithFormat:@"%d %@",numberOfDays,@"days ago"];
            _lblToday.text=[strTodayValue uppercaseString];
        }
    }
    
    if(Data==0)
    {
        static NSString *MyIdentifier = @"HomeCell";
        HomeCell *cellHome = (HomeCell *)[_tblSearch dequeueReusableCellWithIdentifier:MyIdentifier];
        
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
        
        NSString *strTime=[NSString stringWithFormat:@"%@",[[[arrayStoryData valueForKey:@"Story"] valueForKey:@"modified"] objectAtIndex:indexPath.row]];
        
        //NSString *myString = @"2012-11-22 10:19:04";
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *yourDate1 = [dateFormatter dateFromString:strTime];
        dateFormatter.dateFormat = @"hh:mm aaa";
        NSLog(@"%@",[dateFormatter stringFromDate:yourDate1]);
        
        NSString *strFinalTime = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:yourDate1]];
        NSLog(@"%@",strFinalTime);
        
        cellHome.lblHomeTime.text = [strFinalTime uppercaseString];
        
        
        NSString *strProgressValue=[NSString stringWithFormat:@"%@",[[[arrayStoryData valueForKey:@"Story"] valueForKey:@"moodicon"] objectAtIndex:indexPath.row]];
        
        NSString *strMoods=[NSString stringWithFormat:@"%@",[[[arrayStoryData valueForKey:@"Story"] valueForKey:@"heading"] objectAtIndex:indexPath.row]];
        
        if([strMoods isEqualToString:@"Moods"])
        {
            cellHome.imgHome.contentMode=UIViewContentModeScaleAspectFit;
            cellHome.imgHome.hidden=YES;
            cellHome.imgHomeMoodsShow.hidden=NO;
            cellHome.imgHomeMoodsShow.contentMode=UIViewContentModeScaleAspectFit;
            if([strProgressValue isEqualToString:@"0"] || [strProgressValue isEqualToString:@"1"] || [strProgressValue isEqualToString:@"2"] || [strProgressValue isEqualToString:@"3"] || [strProgressValue isEqualToString:@"4"] || [strProgressValue isEqualToString:@"5"])
            {
                cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"01sad"];
            }
            else if([strProgressValue isEqualToString:@"6"] || [strProgressValue isEqualToString:@"7"] || [strProgressValue isEqualToString:@"8"] || [strProgressValue isEqualToString:@"9"] || [strProgressValue isEqualToString:@"10"])
            {
                cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"02sad"];
            }
            else if([strProgressValue isEqualToString:@"11"] || [strProgressValue isEqualToString:@"12"] || [strProgressValue isEqualToString:@"13"] || [strProgressValue isEqualToString:@"14"] || [strProgressValue isEqualToString:@"15"])
            {
                cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"03sad"];
            }
            else if([strProgressValue isEqualToString:@"16"] || [strProgressValue isEqualToString:@"17"] || [strProgressValue isEqualToString:@"18"] || [strProgressValue isEqualToString:@"19"] || [strProgressValue isEqualToString:@"20"])
            {
                cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"04sad"];
            }
            else if([strProgressValue isEqualToString:@"21"] || [strProgressValue isEqualToString:@"22"] || [strProgressValue isEqualToString:@"23"] || [strProgressValue isEqualToString:@"24"] || [strProgressValue isEqualToString:@"25"])
            {
                cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"05sad"];
            }
            else if([strProgressValue isEqualToString:@"26"] || [strProgressValue isEqualToString:@"27"] || [strProgressValue isEqualToString:@"28"] || [strProgressValue isEqualToString:@"29"] || [strProgressValue isEqualToString:@"30"])
            {
                cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"06sad"];
            }
            else if([strProgressValue isEqualToString:@"31"] || [strProgressValue isEqualToString:@"32"] || [strProgressValue isEqualToString:@"33"] || [strProgressValue isEqualToString:@"34"] || [strProgressValue isEqualToString:@"35"])
            {
                cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"07sad"];
            }
            else if([strProgressValue isEqualToString:@"36"] || [strProgressValue isEqualToString:@"37"] || [strProgressValue isEqualToString:@"38"] || [strProgressValue isEqualToString:@"39"] || [strProgressValue isEqualToString:@"40"])
            {
                cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"08sad"];
            }
            else if([strProgressValue isEqualToString:@"41"] || [strProgressValue isEqualToString:@"42"] || [strProgressValue isEqualToString:@"43"] || [strProgressValue isEqualToString:@"44"] || [strProgressValue isEqualToString:@"45"])
            {
                cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"09sad"];
            }
            else if([strProgressValue isEqualToString:@"46"] || [strProgressValue isEqualToString:@"47"] || [strProgressValue isEqualToString:@"48"] || [strProgressValue isEqualToString:@"49"] || [strProgressValue isEqualToString:@"50"])
            {
                cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"10sad"];
            }
            else if([strProgressValue isEqualToString:@"51"] || [strProgressValue isEqualToString:@"52"] || [strProgressValue isEqualToString:@"53"] || [strProgressValue isEqualToString:@"54"] || [strProgressValue isEqualToString:@"55"])
            {
                cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"11sad"];
            }
            else if([strProgressValue isEqualToString:@"56"] || [strProgressValue isEqualToString:@"57"] || [strProgressValue isEqualToString:@"58"] || [strProgressValue isEqualToString:@"59"] || [strProgressValue isEqualToString:@"60"])
            {
                cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"12happy"];
            }
            else if([strProgressValue isEqualToString:@"61"] || [strProgressValue isEqualToString:@"62"] || [strProgressValue isEqualToString:@"63"] || [strProgressValue isEqualToString:@"64"] || [strProgressValue isEqualToString:@"65"])
            {
                cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"13happy"];
            }
            else if([strProgressValue isEqualToString:@"66"] || [strProgressValue isEqualToString:@"67"] || [strProgressValue isEqualToString:@"68"] || [strProgressValue isEqualToString:@"69"] || [strProgressValue isEqualToString:@"70"])
            {
                cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"14happy"];
            }
            else if([strProgressValue isEqualToString:@"71"] || [strProgressValue isEqualToString:@"72"] || [strProgressValue isEqualToString:@"73"] || [strProgressValue isEqualToString:@"74"] || [strProgressValue isEqualToString:@"75"])
            {
                cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"15happy"];
            }
            else if([strProgressValue isEqualToString:@"76"] || [strProgressValue isEqualToString:@"77"] || [strProgressValue isEqualToString:@"78"] || [strProgressValue isEqualToString:@"79"] || [strProgressValue isEqualToString:@"80"])
            {
                cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"16happy"];
            }
            else if([strProgressValue isEqualToString:@"81"] || [strProgressValue isEqualToString:@"82"] || [strProgressValue isEqualToString:@"83"] || [strProgressValue isEqualToString:@"84"] || [strProgressValue isEqualToString:@"85"])
            {
                cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"17happy"];
            }
            else if([strProgressValue isEqualToString:@"86"] || [strProgressValue isEqualToString:@"87"] || [strProgressValue isEqualToString:@"88"] || [strProgressValue isEqualToString:@"89"] || [strProgressValue isEqualToString:@"90"])
            {
                cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"18happy"];
            }
            else if([strProgressValue isEqualToString:@"91"] || [strProgressValue isEqualToString:@"92"] || [strProgressValue isEqualToString:@"93"] || [strProgressValue isEqualToString:@"94"] || [strProgressValue isEqualToString:@"95"])
            {
                cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"19happy"];
            }
            else //if([strValue isEqualToString:@"96"] || [strValue isEqualToString:@"97"] || [strValue isEqualToString:@"98"] || [strValue isEqualToString:@"99"] || [strValue isEqualToString:@"100"])
            {
                cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"20happy"];
            }
            
        }
        else
        {
            cellHome.imgHome.hidden=NO;
            cellHome.imgHomeMoodsShow.hidden=YES;
            //cellHome.imgHomeMoodsShow.contentMode=UIViewContentModeScaleAspectFit;
            cellHome.imgHome.contentMode=UIViewContentModeScaleAspectFill;
            cellHome.imgHome.image =[UIImage imageNamed:@"Image_5"];
        }
        
        //cellHome.imgHome.image =[UIImage imageNamed:[arrayHomedataList objectAtIndex:indexPath.row]];
        
        //_lblDayTime.text = [arrayDayTime objectAtIndex:indexPath.row];
        // _lblToday.text = [arrayToday objectAtIndex:indexPath.row];
        
        NSString *plainText = [[[arrayStoryData valueForKey:@"Story"] valueForKey:@"description"] objectAtIndex:indexPath.row];
        NSString *key = @"9B307D9DB5EAA3E360338F9AD4218D7E";
        NSString *iv = @"8FB1A2080C648F95";
        
        //CryptLib *cryptoLib = [[CryptLib alloc] init];
        
        //NSString *decryptedString = [cryptoLib decryptCipherTextWith:plainText key:key iv:iv];
        
        //NSLog(@"decryptedString %@", decryptedString);
        
        cellHome.lblHomeDescription.text=[[[arrayStoryData valueForKey:@"Story"] valueForKey:@"description"] objectAtIndex:indexPath.row];
        
        cellHome.selectionStyle = UITableViewCellSelectionStyleNone;
        
        float strProgress;
        if(strProgressValue == nil || strProgressValue == NULL || [strProgressValue isEqualToString:@""] || [strProgressValue isKindOfClass:[NSNull class]] || [strProgressValue isEqualToString:@"<null>"])
        {
            strProgress=0.0/100;
            strProgressValue=@"0";
        }
        else
        {
            strProgress=[[[[arrayStoryData valueForKey:@"Story"] valueForKey:@"moodicon"] objectAtIndex:indexPath.row] floatValue]/100;
        }
        
        // CircularProgressViews
        cellHome.HomeSmilyProgress.delegate = self;
        cellHome.HomeSmilyProgress.progressColor = self.view.tintColor;
        cellHome.HomeSmilyProgress.progressColor = [UIColor colorWithRed:217.0 / 255.0 green:47.0 / 255.0 blue:78.0 / 255.0 alpha:1.0];
        cellHome.HomeSmilyProgress.progressArcWidth = 3.0f;
        
        [cellHome.HomeSmilyProgress setProgress:strProgress animated:YES];
        
        cellHome.lblHomeFeelings.text=[NSString stringWithFormat:@"Feeling a %@",strProgressValue];
        
        if([strProgressValue isEqualToString:@"0"] || [strProgressValue isEqualToString:@"1"] || [strProgressValue isEqualToString:@"2"] || [strProgressValue isEqualToString:@"3"] || [strProgressValue isEqualToString:@"4"] || [strProgressValue isEqualToString:@"5"])
        {
            cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"01sad1"];
        }
        else if([strProgressValue isEqualToString:@"6"] || [strProgressValue isEqualToString:@"7"] || [strProgressValue isEqualToString:@"8"] || [strProgressValue isEqualToString:@"9"] || [strProgressValue isEqualToString:@"10"])
        {
            cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"02sad1"];
        }
        else if([strProgressValue isEqualToString:@"11"] || [strProgressValue isEqualToString:@"12"] || [strProgressValue isEqualToString:@"13"] || [strProgressValue isEqualToString:@"14"] || [strProgressValue isEqualToString:@"15"])
        {
            cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"03sad1"];
        }
        else if([strProgressValue isEqualToString:@"16"] || [strProgressValue isEqualToString:@"17"] || [strProgressValue isEqualToString:@"18"] || [strProgressValue isEqualToString:@"19"] || [strProgressValue isEqualToString:@"20"])
        {
            cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"04sad1"];
        }
        else if([strProgressValue isEqualToString:@"21"] || [strProgressValue isEqualToString:@"22"] || [strProgressValue isEqualToString:@"23"] || [strProgressValue isEqualToString:@"24"] || [strProgressValue isEqualToString:@"25"])
        {
            cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"05sad1"];
        }
        else if([strProgressValue isEqualToString:@"26"] || [strProgressValue isEqualToString:@"27"] || [strProgressValue isEqualToString:@"28"] || [strProgressValue isEqualToString:@"29"] || [strProgressValue isEqualToString:@"30"])
        {
            cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"06sad1"];
        }
        else if([strProgressValue isEqualToString:@"31"] || [strProgressValue isEqualToString:@"32"] || [strProgressValue isEqualToString:@"33"] || [strProgressValue isEqualToString:@"34"] || [strProgressValue isEqualToString:@"35"])
        {
            cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"07sad1"];
        }
        else if([strProgressValue isEqualToString:@"36"] || [strProgressValue isEqualToString:@"37"] || [strProgressValue isEqualToString:@"38"] || [strProgressValue isEqualToString:@"39"] || [strProgressValue isEqualToString:@"40"])
        {
            cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"08sad1"];
        }
        else if([strProgressValue isEqualToString:@"41"] || [strProgressValue isEqualToString:@"42"] || [strProgressValue isEqualToString:@"43"] || [strProgressValue isEqualToString:@"44"] || [strProgressValue isEqualToString:@"45"])
        {
            cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"09sad1"];
        }
        else if([strProgressValue isEqualToString:@"46"] || [strProgressValue isEqualToString:@"47"] || [strProgressValue isEqualToString:@"48"] || [strProgressValue isEqualToString:@"49"] || [strProgressValue isEqualToString:@"50"])
        {
            cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"10sad1"];
        }
        else if([strProgressValue isEqualToString:@"51"] || [strProgressValue isEqualToString:@"52"] || [strProgressValue isEqualToString:@"53"] || [strProgressValue isEqualToString:@"54"] || [strProgressValue isEqualToString:@"55"])
        {
            cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"11sad1"];
        }
        else if([strProgressValue isEqualToString:@"56"] || [strProgressValue isEqualToString:@"57"] || [strProgressValue isEqualToString:@"58"] || [strProgressValue isEqualToString:@"59"] || [strProgressValue isEqualToString:@"60"])
        {
            cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"12happy1"];
        }
        else if([strProgressValue isEqualToString:@"61"] || [strProgressValue isEqualToString:@"62"] || [strProgressValue isEqualToString:@"63"] || [strProgressValue isEqualToString:@"64"] || [strProgressValue isEqualToString:@"65"])
        {
            cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"13happy1"];
        }
        else if([strProgressValue isEqualToString:@"66"] || [strProgressValue isEqualToString:@"67"] || [strProgressValue isEqualToString:@"68"] || [strProgressValue isEqualToString:@"69"] || [strProgressValue isEqualToString:@"70"])
        {
            cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"14happy1"];
        }
        else if([strProgressValue isEqualToString:@"71"] || [strProgressValue isEqualToString:@"72"] || [strProgressValue isEqualToString:@"73"] || [strProgressValue isEqualToString:@"74"] || [strProgressValue isEqualToString:@"75"])
        {
            cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"15happy1"];
        }
        else if([strProgressValue isEqualToString:@"76"] || [strProgressValue isEqualToString:@"77"] || [strProgressValue isEqualToString:@"78"] || [strProgressValue isEqualToString:@"79"] || [strProgressValue isEqualToString:@"80"])
        {
            cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"16happy1"];
        }
        else if([strProgressValue isEqualToString:@"81"] || [strProgressValue isEqualToString:@"82"] || [strProgressValue isEqualToString:@"83"] || [strProgressValue isEqualToString:@"84"] || [strProgressValue isEqualToString:@"85"])
        {
            cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"17happy1"];
        }
        else if([strProgressValue isEqualToString:@"86"] || [strProgressValue isEqualToString:@"87"] || [strProgressValue isEqualToString:@"88"] || [strProgressValue isEqualToString:@"89"] || [strProgressValue isEqualToString:@"90"])
        {
            cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"18happy1"];
        }
        else if([strProgressValue isEqualToString:@"91"] || [strProgressValue isEqualToString:@"92"] || [strProgressValue isEqualToString:@"93"] || [strProgressValue isEqualToString:@"94"] || [strProgressValue isEqualToString:@"95"])
        {
            cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"19happy1"];
        }
        else //if([strValue isEqualToString:@"96"] || [strValue isEqualToString:@"97"] || [strValue isEqualToString:@"98"] || [strValue isEqualToString:@"99"] || [strValue isEqualToString:@"100"])
        {
            cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"20happy1"];
        }
        
        return cellHome;
    }
    else if (Data==1)
    {
        NSMutableArray *array=[[NSMutableArray alloc]initWithArray:[[arrayStoryData valueForKey:@"StoryFile"] objectAtIndex:indexPath.row]];
        
        NSString *strStoryFileMedia=[[array objectAtIndex:0]valueForKey:@"media_type"];
        
        if([strStoryFileMedia isEqualToString:@"Audio"])
        {
            static NSString *MyIdentifier = @"HomeRecord_Cell";
            HomeRecord_Cell *cellHomeRecord = (HomeRecord_Cell *)[_tblSearch dequeueReusableCellWithIdentifier:MyIdentifier];
            
            //cellHome.contentView.layer.cornerRadius = 12.0;
            
            cellHomeRecord.contentView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
            cellHomeRecord.contentView.layer.shadowOffset = CGSizeMake(2, 2);
            cellHomeRecord.contentView.layer.shadowOpacity = 15;
            cellHomeRecord.contentView.layer.shadowRadius = 5.0;
            cellHomeRecord.contentView.clipsToBounds = NO;
            
            cellHomeRecord.viewRecord.layer.cornerRadius = 14.0;
            cellHomeRecord.viewRecord.layer.shadowColor = [UIColor lightGrayColor].CGColor;
            cellHomeRecord.viewRecord.layer.shadowOffset = CGSizeMake(2, 2);
            cellHomeRecord.viewRecord.layer.shadowOpacity = 15;
            cellHomeRecord.viewRecord.layer.shadowRadius = 5.0;
            cellHomeRecord.viewRecord.clipsToBounds = NO;
            cellHomeRecord.viewRecord.layer.masksToBounds = YES;
            
            cellHomeRecord.viewRecordProgress.layer.cornerRadius=5;
            cellHomeRecord.viewRecordProgress.layer.masksToBounds=YES;
            
            NSString *strTime=[NSString stringWithFormat:@"%@",[[[arrayStoryData valueForKey:@"Story"] valueForKey:@"modified"] objectAtIndex:indexPath.row]];
            
            //NSString *myString = @"2012-11-22 10:19:04";
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSDate *yourDate1 = [dateFormatter dateFromString:strTime];
            dateFormatter.dateFormat = @"hh:mm aaa";
            NSLog(@"%@",[dateFormatter stringFromDate:yourDate1]);
            
            NSString *strFinalTime = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:yourDate1]];
            NSLog(@"%@",strFinalTime);
            
            cellHomeRecord.lblRecordTime.text = [strFinalTime uppercaseString];
            
            /*NSString *strProgressValue=[NSString stringWithFormat:@"%@",[[[arrayStoryData valueForKey:@"Story"] valueForKey:@"moodicon"] objectAtIndex:indexPath.row]];
             
             NSString *strMoods=[NSString stringWithFormat:@"%@",[[[arrayStoryData valueForKey:@"Story"] valueForKey:@"heading"] objectAtIndex:indexPath.row]];
             
             if([strMoods isEqualToString:@"Moods"])
             {
             cellHome.imgHome.contentMode=UIViewContentModeScaleAspectFit;
             cellHome.imgHome.hidden=YES;
             cellHome.imgHomeMoodsShow.hidden=NO;
             cellHome.imgHomeMoodsShow.contentMode=UIViewContentModeScaleAspectFit;
             if([strProgressValue isEqualToString:@"0"] || [strProgressValue isEqualToString:@"1"] || [strProgressValue isEqualToString:@"2"] || [strProgressValue isEqualToString:@"3"] || [strProgressValue isEqualToString:@"4"] || [strProgressValue isEqualToString:@"5"])
             {
             cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"01sad"];
             }
             else if([strProgressValue isEqualToString:@"6"] || [strProgressValue isEqualToString:@"7"] || [strProgressValue isEqualToString:@"8"] || [strProgressValue isEqualToString:@"9"] || [strProgressValue isEqualToString:@"10"])
             {
             cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"02sad"];
             }
             else if([strProgressValue isEqualToString:@"11"] || [strProgressValue isEqualToString:@"12"] || [strProgressValue isEqualToString:@"13"] || [strProgressValue isEqualToString:@"14"] || [strProgressValue isEqualToString:@"15"])
             {
             cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"03sad"];
             }
             else if([strProgressValue isEqualToString:@"16"] || [strProgressValue isEqualToString:@"17"] || [strProgressValue isEqualToString:@"18"] || [strProgressValue isEqualToString:@"19"] || [strProgressValue isEqualToString:@"20"])
             {
             cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"04sad"];
             }
             else if([strProgressValue isEqualToString:@"21"] || [strProgressValue isEqualToString:@"22"] || [strProgressValue isEqualToString:@"23"] || [strProgressValue isEqualToString:@"24"] || [strProgressValue isEqualToString:@"25"])
             {
             cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"05sad"];
             }
             else if([strProgressValue isEqualToString:@"26"] || [strProgressValue isEqualToString:@"27"] || [strProgressValue isEqualToString:@"28"] || [strProgressValue isEqualToString:@"29"] || [strProgressValue isEqualToString:@"30"])
             {
             cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"06sad"];
             }
             else if([strProgressValue isEqualToString:@"31"] || [strProgressValue isEqualToString:@"32"] || [strProgressValue isEqualToString:@"33"] || [strProgressValue isEqualToString:@"34"] || [strProgressValue isEqualToString:@"35"])
             {
             cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"07sad"];
             }
             else if([strProgressValue isEqualToString:@"36"] || [strProgressValue isEqualToString:@"37"] || [strProgressValue isEqualToString:@"38"] || [strProgressValue isEqualToString:@"39"] || [strProgressValue isEqualToString:@"40"])
             {
             cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"08sad"];
             }
             else if([strProgressValue isEqualToString:@"41"] || [strProgressValue isEqualToString:@"42"] || [strProgressValue isEqualToString:@"43"] || [strProgressValue isEqualToString:@"44"] || [strProgressValue isEqualToString:@"45"])
             {
             cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"09sad"];
             }
             else if([strProgressValue isEqualToString:@"46"] || [strProgressValue isEqualToString:@"47"] || [strProgressValue isEqualToString:@"48"] || [strProgressValue isEqualToString:@"49"] || [strProgressValue isEqualToString:@"50"])
             {
             cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"10sad"];
             }
             else if([strProgressValue isEqualToString:@"51"] || [strProgressValue isEqualToString:@"52"] || [strProgressValue isEqualToString:@"53"] || [strProgressValue isEqualToString:@"54"] || [strProgressValue isEqualToString:@"55"])
             {
             cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"11sad"];
             }
             else if([strProgressValue isEqualToString:@"56"] || [strProgressValue isEqualToString:@"57"] || [strProgressValue isEqualToString:@"58"] || [strProgressValue isEqualToString:@"59"] || [strProgressValue isEqualToString:@"60"])
             {
             cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"12happy"];
             }
             else if([strProgressValue isEqualToString:@"61"] || [strProgressValue isEqualToString:@"62"] || [strProgressValue isEqualToString:@"63"] || [strProgressValue isEqualToString:@"64"] || [strProgressValue isEqualToString:@"65"])
             {
             cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"13happy"];
             }
             else if([strProgressValue isEqualToString:@"66"] || [strProgressValue isEqualToString:@"67"] || [strProgressValue isEqualToString:@"68"] || [strProgressValue isEqualToString:@"69"] || [strProgressValue isEqualToString:@"70"])
             {
             cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"14happy"];
             }
             else if([strProgressValue isEqualToString:@"71"] || [strProgressValue isEqualToString:@"72"] || [strProgressValue isEqualToString:@"73"] || [strProgressValue isEqualToString:@"74"] || [strProgressValue isEqualToString:@"75"])
             {
             cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"15happy"];
             }
             else if([strProgressValue isEqualToString:@"76"] || [strProgressValue isEqualToString:@"77"] || [strProgressValue isEqualToString:@"78"] || [strProgressValue isEqualToString:@"79"] || [strProgressValue isEqualToString:@"80"])
             {
             cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"16happy"];
             }
             else if([strProgressValue isEqualToString:@"81"] || [strProgressValue isEqualToString:@"82"] || [strProgressValue isEqualToString:@"83"] || [strProgressValue isEqualToString:@"84"] || [strProgressValue isEqualToString:@"85"])
             {
             cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"17happy"];
             }
             else if([strProgressValue isEqualToString:@"86"] || [strProgressValue isEqualToString:@"87"] || [strProgressValue isEqualToString:@"88"] || [strProgressValue isEqualToString:@"89"] || [strProgressValue isEqualToString:@"90"])
             {
             cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"18happy"];
             }
             else if([strProgressValue isEqualToString:@"91"] || [strProgressValue isEqualToString:@"92"] || [strProgressValue isEqualToString:@"93"] || [strProgressValue isEqualToString:@"94"] || [strProgressValue isEqualToString:@"95"])
             {
             cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"19happy"];
             }
             else //if([strValue isEqualToString:@"96"] || [strValue isEqualToString:@"97"] || [strValue isEqualToString:@"98"] || [strValue isEqualToString:@"99"] || [strValue isEqualToString:@"100"])
             {
             cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"20happy"];
             }
             
             }
             else
             {
             cellHome.imgHome.hidden=NO;
             cellHome.imgHomeMoodsShow.hidden=YES;
             cellHome.imgHomeMoodsShow.contentMode=UIViewContentModeScaleAspectFit;
             cellHome.imgHome.contentMode=UIViewContentModeScaleAspectFill;
             cellHome.imgHome.image =[UIImage imageNamed:@"Image_5"];
             }
             
             //_lblDayTime.text = [arrayDayTime objectAtIndex:indexPath.row];
             // _lblToday.text = [arrayToday objectAtIndex:indexPath.row];
             
             NSString *plainText = [[[arrayStoryData valueForKey:@"Story"] valueForKey:@"description"] objectAtIndex:indexPath.row];
             NSString *key = @"9B307D9DB5EAA3E360338F9AD4218D7E";
             NSString *iv = @"8FB1A2080C648F95";
             
             //CryptLib *cryptoLib = [[CryptLib alloc] init];
             
             //NSString *decryptedString = [cryptoLib decryptCipherTextWith:plainText key:key iv:iv];
             
             //NSLog(@"decryptedString %@", decryptedString);
             
             cellHome.lblHomeDescription.text=[[[arrayStoryData valueForKey:@"Story"] valueForKey:@"description"] objectAtIndex:indexPath.row];
             
             cellHome.selectionStyle = UITableViewCellSelectionStyleNone;
             
             float strProgress;
             if(strProgressValue == nil || strProgressValue == NULL || [strProgressValue isEqualToString:@""] || [strProgressValue isKindOfClass:[NSNull class]] || [strProgressValue isEqualToString:@"<null>"])
             {
             strProgress=0.0/100;
             strProgressValue=@"0";
             }
             else
             {
             strProgress=[[[[arrayStoryData valueForKey:@"Story"] valueForKey:@"moodicon"] objectAtIndex:indexPath.row] floatValue]/100;
             }
             
             // CircularProgressViews
             cellHome.HomeSmilyProgress.delegate = self;
             cellHome.HomeSmilyProgress.progressColor = self.view.tintColor;
             cellHome.HomeSmilyProgress.progressColor = [UIColor colorWithRed:217.0 / 255.0 green:47.0 / 255.0 blue:78.0 / 255.0 alpha:1.0];
             cellHome.HomeSmilyProgress.progressArcWidth = 3.0f;
             
             [cellHome.HomeSmilyProgress setProgress:strProgress animated:YES];
             cellHome.lblHomeFeelings.text=[NSString stringWithFormat:@"Feeling a %@",strProgressValue];
             
             if([strProgressValue isEqualToString:@"0"] || [strProgressValue isEqualToString:@"1"] || [strProgressValue isEqualToString:@"2"] || [strProgressValue isEqualToString:@"3"] || [strProgressValue isEqualToString:@"4"] || [strProgressValue isEqualToString:@"5"])
             {
             cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"01sad1"];
             }
             else if([strProgressValue isEqualToString:@"6"] || [strProgressValue isEqualToString:@"7"] || [strProgressValue isEqualToString:@"8"] || [strProgressValue isEqualToString:@"9"] || [strProgressValue isEqualToString:@"10"])
             {
             cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"02sad1"];
             }
             else if([strProgressValue isEqualToString:@"11"] || [strProgressValue isEqualToString:@"12"] || [strProgressValue isEqualToString:@"13"] || [strProgressValue isEqualToString:@"14"] || [strProgressValue isEqualToString:@"15"])
             {
             cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"03sad1"];
             }
             else if([strProgressValue isEqualToString:@"16"] || [strProgressValue isEqualToString:@"17"] || [strProgressValue isEqualToString:@"18"] || [strProgressValue isEqualToString:@"19"] || [strProgressValue isEqualToString:@"20"])
             {
             cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"04sad1"];
             }
             else if([strProgressValue isEqualToString:@"21"] || [strProgressValue isEqualToString:@"22"] || [strProgressValue isEqualToString:@"23"] || [strProgressValue isEqualToString:@"24"] || [strProgressValue isEqualToString:@"25"])
             {
             cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"05sad1"];
             }
             else if([strProgressValue isEqualToString:@"26"] || [strProgressValue isEqualToString:@"27"] || [strProgressValue isEqualToString:@"28"] || [strProgressValue isEqualToString:@"29"] || [strProgressValue isEqualToString:@"30"])
             {
             cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"06sad1"];
             }
             else if([strProgressValue isEqualToString:@"31"] || [strProgressValue isEqualToString:@"32"] || [strProgressValue isEqualToString:@"33"] || [strProgressValue isEqualToString:@"34"] || [strProgressValue isEqualToString:@"35"])
             {
             cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"07sad1"];
             }
             else if([strProgressValue isEqualToString:@"36"] || [strProgressValue isEqualToString:@"37"] || [strProgressValue isEqualToString:@"38"] || [strProgressValue isEqualToString:@"39"] || [strProgressValue isEqualToString:@"40"])
             {
             cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"08sad1"];
             }
             else if([strProgressValue isEqualToString:@"41"] || [strProgressValue isEqualToString:@"42"] || [strProgressValue isEqualToString:@"43"] || [strProgressValue isEqualToString:@"44"] || [strProgressValue isEqualToString:@"45"])
             {
             cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"09sad1"];
             }
             else if([strProgressValue isEqualToString:@"46"] || [strProgressValue isEqualToString:@"47"] || [strProgressValue isEqualToString:@"48"] || [strProgressValue isEqualToString:@"49"] || [strProgressValue isEqualToString:@"50"])
             {
             cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"10sad1"];
             }
             else if([strProgressValue isEqualToString:@"51"] || [strProgressValue isEqualToString:@"52"] || [strProgressValue isEqualToString:@"53"] || [strProgressValue isEqualToString:@"54"] || [strProgressValue isEqualToString:@"55"])
             {
             cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"11sad1"];
             }
             else if([strProgressValue isEqualToString:@"56"] || [strProgressValue isEqualToString:@"57"] || [strProgressValue isEqualToString:@"58"] || [strProgressValue isEqualToString:@"59"] || [strProgressValue isEqualToString:@"60"])
             {
             cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"12happy1"];
             }
             else if([strProgressValue isEqualToString:@"61"] || [strProgressValue isEqualToString:@"62"] || [strProgressValue isEqualToString:@"63"] || [strProgressValue isEqualToString:@"64"] || [strProgressValue isEqualToString:@"65"])
             {
             cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"13happy1"];
             }
             else if([strProgressValue isEqualToString:@"66"] || [strProgressValue isEqualToString:@"67"] || [strProgressValue isEqualToString:@"68"] || [strProgressValue isEqualToString:@"69"] || [strProgressValue isEqualToString:@"70"])
             {
             cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"14happy1"];
             }
             else if([strProgressValue isEqualToString:@"71"] || [strProgressValue isEqualToString:@"72"] || [strProgressValue isEqualToString:@"73"] || [strProgressValue isEqualToString:@"74"] || [strProgressValue isEqualToString:@"75"])
             {
             cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"15happy1"];
             }
             else if([strProgressValue isEqualToString:@"76"] || [strProgressValue isEqualToString:@"77"] || [strProgressValue isEqualToString:@"78"] || [strProgressValue isEqualToString:@"79"] || [strProgressValue isEqualToString:@"80"])
             {
             cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"16happy1"];
             }
             else if([strProgressValue isEqualToString:@"81"] || [strProgressValue isEqualToString:@"82"] || [strProgressValue isEqualToString:@"83"] || [strProgressValue isEqualToString:@"84"] || [strProgressValue isEqualToString:@"85"])
             {
             cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"17happy1"];
             }
             else if([strProgressValue isEqualToString:@"86"] || [strProgressValue isEqualToString:@"87"] || [strProgressValue isEqualToString:@"88"] || [strProgressValue isEqualToString:@"89"] || [strProgressValue isEqualToString:@"90"])
             {
             cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"18happy1"];
             }
             else if([strProgressValue isEqualToString:@"91"] || [strProgressValue isEqualToString:@"92"] || [strProgressValue isEqualToString:@"93"] || [strProgressValue isEqualToString:@"94"] || [strProgressValue isEqualToString:@"95"])
             {
             cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"19happy1"];
             }
             else //if([strValue isEqualToString:@"96"] || [strValue isEqualToString:@"97"] || [strValue isEqualToString:@"98"] || [strValue isEqualToString:@"99"] || [strValue isEqualToString:@"100"])
             {
             cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"20happy1"];
             }*/
            
            return cellHomeRecord;
        }
        else
        {
            static NSString *MyIdentifier = @"HomeCell";
            HomeCell *cellHome = (HomeCell *)[_tblSearch dequeueReusableCellWithIdentifier:MyIdentifier];
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
            
            NSString *strTime=[NSString stringWithFormat:@"%@",[[[arrayStoryData valueForKey:@"Story"] valueForKey:@"modified"] objectAtIndex:indexPath.row]];
            
            //NSString *myString = @"2012-11-22 10:19:04";
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSDate *yourDate1 = [dateFormatter dateFromString:strTime];
            dateFormatter.dateFormat = @"hh:mm aaa";
            NSLog(@"%@",[dateFormatter stringFromDate:yourDate1]);
            
            NSString *strFinalTime = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:yourDate1]];
            NSLog(@"%@",strFinalTime);
            
            cellHome.lblHomeTime.text = [strFinalTime uppercaseString];
            
            NSString *strProgressValue=[NSString stringWithFormat:@"%@",[[[arrayStoryData valueForKey:@"Story"] valueForKey:@"moodicon"] objectAtIndex:indexPath.row]];
            
            NSString *strMoods=[NSString stringWithFormat:@"%@",[[[arrayStoryData valueForKey:@"Story"] valueForKey:@"heading"] objectAtIndex:indexPath.row]];
            
            if([strMoods isEqualToString:@"Moods"])
            {
                cellHome.imgHome.contentMode=UIViewContentModeScaleAspectFit;
                cellHome.imgHome.hidden=YES;
                cellHome.imgHomeMoodsShow.hidden=NO;
                cellHome.imgHomeMoodsShow.contentMode=UIViewContentModeScaleAspectFit;
                if([strProgressValue isEqualToString:@"0"] || [strProgressValue isEqualToString:@"1"] || [strProgressValue isEqualToString:@"2"] || [strProgressValue isEqualToString:@"3"] || [strProgressValue isEqualToString:@"4"] || [strProgressValue isEqualToString:@"5"])
                {
                    cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"01sad"];
                }
                else if([strProgressValue isEqualToString:@"6"] || [strProgressValue isEqualToString:@"7"] || [strProgressValue isEqualToString:@"8"] || [strProgressValue isEqualToString:@"9"] || [strProgressValue isEqualToString:@"10"])
                {
                    cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"02sad"];
                }
                else if([strProgressValue isEqualToString:@"11"] || [strProgressValue isEqualToString:@"12"] || [strProgressValue isEqualToString:@"13"] || [strProgressValue isEqualToString:@"14"] || [strProgressValue isEqualToString:@"15"])
                {
                    cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"03sad"];
                }
                else if([strProgressValue isEqualToString:@"16"] || [strProgressValue isEqualToString:@"17"] || [strProgressValue isEqualToString:@"18"] || [strProgressValue isEqualToString:@"19"] || [strProgressValue isEqualToString:@"20"])
                {
                    cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"04sad"];
                }
                else if([strProgressValue isEqualToString:@"21"] || [strProgressValue isEqualToString:@"22"] || [strProgressValue isEqualToString:@"23"] || [strProgressValue isEqualToString:@"24"] || [strProgressValue isEqualToString:@"25"])
                {
                    cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"05sad"];
                }
                else if([strProgressValue isEqualToString:@"26"] || [strProgressValue isEqualToString:@"27"] || [strProgressValue isEqualToString:@"28"] || [strProgressValue isEqualToString:@"29"] || [strProgressValue isEqualToString:@"30"])
                {
                    cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"06sad"];
                }
                else if([strProgressValue isEqualToString:@"31"] || [strProgressValue isEqualToString:@"32"] || [strProgressValue isEqualToString:@"33"] || [strProgressValue isEqualToString:@"34"] || [strProgressValue isEqualToString:@"35"])
                {
                    cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"07sad"];
                }
                else if([strProgressValue isEqualToString:@"36"] || [strProgressValue isEqualToString:@"37"] || [strProgressValue isEqualToString:@"38"] || [strProgressValue isEqualToString:@"39"] || [strProgressValue isEqualToString:@"40"])
                {
                    cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"08sad"];
                }
                else if([strProgressValue isEqualToString:@"41"] || [strProgressValue isEqualToString:@"42"] || [strProgressValue isEqualToString:@"43"] || [strProgressValue isEqualToString:@"44"] || [strProgressValue isEqualToString:@"45"])
                {
                    cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"09sad"];
                }
                else if([strProgressValue isEqualToString:@"46"] || [strProgressValue isEqualToString:@"47"] || [strProgressValue isEqualToString:@"48"] || [strProgressValue isEqualToString:@"49"] || [strProgressValue isEqualToString:@"50"])
                {
                    cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"10sad"];
                }
                else if([strProgressValue isEqualToString:@"51"] || [strProgressValue isEqualToString:@"52"] || [strProgressValue isEqualToString:@"53"] || [strProgressValue isEqualToString:@"54"] || [strProgressValue isEqualToString:@"55"])
                {
                    cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"11sad"];
                }
                else if([strProgressValue isEqualToString:@"56"] || [strProgressValue isEqualToString:@"57"] || [strProgressValue isEqualToString:@"58"] || [strProgressValue isEqualToString:@"59"] || [strProgressValue isEqualToString:@"60"])
                {
                    cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"12happy"];
                }
                else if([strProgressValue isEqualToString:@"61"] || [strProgressValue isEqualToString:@"62"] || [strProgressValue isEqualToString:@"63"] || [strProgressValue isEqualToString:@"64"] || [strProgressValue isEqualToString:@"65"])
                {
                    cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"13happy"];
                }
                else if([strProgressValue isEqualToString:@"66"] || [strProgressValue isEqualToString:@"67"] || [strProgressValue isEqualToString:@"68"] || [strProgressValue isEqualToString:@"69"] || [strProgressValue isEqualToString:@"70"])
                {
                    cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"14happy"];
                }
                else if([strProgressValue isEqualToString:@"71"] || [strProgressValue isEqualToString:@"72"] || [strProgressValue isEqualToString:@"73"] || [strProgressValue isEqualToString:@"74"] || [strProgressValue isEqualToString:@"75"])
                {
                    cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"15happy"];
                }
                else if([strProgressValue isEqualToString:@"76"] || [strProgressValue isEqualToString:@"77"] || [strProgressValue isEqualToString:@"78"] || [strProgressValue isEqualToString:@"79"] || [strProgressValue isEqualToString:@"80"])
                {
                    cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"16happy"];
                }
                else if([strProgressValue isEqualToString:@"81"] || [strProgressValue isEqualToString:@"82"] || [strProgressValue isEqualToString:@"83"] || [strProgressValue isEqualToString:@"84"] || [strProgressValue isEqualToString:@"85"])
                {
                    cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"17happy"];
                }
                else if([strProgressValue isEqualToString:@"86"] || [strProgressValue isEqualToString:@"87"] || [strProgressValue isEqualToString:@"88"] || [strProgressValue isEqualToString:@"89"] || [strProgressValue isEqualToString:@"90"])
                {
                    cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"18happy"];
                }
                else if([strProgressValue isEqualToString:@"91"] || [strProgressValue isEqualToString:@"92"] || [strProgressValue isEqualToString:@"93"] || [strProgressValue isEqualToString:@"94"] || [strProgressValue isEqualToString:@"95"])
                {
                    cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"19happy"];
                }
                else //if([strValue isEqualToString:@"96"] || [strValue isEqualToString:@"97"] || [strValue isEqualToString:@"98"] || [strValue isEqualToString:@"99"] || [strValue isEqualToString:@"100"])
                {
                    cellHome.imgHomeMoodsShow.image=[UIImage imageNamed:@"20happy"];
                }
                
            }
            else
            {
                cellHome.imgHome.hidden=NO;
                cellHome.imgHomeMoodsShow.hidden=YES;
                cellHome.imgHomeMoodsShow.contentMode=UIViewContentModeScaleAspectFit;
                cellHome.imgHome.contentMode=UIViewContentModeScaleAspectFill;
                cellHome.imgHome.image =[UIImage imageNamed:@"Image_5"];
            }
            
            //_lblDayTime.text = [arrayDayTime objectAtIndex:indexPath.row];
            // _lblToday.text = [arrayToday objectAtIndex:indexPath.row];
            
            NSString *plainText = [[[arrayStoryData valueForKey:@"Story"] valueForKey:@"description"] objectAtIndex:indexPath.row];
            NSString *key = @"9B307D9DB5EAA3E360338F9AD4218D7E";
            NSString *iv = @"8FB1A2080C648F95";
            
            //CryptLib *cryptoLib = [[CryptLib alloc] init];
            
            //NSString *decryptedString = [cryptoLib decryptCipherTextWith:plainText key:key iv:iv];
            
            //NSLog(@"decryptedString %@", decryptedString);
            
            cellHome.lblHomeDescription.text=[[[arrayStoryData valueForKey:@"Story"] valueForKey:@"description"] objectAtIndex:indexPath.row];
            
            cellHome.selectionStyle = UITableViewCellSelectionStyleNone;
            
            float strProgress;
            if(strProgressValue == nil || strProgressValue == NULL || [strProgressValue isEqualToString:@""] || [strProgressValue isKindOfClass:[NSNull class]] || [strProgressValue isEqualToString:@"<null>"])
            {
                strProgress=0.0/100;
                strProgressValue=@"0";
            }
            else
            {
                strProgress=[[[[arrayStoryData valueForKey:@"Story"] valueForKey:@"moodicon"] objectAtIndex:indexPath.row] floatValue]/100;
            }
            
            // CircularProgressViews
            cellHome.HomeSmilyProgress.delegate = self;
            cellHome.HomeSmilyProgress.progressColor = self.view.tintColor;
            cellHome.HomeSmilyProgress.progressColor = [UIColor colorWithRed:217.0 / 255.0 green:47.0 / 255.0 blue:78.0 / 255.0 alpha:1.0];
            cellHome.HomeSmilyProgress.progressArcWidth = 3.0f;
            
            [cellHome.HomeSmilyProgress setProgress:strProgress animated:YES];
            cellHome.lblHomeFeelings.text=[NSString stringWithFormat:@"Feeling a %@",strProgressValue];
            
            if([strProgressValue isEqualToString:@"0"] || [strProgressValue isEqualToString:@"1"] || [strProgressValue isEqualToString:@"2"] || [strProgressValue isEqualToString:@"3"] || [strProgressValue isEqualToString:@"4"] || [strProgressValue isEqualToString:@"5"])
            {
                cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"01sad1"];
            }
            else if([strProgressValue isEqualToString:@"6"] || [strProgressValue isEqualToString:@"7"] || [strProgressValue isEqualToString:@"8"] || [strProgressValue isEqualToString:@"9"] || [strProgressValue isEqualToString:@"10"])
            {
                cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"02sad1"];
            }
            else if([strProgressValue isEqualToString:@"11"] || [strProgressValue isEqualToString:@"12"] || [strProgressValue isEqualToString:@"13"] || [strProgressValue isEqualToString:@"14"] || [strProgressValue isEqualToString:@"15"])
            {
                cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"03sad1"];
            }
            else if([strProgressValue isEqualToString:@"16"] || [strProgressValue isEqualToString:@"17"] || [strProgressValue isEqualToString:@"18"] || [strProgressValue isEqualToString:@"19"] || [strProgressValue isEqualToString:@"20"])
            {
                cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"04sad1"];
            }
            else if([strProgressValue isEqualToString:@"21"] || [strProgressValue isEqualToString:@"22"] || [strProgressValue isEqualToString:@"23"] || [strProgressValue isEqualToString:@"24"] || [strProgressValue isEqualToString:@"25"])
            {
                cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"05sad1"];
            }
            else if([strProgressValue isEqualToString:@"26"] || [strProgressValue isEqualToString:@"27"] || [strProgressValue isEqualToString:@"28"] || [strProgressValue isEqualToString:@"29"] || [strProgressValue isEqualToString:@"30"])
            {
                cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"06sad1"];
            }
            else if([strProgressValue isEqualToString:@"31"] || [strProgressValue isEqualToString:@"32"] || [strProgressValue isEqualToString:@"33"] || [strProgressValue isEqualToString:@"34"] || [strProgressValue isEqualToString:@"35"])
            {
                cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"07sad1"];
            }
            else if([strProgressValue isEqualToString:@"36"] || [strProgressValue isEqualToString:@"37"] || [strProgressValue isEqualToString:@"38"] || [strProgressValue isEqualToString:@"39"] || [strProgressValue isEqualToString:@"40"])
            {
                cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"08sad1"];
            }
            else if([strProgressValue isEqualToString:@"41"] || [strProgressValue isEqualToString:@"42"] || [strProgressValue isEqualToString:@"43"] || [strProgressValue isEqualToString:@"44"] || [strProgressValue isEqualToString:@"45"])
            {
                cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"09sad1"];
            }
            else if([strProgressValue isEqualToString:@"46"] || [strProgressValue isEqualToString:@"47"] || [strProgressValue isEqualToString:@"48"] || [strProgressValue isEqualToString:@"49"] || [strProgressValue isEqualToString:@"50"])
            {
                cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"10sad1"];
            }
            else if([strProgressValue isEqualToString:@"51"] || [strProgressValue isEqualToString:@"52"] || [strProgressValue isEqualToString:@"53"] || [strProgressValue isEqualToString:@"54"] || [strProgressValue isEqualToString:@"55"])
            {
                cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"11sad1"];
            }
            else if([strProgressValue isEqualToString:@"56"] || [strProgressValue isEqualToString:@"57"] || [strProgressValue isEqualToString:@"58"] || [strProgressValue isEqualToString:@"59"] || [strProgressValue isEqualToString:@"60"])
            {
                cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"12happy1"];
            }
            else if([strProgressValue isEqualToString:@"61"] || [strProgressValue isEqualToString:@"62"] || [strProgressValue isEqualToString:@"63"] || [strProgressValue isEqualToString:@"64"] || [strProgressValue isEqualToString:@"65"])
            {
                cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"13happy1"];
            }
            else if([strProgressValue isEqualToString:@"66"] || [strProgressValue isEqualToString:@"67"] || [strProgressValue isEqualToString:@"68"] || [strProgressValue isEqualToString:@"69"] || [strProgressValue isEqualToString:@"70"])
            {
                cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"14happy1"];
            }
            else if([strProgressValue isEqualToString:@"71"] || [strProgressValue isEqualToString:@"72"] || [strProgressValue isEqualToString:@"73"] || [strProgressValue isEqualToString:@"74"] || [strProgressValue isEqualToString:@"75"])
            {
                cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"15happy1"];
            }
            else if([strProgressValue isEqualToString:@"76"] || [strProgressValue isEqualToString:@"77"] || [strProgressValue isEqualToString:@"78"] || [strProgressValue isEqualToString:@"79"] || [strProgressValue isEqualToString:@"80"])
            {
                cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"16happy1"];
            }
            else if([strProgressValue isEqualToString:@"81"] || [strProgressValue isEqualToString:@"82"] || [strProgressValue isEqualToString:@"83"] || [strProgressValue isEqualToString:@"84"] || [strProgressValue isEqualToString:@"85"])
            {
                cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"17happy1"];
            }
            else if([strProgressValue isEqualToString:@"86"] || [strProgressValue isEqualToString:@"87"] || [strProgressValue isEqualToString:@"88"] || [strProgressValue isEqualToString:@"89"] || [strProgressValue isEqualToString:@"90"])
            {
                cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"18happy1"];
            }
            else if([strProgressValue isEqualToString:@"91"] || [strProgressValue isEqualToString:@"92"] || [strProgressValue isEqualToString:@"93"] || [strProgressValue isEqualToString:@"94"] || [strProgressValue isEqualToString:@"95"])
            {
                cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"19happy1"];
            }
            else //if([strValue isEqualToString:@"96"] || [strValue isEqualToString:@"97"] || [strValue isEqualToString:@"98"] || [strValue isEqualToString:@"99"] || [strValue isEqualToString:@"100"])
            {
                cellHome.imgHomeEmoji.image=[UIImage imageNamed:@"20happy1"];
            }
            
            return cellHome;
            
        }
    }
    else if (Data==2)
    {
        static NSString *MyIdentifier = @"HomeCell_2";
        HomeCell_2 *cellHome = (HomeCell_2 *)[_tblSearch dequeueReusableCellWithIdentifier:MyIdentifier];
        
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
        
        NSString *strTime=[NSString stringWithFormat:@"%@",[[[arrayStoryData valueForKey:@"Story"] valueForKey:@"modified"] objectAtIndex:indexPath.row]];
        
        //NSString *myString = @"2012-11-22 10:19:04";
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *yourDate1 = [dateFormatter dateFromString:strTime];
        dateFormatter.dateFormat = @"hh:mm aaa";
        NSLog(@"%@",[dateFormatter stringFromDate:yourDate1]);
        
        NSString *strFinalTime = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:yourDate1]];
        NSLog(@"%@",strFinalTime);
        
        cellHome.lblHome2Time.text = [strFinalTime uppercaseString];
        
        // _lblDayTime.text = [arrayDayTime objectAtIndex:indexPath.row];
        //_lblToday.text = [arrayToday objectAtIndex:indexPath.row];
        
        NSString *plainText = [[[arrayStoryData valueForKey:@"Story"] valueForKey:@"description"] objectAtIndex:indexPath.row];
        NSString *key = @"9B307D9DB5EAA3E360338F9AD4218D7E";
        NSString *iv = @"8FB1A2080C648F95";
        
        //CryptLib *cryptoLib = [[CryptLib alloc] init];
        
        //NSString *decryptedString = [cryptoLib decryptCipherTextWith:plainText key:key iv:iv];
        
        //NSLog(@"decryptedString %@", decryptedString);
        
        cellHome.lblHome2Description.text=[[[arrayStoryData valueForKey:@"Story"] valueForKey:@"description"] objectAtIndex:indexPath.row];
        
        cellHome.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *strProgressValue=[NSString stringWithFormat:@"%@",[[[arrayStoryData valueForKey:@"Story"] valueForKey:@"moodicon"] objectAtIndex:indexPath.row]];
        float strProgress;
        if(strProgressValue == nil || strProgressValue == NULL || [strProgressValue isEqualToString:@""] || [strProgressValue isKindOfClass:[NSNull class]] || [strProgressValue isEqualToString:@"<null>"])
        {
            strProgress=0.0/100;
            strProgressValue=@"0";
        }
        else
        {
            strProgress=[[[[arrayStoryData valueForKey:@"Story"] valueForKey:@"moodicon"] objectAtIndex:indexPath.row] floatValue]/100;
        }
        
        // CircularProgressViews
        cellHome.ProgressHome2Emoji.delegate = self;
        cellHome.ProgressHome2Emoji.progressColor = self.view.tintColor;
        cellHome.ProgressHome2Emoji.progressColor = [UIColor colorWithRed:217.0 / 255.0 green:47.0 / 255.0 blue:78.0 / 255.0 alpha:1.0];
        cellHome.ProgressHome2Emoji.progressArcWidth = 3.0f;
        [cellHome.ProgressHome2Emoji setProgress:strProgress animated:YES];
        cellHome.lblHome2Feelings.text=[NSString stringWithFormat:@"Feeling a %@",strProgressValue];
        if([strProgressValue isEqualToString:@"0"] || [strProgressValue isEqualToString:@"1"] || [strProgressValue isEqualToString:@"2"] || [strProgressValue isEqualToString:@"3"] || [strProgressValue isEqualToString:@"4"] || [strProgressValue isEqualToString:@"5"])
        {
            cellHome.imgHome2Emoji.image=[UIImage imageNamed:@"01sad1"];
        }
        else if([strProgressValue isEqualToString:@"6"] || [strProgressValue isEqualToString:@"7"] || [strProgressValue isEqualToString:@"8"] || [strProgressValue isEqualToString:@"9"] || [strProgressValue isEqualToString:@"10"])
        {
            cellHome.imgHome2Emoji.image=[UIImage imageNamed:@"02sad1"];
        }
        else if([strProgressValue isEqualToString:@"11"] || [strProgressValue isEqualToString:@"12"] || [strProgressValue isEqualToString:@"13"] || [strProgressValue isEqualToString:@"14"] || [strProgressValue isEqualToString:@"15"])
        {
            cellHome.imgHome2Emoji.image=[UIImage imageNamed:@"03sad1"];
        }
        else if([strProgressValue isEqualToString:@"16"] || [strProgressValue isEqualToString:@"17"] || [strProgressValue isEqualToString:@"18"] || [strProgressValue isEqualToString:@"19"] || [strProgressValue isEqualToString:@"20"])
        {
            cellHome.imgHome2Emoji.image=[UIImage imageNamed:@"04sad1"];
        }
        else if([strProgressValue isEqualToString:@"21"] || [strProgressValue isEqualToString:@"22"] || [strProgressValue isEqualToString:@"23"] || [strProgressValue isEqualToString:@"24"] || [strProgressValue isEqualToString:@"25"])
        {
            cellHome.imgHome2Emoji.image=[UIImage imageNamed:@"05sad1"];
        }
        else if([strProgressValue isEqualToString:@"26"] || [strProgressValue isEqualToString:@"27"] || [strProgressValue isEqualToString:@"28"] || [strProgressValue isEqualToString:@"29"] || [strProgressValue isEqualToString:@"30"])
        {
            cellHome.imgHome2Emoji.image=[UIImage imageNamed:@"06sad1"];
        }
        else if([strProgressValue isEqualToString:@"31"] || [strProgressValue isEqualToString:@"32"] || [strProgressValue isEqualToString:@"33"] || [strProgressValue isEqualToString:@"34"] || [strProgressValue isEqualToString:@"35"])
        {
            cellHome.imgHome2Emoji.image=[UIImage imageNamed:@"07sad1"];
        }
        else if([strProgressValue isEqualToString:@"36"] || [strProgressValue isEqualToString:@"37"] || [strProgressValue isEqualToString:@"38"] || [strProgressValue isEqualToString:@"39"] || [strProgressValue isEqualToString:@"40"])
        {
            cellHome.imgHome2Emoji.image=[UIImage imageNamed:@"08sad1"];
        }
        else if([strProgressValue isEqualToString:@"41"] || [strProgressValue isEqualToString:@"42"] || [strProgressValue isEqualToString:@"43"] || [strProgressValue isEqualToString:@"44"] || [strProgressValue isEqualToString:@"45"])
        {
            cellHome.imgHome2Emoji.image=[UIImage imageNamed:@"09sad1"];
        }
        else if([strProgressValue isEqualToString:@"46"] || [strProgressValue isEqualToString:@"47"] || [strProgressValue isEqualToString:@"48"] || [strProgressValue isEqualToString:@"49"] || [strProgressValue isEqualToString:@"50"])
        {
            cellHome.imgHome2Emoji.image=[UIImage imageNamed:@"10sad1"];
        }
        else if([strProgressValue isEqualToString:@"51"] || [strProgressValue isEqualToString:@"52"] || [strProgressValue isEqualToString:@"53"] || [strProgressValue isEqualToString:@"54"] || [strProgressValue isEqualToString:@"55"])
        {
            cellHome.imgHome2Emoji.image=[UIImage imageNamed:@"11sad1"];
        }
        else if([strProgressValue isEqualToString:@"56"] || [strProgressValue isEqualToString:@"57"] || [strProgressValue isEqualToString:@"58"] || [strProgressValue isEqualToString:@"59"] || [strProgressValue isEqualToString:@"60"])
        {
            cellHome.imgHome2Emoji.image=[UIImage imageNamed:@"12happy1"];
        }
        else if([strProgressValue isEqualToString:@"61"] || [strProgressValue isEqualToString:@"62"] || [strProgressValue isEqualToString:@"63"] || [strProgressValue isEqualToString:@"64"] || [strProgressValue isEqualToString:@"65"])
        {
            cellHome.imgHome2Emoji.image=[UIImage imageNamed:@"13happy1"];
        }
        else if([strProgressValue isEqualToString:@"66"] || [strProgressValue isEqualToString:@"67"] || [strProgressValue isEqualToString:@"68"] || [strProgressValue isEqualToString:@"69"] || [strProgressValue isEqualToString:@"70"])
        {
            cellHome.imgHome2Emoji.image=[UIImage imageNamed:@"14happy1"];
        }
        else if([strProgressValue isEqualToString:@"71"] || [strProgressValue isEqualToString:@"72"] || [strProgressValue isEqualToString:@"73"] || [strProgressValue isEqualToString:@"74"] || [strProgressValue isEqualToString:@"75"])
        {
            cellHome.imgHome2Emoji.image=[UIImage imageNamed:@"15happy1"];
        }
        else if([strProgressValue isEqualToString:@"76"] || [strProgressValue isEqualToString:@"77"] || [strProgressValue isEqualToString:@"78"] || [strProgressValue isEqualToString:@"79"] || [strProgressValue isEqualToString:@"80"])
        {
            cellHome.imgHome2Emoji.image=[UIImage imageNamed:@"16happy1"];
        }
        else if([strProgressValue isEqualToString:@"81"] || [strProgressValue isEqualToString:@"82"] || [strProgressValue isEqualToString:@"83"] || [strProgressValue isEqualToString:@"84"] || [strProgressValue isEqualToString:@"85"])
        {
            cellHome.imgHome2Emoji.image=[UIImage imageNamed:@"17happy1"];
        }
        else if([strProgressValue isEqualToString:@"86"] || [strProgressValue isEqualToString:@"87"] || [strProgressValue isEqualToString:@"88"] || [strProgressValue isEqualToString:@"89"] || [strProgressValue isEqualToString:@"90"])
        {
            cellHome.imgHome2Emoji.image=[UIImage imageNamed:@"18happy1"];
        }
        else if([strProgressValue isEqualToString:@"91"] || [strProgressValue isEqualToString:@"92"] || [strProgressValue isEqualToString:@"93"] || [strProgressValue isEqualToString:@"94"] || [strProgressValue isEqualToString:@"95"])
        {
            cellHome.imgHome2Emoji.image=[UIImage imageNamed:@"19happy1"];
        }
        else //if([strValue isEqualToString:@"96"] || [strValue isEqualToString:@"97"] || [strValue isEqualToString:@"98"] || [strValue isEqualToString:@"99"] || [strValue isEqualToString:@"100"])
        {
            cellHome.imgHome2Emoji.image=[UIImage imageNamed:@"20happy1"];
        }
        
        return cellHome;
    }
    else
    {
        static NSString *MyIdentifier = @"HomeCell_3";
        HomeCell_3 *cellHome = (HomeCell_3 *)[_tblSearch dequeueReusableCellWithIdentifier:MyIdentifier];
        
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
        
        NSString *strTime=[NSString stringWithFormat:@"%@",[[[arrayStoryData valueForKey:@"Story"] valueForKey:@"modified"] objectAtIndex:indexPath.row]];
        
        //NSString *myString = @"2012-11-22 10:19:04";
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *yourDate1 = [dateFormatter dateFromString:strTime];
        dateFormatter.dateFormat = @"hh:mm aaa";
        NSLog(@"%@",[dateFormatter stringFromDate:yourDate1]);
        
        NSString *strFinalTime = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:yourDate1]];
        NSLog(@"%@",strFinalTime);
        
        cellHome.lblHome3Time.text = [strFinalTime uppercaseString];
        
        // _lblDayTime.text = [arrayDayTime objectAtIndex:indexPath.row];
        //_lblToday.text = [arrayToday objectAtIndex:indexPath.row];
        
        NSString *plainText = [[[arrayStoryData valueForKey:@"Story"] valueForKey:@"description"] objectAtIndex:indexPath.row];
        NSString *key = @"9B307D9DB5EAA3E360338F9AD4218D7E";
        NSString *iv = @"8FB1A2080C648F95";
        
        //CryptLib *cryptoLib = [[CryptLib alloc] init];
        
        //NSString *decryptedString = [cryptoLib decryptCipherTextWith:plainText key:key iv:iv];
        
        //NSLog(@"decryptedString %@", decryptedString);
        
        cellHome.lblHome3Description.text=[[[arrayStoryData valueForKey:@"Story"] valueForKey:@"description"] objectAtIndex:indexPath.row];
        
        cellHome.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *strProgressValue=[NSString stringWithFormat:@"%@",[[[arrayStoryData valueForKey:@"Story"] valueForKey:@"moodicon"] objectAtIndex:indexPath.row]];
        float strProgress;
        if(strProgressValue == nil || strProgressValue == NULL || [strProgressValue isEqualToString:@""] || [strProgressValue isKindOfClass:[NSNull class]] || [strProgressValue isEqualToString:@"<null>"])
        {
            strProgress=0.0/100;
            strProgressValue=@"0";
        }
        else
        {
            strProgress=[[[[arrayStoryData valueForKey:@"Story"] valueForKey:@"moodicon"] objectAtIndex:indexPath.row] floatValue]/100;
        }
        
        // CircularProgressViews
        cellHome.ProgressHome3Emoji.delegate = self;
        cellHome.ProgressHome3Emoji.progressColor = self.view.tintColor;
        cellHome.ProgressHome3Emoji.progressColor = [UIColor colorWithRed:217.0 / 255.0 green:47.0 / 255.0 blue:78.0 / 255.0 alpha:1.0];
        cellHome.ProgressHome3Emoji.progressArcWidth = 3.0f;
        [cellHome.ProgressHome3Emoji setProgress:strProgress animated:YES];
        cellHome.lblHome3Feelings.text=[NSString stringWithFormat:@"Feeling a %@",strProgressValue];
        if([strProgressValue isEqualToString:@"0"] || [strProgressValue isEqualToString:@"1"] || [strProgressValue isEqualToString:@"2"] || [strProgressValue isEqualToString:@"3"] || [strProgressValue isEqualToString:@"4"] || [strProgressValue isEqualToString:@"5"])
        {
            cellHome.imgHome3Emoji.image=[UIImage imageNamed:@"01sad1"];
        }
        else if([strProgressValue isEqualToString:@"6"] || [strProgressValue isEqualToString:@"7"] || [strProgressValue isEqualToString:@"8"] || [strProgressValue isEqualToString:@"9"] || [strProgressValue isEqualToString:@"10"])
        {
            cellHome.imgHome3Emoji.image=[UIImage imageNamed:@"02sad1"];
        }
        else if([strProgressValue isEqualToString:@"11"] || [strProgressValue isEqualToString:@"12"] || [strProgressValue isEqualToString:@"13"] || [strProgressValue isEqualToString:@"14"] || [strProgressValue isEqualToString:@"15"])
        {
            cellHome.imgHome3Emoji.image=[UIImage imageNamed:@"03sad1"];
        }
        else if([strProgressValue isEqualToString:@"16"] || [strProgressValue isEqualToString:@"17"] || [strProgressValue isEqualToString:@"18"] || [strProgressValue isEqualToString:@"19"] || [strProgressValue isEqualToString:@"20"])
        {
            cellHome.imgHome3Emoji.image=[UIImage imageNamed:@"04sad1"];
        }
        else if([strProgressValue isEqualToString:@"21"] || [strProgressValue isEqualToString:@"22"] || [strProgressValue isEqualToString:@"23"] || [strProgressValue isEqualToString:@"24"] || [strProgressValue isEqualToString:@"25"])
        {
            cellHome.imgHome3Emoji.image=[UIImage imageNamed:@"05sad1"];
        }
        else if([strProgressValue isEqualToString:@"26"] || [strProgressValue isEqualToString:@"27"] || [strProgressValue isEqualToString:@"28"] || [strProgressValue isEqualToString:@"29"] || [strProgressValue isEqualToString:@"30"])
        {
            cellHome.imgHome3Emoji.image=[UIImage imageNamed:@"06sad1"];
        }
        else if([strProgressValue isEqualToString:@"31"] || [strProgressValue isEqualToString:@"32"] || [strProgressValue isEqualToString:@"33"] || [strProgressValue isEqualToString:@"34"] || [strProgressValue isEqualToString:@"35"])
        {
            cellHome.imgHome3Emoji.image=[UIImage imageNamed:@"07sad1"];
        }
        else if([strProgressValue isEqualToString:@"36"] || [strProgressValue isEqualToString:@"37"] || [strProgressValue isEqualToString:@"38"] || [strProgressValue isEqualToString:@"39"] || [strProgressValue isEqualToString:@"40"])
        {
            cellHome.imgHome3Emoji.image=[UIImage imageNamed:@"08sad1"];
        }
        else if([strProgressValue isEqualToString:@"41"] || [strProgressValue isEqualToString:@"42"] || [strProgressValue isEqualToString:@"43"] || [strProgressValue isEqualToString:@"44"] || [strProgressValue isEqualToString:@"45"])
        {
            cellHome.imgHome3Emoji.image=[UIImage imageNamed:@"09sad1"];
        }
        else if([strProgressValue isEqualToString:@"46"] || [strProgressValue isEqualToString:@"47"] || [strProgressValue isEqualToString:@"48"] || [strProgressValue isEqualToString:@"49"] || [strProgressValue isEqualToString:@"50"])
        {
            cellHome.imgHome3Emoji.image=[UIImage imageNamed:@"10sad1"];
        }
        else if([strProgressValue isEqualToString:@"51"] || [strProgressValue isEqualToString:@"52"] || [strProgressValue isEqualToString:@"53"] || [strProgressValue isEqualToString:@"54"] || [strProgressValue isEqualToString:@"55"])
        {
            cellHome.imgHome3Emoji.image=[UIImage imageNamed:@"11sad1"];
        }
        else if([strProgressValue isEqualToString:@"56"] || [strProgressValue isEqualToString:@"57"] || [strProgressValue isEqualToString:@"58"] || [strProgressValue isEqualToString:@"59"] || [strProgressValue isEqualToString:@"60"])
        {
            cellHome.imgHome3Emoji.image=[UIImage imageNamed:@"12happy1"];
        }
        else if([strProgressValue isEqualToString:@"61"] || [strProgressValue isEqualToString:@"62"] || [strProgressValue isEqualToString:@"63"] || [strProgressValue isEqualToString:@"64"] || [strProgressValue isEqualToString:@"65"])
        {
            cellHome.imgHome3Emoji.image=[UIImage imageNamed:@"13happy1"];
        }
        else if([strProgressValue isEqualToString:@"66"] || [strProgressValue isEqualToString:@"67"] || [strProgressValue isEqualToString:@"68"] || [strProgressValue isEqualToString:@"69"] || [strProgressValue isEqualToString:@"70"])
        {
            cellHome.imgHome3Emoji.image=[UIImage imageNamed:@"14happy1"];
        }
        else if([strProgressValue isEqualToString:@"71"] || [strProgressValue isEqualToString:@"72"] || [strProgressValue isEqualToString:@"73"] || [strProgressValue isEqualToString:@"74"] || [strProgressValue isEqualToString:@"75"])
        {
            cellHome.imgHome3Emoji.image=[UIImage imageNamed:@"15happy1"];
        }
        else if([strProgressValue isEqualToString:@"76"] || [strProgressValue isEqualToString:@"77"] || [strProgressValue isEqualToString:@"78"] || [strProgressValue isEqualToString:@"79"] || [strProgressValue isEqualToString:@"80"])
        {
            cellHome.imgHome3Emoji.image=[UIImage imageNamed:@"16happy1"];
        }
        else if([strProgressValue isEqualToString:@"81"] || [strProgressValue isEqualToString:@"82"] || [strProgressValue isEqualToString:@"83"] || [strProgressValue isEqualToString:@"84"] || [strProgressValue isEqualToString:@"85"])
        {
            cellHome.imgHome3Emoji.image=[UIImage imageNamed:@"17happy1"];
        }
        else if([strProgressValue isEqualToString:@"86"] || [strProgressValue isEqualToString:@"87"] || [strProgressValue isEqualToString:@"88"] || [strProgressValue isEqualToString:@"89"] || [strProgressValue isEqualToString:@"90"])
        {
            cellHome.imgHome3Emoji.image=[UIImage imageNamed:@"18happy1"];
        }
        else if([strProgressValue isEqualToString:@"91"] || [strProgressValue isEqualToString:@"92"] || [strProgressValue isEqualToString:@"93"] || [strProgressValue isEqualToString:@"94"] || [strProgressValue isEqualToString:@"95"])
        {
            cellHome.imgHome3Emoji.image=[UIImage imageNamed:@"19happy1"];
        }
        else //if([strValue isEqualToString:@"96"] || [strValue isEqualToString:@"97"] || [strValue isEqualToString:@"98"] || [strValue isEqualToString:@"99"] || [strValue isEqualToString:@"100"])
        {
            cellHome.imgHome3Emoji.image=[UIImage imageNamed:@"20happy1"];
        }
        
        return cellHome;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.tblSearch.contentOffset.y >= (self.tblSearch.contentSize.height - self.tblSearch.bounds.size.height))
    {
        if(isPageRefreshing==NO){
            isPageRefreshing=YES;
            //[appDelegate showIndicator:nil view1:self.view];
            page++;
            [self getStoryList];
            [self.tblSearch reloadData];
            NSLog(@"called %d",page);
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",[arrayStoryData objectAtIndex:indexPath.row]);
    
    PostDetailVC *PostDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PostDetailVC"];
    PostDetailVC.arrayHomeData=[arrayStoryData objectAtIndex:indexPath.row];
    [self presentViewController:PostDetailVC animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  400;
}

#pragma mark WSCalendarViewDelegate

-(NSArray *)setupEventForDate{
    return eventArray;
}

-(void)didTapLabel:(WSLabel *)lblView withDate:(NSDate *)selectedDate
{
    
}

-(void)deactiveWSCalendarWithDate:(NSDate *)selectedDate
{
    NSDateFormatter *monthFormatter=[[NSDateFormatter alloc] init];
    [monthFormatter setDateFormat:@"dd MMMM yyyy"];
    NSString *str=[monthFormatter stringFromDate:selectedDate];
    //self.txtCalender.text = str;
}

- (IBAction)hideKeyboard:(id)sender
{
    [self.view endEditing:NO];
}

- (IBAction)btnClickedSearch:(id)sender
{
    _viewHeader.hidden=YES;
    _btnObjHeader.enabled=NO;
    _viewSearch.hidden=NO;
}
- (IBAction)btnClickedHeader:(id)sender
{
    [calendarView ActiveCalendar:self.view];
}
- (IBAction)btnClikcedSearchDone:(id)sender
{
    [self showMBProgressWithShow:YES];
    
    arrayStoryData=[[NSMutableArray alloc]init];
    arrayStoryList=[[NSMutableArray alloc]init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *strUrl=[NSString stringWithFormat:@"%@stories?token=%@&keyword=%@&id=%d",API_SERVER_URL,strUserToken,_txtSearch.text,page];
    
    [manager GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         Boolean Status=[[responseObject valueForKey:@"success"]boolValue];
         if(Status==1)
         {
             [arrayStoryData addObjectsFromArray:[responseObject objectForKey:@"data"]];
             [arrayStoryList addObjectsFromArray:arrayStoryData];
             [_txtSearch resignFirstResponder];
             _txtSearch.text=@"";
             _viewHeader.hidden=NO;
             _btnObjHeader.enabled=YES;
             _viewSearch.hidden=YES;
             [_tblSearch reloadData];
             [self showMBProgressWithShow:NO];
         }
         else
         {
             _viewHeader.hidden=YES;
             _btnObjHeader.enabled=NO;
             _viewSearch.hidden=NO;
             [_tblSearch reloadData];
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

#pragma mark Custom Methods ::

-(void)getStoryList
{
    [self showMBProgressWithShow:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *strUrl=[NSString stringWithFormat:@"%@stories?token=%@&page=%d",API_SERVER_URL,strUserToken,page];
    
    [manager GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         Boolean Status=[[responseObject valueForKey:@"success"]boolValue];
         if(Status==1)
         {
             [arrayStoryData addObjectsFromArray:[responseObject objectForKey:@"data"]];
             [arrayStoryList addObjectsFromArray:arrayStoryData];
             [_tblSearch reloadData];
             [self showMBProgressWithShow:NO];
         }
         else
         {
             [_tblSearch reloadData];
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
- (IBAction)btnClickedSearchBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}
@end
