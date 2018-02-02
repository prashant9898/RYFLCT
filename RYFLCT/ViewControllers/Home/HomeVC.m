//
//  HomeVC.m
//  RYFLCT
//
//  Created by Tops on 1/11/18.
//  Copyright © 2018 Tops. All rights reserved.
//

//https://stackoverflow.com/questions/13911977/how-to-load-my-tableview-with-a-pagination
//http://uiroshan.github.io/2015/02/01/ios-uitableview-load-data-while-scrolling/

#import "HomeVC.h"
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
#import "SearchVC.h"


@interface HomeVC ()<UIViewControllerTransitioningDelegate>
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
    
    
#pragma mark Record View Outlets ::
    
    AVAudioPlayer *_audioPlayer;
    NSTimer *myTimer,*RecordTimer,*PlayRecordTimer;
    int currMinute;
    int currSeconds;
    int FlagRecord,FlagPlay;
    int FlagCheckStory;
    SFSpeechRecognizer *_recognizer;
    NSURL *outputFileURL;
    //SFSpeechRecognizer *speechRecognizer;
    SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
    SFSpeechRecognitionTask *recognitionTask;
    SFSpeechURLRecognitionRequest *urlRequest;
    
}

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_txtDayTime resignFirstResponder];
    FlagCheckStory=0;
    strUserToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"userToken"];
    
    arrayDayTime = [[NSMutableArray alloc]initWithObjects:@"MONDAY 22 JANUARY",@"MONDAY 22 JANUARY",@"MONDAY 22 JANUARY",@"SUNDAY 21 JANUARY",@"SUNDAY 21 JANUARY",@"SUNDAY 21 JANUARY",@"SATURDAY 20 JANUARY",@"FRIDAY 19 JANUARY",@"Thirsday 18 JANUARY",@"WEDNESDAY 17 JANUARY",nil];
    
     arrayToday = [[NSMutableArray alloc]initWithObjects:@"TODAY",@"TODAY",@"TODAY",@"YESTERDAY",@"YESTERDAY",@"YESTERDAY",@"PREVIOUS DAY",@"FRIDAY",@"THIRSDAY",@"WEDNESDAY",nil];
    
    //_lblDayTime.text = @"Monday 22 January";
    //_lblToday.text = @"Today";
    
    arrayHomedataList = [[NSMutableArray alloc]initWithObjects:@"Image_1",@"Image_2",@"Image_3",@"Image_4",@"Image_5",@"Image_1",@"Image_2",@"Image_3",@"Image_4",@"Image_5",nil];
    
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
    
    [_txtDayTime setInputView:NULL];
    
//    calendarViewEvent = [[[NSBundle mainBundle] loadNibNamed:@"WSCalendarView" owner:self options:nil] firstObject];
//    calendarViewEvent.calendarStyle = WSCalendarStyleView;
//    calendarViewEvent.isShowEvent=true;
//    calendarViewEvent.tappedDayBackgroundColor=[UIColor blackColor];
//    calendarViewEvent.frame = CGRectMake(0, 0, self.ContainerView.frame.size.width, self.ContainerView.frame.size.height);
//    [calendarViewEvent setupAppearance];
//    calendarViewEvent.delegate=self;
//    [self.ContainerView addSubview:calendarViewEvent];
    
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
    
    _viewMoodsSmily.layer.cornerRadius = 5;
    _viewMoodsSmily.layer.masksToBounds = YES;
    
    _viewRecordSecond.layer.cornerRadius = 5;
    _viewRecordSecond.layer.masksToBounds = YES;
    
    _viewRecordTraslate.layer.cornerRadius = 5;
    _viewRecordTraslate.layer.masksToBounds = YES;
    
    [_ProgressMoodsCount addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [_ProgressMoodsCount setThumbImage: [UIImage imageNamed:@"01sad1"] forState:UIControlStateNormal];
    
    //[_audioPlayer prepareToPlay];
    FlagRecord=0;
    FlagPlay=0;
    
    /*NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"sound.caf"];
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16],
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2],
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0],
                                    AVSampleRateKey,
                                    nil];
    
    NSError *error = nil;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                        error:nil];
    
    _audioRecorder = [[AVAudioRecorder alloc]
                      initWithURL:soundFileURL
                      settings:recordSettings
                      error:&error];
    
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
    } else {
        [_audioRecorder prepareToRecord];
    }*/
    // Set the audio file
    // _tvRecordTraslate.text = @" ";
    
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyAudioMemo.m4a",
                               nil];
    outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    _audioRecorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    _audioRecorder.delegate = self;
    _audioRecorder.meteringEnabled = YES;
    [_audioRecorder prepareToRecord];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    page=1;
    isPageRefreshing=NO;
    arrayStoryData=[[NSMutableArray alloc]init];
    arrayStoryList=[[NSMutableArray alloc]init];
    [self getStoryList];
}

- (IBAction)sliderValueChanged:(UISlider *)sender
{
    NSLog(@"slider value = %f", sender.value);
    
    NSString *strValue = [NSString stringWithFormat:@"%d",(int)sender.value];
    NSLog(@"Value %@",strValue);
    
    _lblMoodsProgressCount.text = [NSString stringWithFormat:@"%d",(int)sender.value];
    
    if([strValue isEqualToString:@"0"] || [strValue isEqualToString:@"1"] || [strValue isEqualToString:@"2"] || [strValue isEqualToString:@"3"] || [strValue isEqualToString:@"4"] || [strValue isEqualToString:@"5"])
    {
        [_ProgressMoodsCount setThumbImage: [UIImage imageNamed:@"01sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"6"] || [strValue isEqualToString:@"7"] || [strValue isEqualToString:@"8"] || [strValue isEqualToString:@"9"] || [strValue isEqualToString:@"10"])
    {
        [_ProgressMoodsCount setThumbImage: [UIImage imageNamed:@"02sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"11"] || [strValue isEqualToString:@"12"] || [strValue isEqualToString:@"13"] || [strValue isEqualToString:@"14"] || [strValue isEqualToString:@"15"])
    {
        [_ProgressMoodsCount setThumbImage: [UIImage imageNamed:@"03sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"16"] || [strValue isEqualToString:@"17"] || [strValue isEqualToString:@"18"] || [strValue isEqualToString:@"19"] || [strValue isEqualToString:@"20"])
    {
        [_ProgressMoodsCount setThumbImage: [UIImage imageNamed:@"04sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"21"] || [strValue isEqualToString:@"22"] || [strValue isEqualToString:@"23"] || [strValue isEqualToString:@"24"] || [strValue isEqualToString:@"25"])
    {
        [_ProgressMoodsCount setThumbImage: [UIImage imageNamed:@"05sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"26"] || [strValue isEqualToString:@"27"] || [strValue isEqualToString:@"28"] || [strValue isEqualToString:@"29"] || [strValue isEqualToString:@"30"])
    {
        [_ProgressMoodsCount setThumbImage: [UIImage imageNamed:@"06sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"31"] || [strValue isEqualToString:@"32"] || [strValue isEqualToString:@"33"] || [strValue isEqualToString:@"34"] || [strValue isEqualToString:@"35"])
    {
        [_ProgressMoodsCount setThumbImage: [UIImage imageNamed:@"07sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"36"] || [strValue isEqualToString:@"37"] || [strValue isEqualToString:@"38"] || [strValue isEqualToString:@"39"] || [strValue isEqualToString:@"40"])
    {
        [_ProgressMoodsCount setThumbImage: [UIImage imageNamed:@"08sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"41"] || [strValue isEqualToString:@"42"] || [strValue isEqualToString:@"43"] || [strValue isEqualToString:@"44"] || [strValue isEqualToString:@"45"])
    {
        [_ProgressMoodsCount setThumbImage: [UIImage imageNamed:@"09sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"46"] || [strValue isEqualToString:@"47"] || [strValue isEqualToString:@"48"] || [strValue isEqualToString:@"49"] || [strValue isEqualToString:@"50"])
    {
        [_ProgressMoodsCount setThumbImage: [UIImage imageNamed:@"10sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"51"] || [strValue isEqualToString:@"52"] || [strValue isEqualToString:@"53"] || [strValue isEqualToString:@"54"] || [strValue isEqualToString:@"55"])
    {
        [_ProgressMoodsCount setThumbImage: [UIImage imageNamed:@"11sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"56"] || [strValue isEqualToString:@"57"] || [strValue isEqualToString:@"58"] || [strValue isEqualToString:@"59"] || [strValue isEqualToString:@"60"])
    {
        [_ProgressMoodsCount setThumbImage: [UIImage imageNamed:@"12happy1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"61"] || [strValue isEqualToString:@"62"] || [strValue isEqualToString:@"63"] || [strValue isEqualToString:@"64"] || [strValue isEqualToString:@"65"])
    {
        [_ProgressMoodsCount setThumbImage: [UIImage imageNamed:@"13happy1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"66"] || [strValue isEqualToString:@"67"] || [strValue isEqualToString:@"68"] || [strValue isEqualToString:@"69"] || [strValue isEqualToString:@"70"])
    {
        [_ProgressMoodsCount setThumbImage: [UIImage imageNamed:@"14happy1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"71"] || [strValue isEqualToString:@"72"] || [strValue isEqualToString:@"73"] || [strValue isEqualToString:@"74"] || [strValue isEqualToString:@"75"])
    {
        [_ProgressMoodsCount setThumbImage: [UIImage imageNamed:@"15happy1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"76"] || [strValue isEqualToString:@"77"] || [strValue isEqualToString:@"78"] || [strValue isEqualToString:@"79"] || [strValue isEqualToString:@"80"])
    {
        [_ProgressMoodsCount setThumbImage: [UIImage imageNamed:@"16happy1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"81"] || [strValue isEqualToString:@"82"] || [strValue isEqualToString:@"83"] || [strValue isEqualToString:@"84"] || [strValue isEqualToString:@"85"])
    {
        [_ProgressMoodsCount setThumbImage: [UIImage imageNamed:@"17happy1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"86"] || [strValue isEqualToString:@"87"] || [strValue isEqualToString:@"88"] || [strValue isEqualToString:@"89"] || [strValue isEqualToString:@"90"])
    {
        [_ProgressMoodsCount setThumbImage: [UIImage imageNamed:@"18happy1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"91"] || [strValue isEqualToString:@"92"] || [strValue isEqualToString:@"93"] || [strValue isEqualToString:@"94"] || [strValue isEqualToString:@"95"])
    {
        [_ProgressMoodsCount setThumbImage: [UIImage imageNamed:@"19happy1"] forState:UIControlStateNormal];
    }
    else //if([strValue isEqualToString:@"96"] || [strValue isEqualToString:@"97"] || [strValue isEqualToString:@"98"] || [strValue isEqualToString:@"99"] || [strValue isEqualToString:@"100"])
    {
        [_ProgressMoodsCount setThumbImage: [UIImage imageNamed:@"20happy1"] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        HomeCell *cellHome = (HomeCell *)[_tblHome dequeueReusableCellWithIdentifier:MyIdentifier];
        
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
            HomeRecord_Cell *cellHomeRecord = (HomeRecord_Cell *)[_tblHome dequeueReusableCellWithIdentifier:MyIdentifier];
            
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
            HomeCell *cellHome = (HomeCell *)[_tblHome dequeueReusableCellWithIdentifier:MyIdentifier];
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
        HomeCell_2 *cellHome = (HomeCell_2 *)[_tblHome dequeueReusableCellWithIdentifier:MyIdentifier];
        
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
        HomeCell_3 *cellHome = (HomeCell_3 *)[_tblHome dequeueReusableCellWithIdentifier:MyIdentifier];
        
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
    if(self.tblHome.contentOffset.y >= (self.tblHome.contentSize.height - self.tblHome.bounds.size.height))
    {
        if(isPageRefreshing==NO){
            isPageRefreshing=YES;
            //[appDelegate showIndicator:nil view1:self.view];
            page++;
            [self getStoryList];
            [self.tblHome reloadData];
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
- (IBAction)btnClickedProfile:(id)sender
{
    EmootionalMeterVC *EmootionalMeterVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EmootionalMeterVC"];
    EmootionalMeterVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:EmootionalMeterVC animated:YES completion:nil];
}

- (IBAction)btnClickedText:(id)sender
{
    //PostTextVC *PostTextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GetStartedVC"];
    //[self.navigationController pushViewController:PostTextVC animated:YES];
    PostTextVC *PostTextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PostTextVC"];
    [self presentViewController:PostTextVC animated:YES completion:nil];
}

- (IBAction)btnClickedPhoto:(id)sender
{
    PostCameraVC *PostCameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PostCameraVC"];
    PostCameraVC.strCameraOrNot=@"Photo";
    [self presentViewController:PostCameraVC animated:YES completion:nil];
}

- (IBAction)btnClickedCamera:(id)sender
{
    PostCameraVC *PostCameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PostCameraVC"];
    PostCameraVC.strCameraOrNot=@"Camera";
    [self presentViewController:PostCameraVC animated:YES completion:nil];
}

- (IBAction)btnClickedRecord:(id)sender
{
    _viewRecord.hidden=NO;
}

- (IBAction)btnClickedSmily:(id)sender
{
    _viewMoods.hidden=NO;
}
- (IBAction)btnClickedDayTime:(id)sender
{
    [calendarView ActiveCalendar:self.view];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField==_txtDayTime)
    {
        [_txtDayTime resignFirstResponder];
        [self.view endEditing:YES];
        //_btnTrasparent.hidden=NO;
        [calendarView resignFirstResponder];
        [calendarView ActiveCalendar:textField];
    }
    else
    {
        
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
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

#pragma mark <RMPZoomTransitionAnimating>

- (UIImageView *)transitionSourceImageView
{
    NSIndexPath *selectedIndexPath = [self.tblHome indexPathForSelectedRow];
    HomeCell *cell = (HomeCell *)[self.tblHome cellForRowAtIndexPath:selectedIndexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:cell.imgHome.image];
    imageView.contentMode = cell.imgHome.contentMode;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = NO;
    CGRect frameInSuperview = [cell.imgHome convertRect:cell.frame toView:self.tblHome.superview];
    frameInSuperview.origin.x -= cell.layoutMargins.left;
    frameInSuperview.origin.y -= cell.layoutMargins.top;
    imageView.frame = frameInSuperview;
    return imageView;
}

- (UIColor *)transitionSourceBackgroundColor
{
    return self.tblHome.backgroundColor;
}

- (CGRect)transitionDestinationImageViewFrame
{
    NSIndexPath *selectedIndexPath = [self.tblHome indexPathForSelectedRow];
    HomeCell *cell = (HomeCell *)[self.tblHome cellForRowAtIndexPath:selectedIndexPath];
    CGRect frameInSuperview = [cell.imgHome convertRect:cell.imgHome.frame toView:cell];
    frameInSuperview.origin.x -= cell.layoutMargins.left;
    frameInSuperview.origin.y -= cell.layoutMargins.top;
    return frameInSuperview;
}

//#pragma mark - <RMPZoomTransitionAnimating>
//
//- (CGRect)transitionDestinationImageViewFrame
//{
//    NSIndexPath *selectedIndexPath = [[self.tblHome indexPathsForSelectedItems] firstObject];
//    HomeCell *cell = (HomeCell *)[self.tblHome cellForItemAtIndexPath:selectedIndexPath];
//    CGRect cellFrameInSuperview = [cell.imgHome convertRect:cell.imgHome.frame toView:self.collectionView.superview];
//    return cellFrameInSuperview;
//}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    UIViewController *vc = segue.destinationViewController;
    vc.transitioningDelegate = self;
}

#pragma mark - <UIViewControllerTransitioningDelegate>

#pragma mark - <UIViewControllerTransitioningDelegate>

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    id <RMPZoomTransitionAnimating, RMPZoomTransitionDelegate> sourceTransition = (id<RMPZoomTransitionAnimating, RMPZoomTransitionDelegate>)source;
    id <RMPZoomTransitionAnimating, RMPZoomTransitionDelegate> destinationTransition = (id<RMPZoomTransitionAnimating, RMPZoomTransitionDelegate>)presented;
    if ([sourceTransition conformsToProtocol:@protocol(RMPZoomTransitionAnimating)] &&
        [destinationTransition conformsToProtocol:@protocol(RMPZoomTransitionAnimating)]) {
        RMPZoomTransitionAnimator *animator = [[RMPZoomTransitionAnimator alloc] init];
        animator.goingForward = YES;
        animator.sourceTransition = sourceTransition;
        animator.destinationTransition = destinationTransition;
        return animator;
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    id <RMPZoomTransitionAnimating, RMPZoomTransitionDelegate> sourceTransition = (id<RMPZoomTransitionAnimating, RMPZoomTransitionDelegate>)dismissed;
    id <RMPZoomTransitionAnimating, RMPZoomTransitionDelegate> destinationTransition = (id<RMPZoomTransitionAnimating, RMPZoomTransitionDelegate>)self;
    if ([sourceTransition conformsToProtocol:@protocol(RMPZoomTransitionAnimating)] &&
        [destinationTransition conformsToProtocol:@protocol(RMPZoomTransitionAnimating)]) {
        RMPZoomTransitionAnimator *animator = [[RMPZoomTransitionAnimator alloc] init];
        animator.goingForward = NO;
        animator.sourceTransition = sourceTransition;
        animator.destinationTransition = destinationTransition;
        return animator;
    }
    return nil;
}

- (IBAction)btnClickedTrasparent:(id)sender
{
    
}
- (IBAction)btnClickedSearch:(id)sender
{
    SearchVC *SearchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchVC"];
    //EmootionalMeterVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:SearchVC animated:YES completion:nil];
}
- (IBAction)btnClickedDone:(id)sender
{
    _viewHeader.hidden=NO;
    _btnObjHeader.enabled=YES;
    _viewSearch.hidden=YES;
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
            [_tblHome reloadData];
            [self showMBProgressWithShow:NO];
        }
        else
        {
            [_tblHome reloadData];
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

- (IBAction)btnClickedMoodsDone:(id)sender
{
    [self showMBProgressWithShow:YES];
    NSString *plainText = _txtMoodsAddaStory.text;
    NSString *key = @"9B307D9DB5EAA3E360338F9AD4218D7E";
    NSString *iv = @"8FB1A2080C648F95";
    
    //CryptLib *cryptoLib = [[CryptLib alloc] init];
    
    //NSString *encryptedString = [cryptoLib encryptPlainTextWith:plainText key:key iv:iv];
    //NSLog(@"encryptedString %@", encryptedString);
    
    //NSString *decryptedString = [cryptoLib decryptCipherTextWith:encryptedString key:key iv:iv];
    // NSLog(@"decryptedString %@", decryptedString);
    
    NSDictionary *innerDict = @{
                                @"heading":@"Moods",
                                @"details":_txtMoodsAddaStory.text,
                                @"usertoken":strUserToken,
                                @"description":_txtMoodsAddaStory.text,
                                @"moodicon":_lblMoodsProgressCount.text
                                };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *strUrl=[NSString stringWithFormat:@"%@stories",API_SERVER_URL];
    [manager POST:strUrl parameters:innerDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         
     } success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         Boolean Status=[[responseObject valueForKey:@"success"]boolValue];
         if(Status==1)
         {
             [self showMBProgressWithShow:NO];
             _viewMoods.hidden=YES;
             //_lblMoodsProgressCount.text=@"0";
             //_ProgressMoodsCount.value
             page=1;
             isPageRefreshing=NO;
             arrayStoryData=[[NSMutableArray alloc]init];
             arrayStoryList=[[NSMutableArray alloc]init];
             [self getStoryList];
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
         [APP_DELEGATE showMBProgressWithShow:NO];
         NSLog(@"Error: %@", error);
         //  [APP_DELEGATE AlertMessage:@"Internal server error"];
     }];
}

- (IBAction)btnClickedMoodsClose:(id)sender
{
    _viewMoods.hidden=YES;
}
- (IBAction)btnObjClickedMoodsTrasparent:(id)sender
{
    _viewMoods.hidden=YES;
}

- (IBAction)btnClickedCloseRecord:(id)sender
{
    _viewRecord.hidden=YES;
    [_audioPlayer stop];
    [PlayRecordTimer invalidate];
    [_audioRecorder stop];
    [RecordTimer invalidate];
    _lblSeconds.text=@"00";
    _lblMinutes.text=@"00:";
    _lblHours.text=@"00:";
    _lblRemainigTime.text=@"00";
    FlagPlay=0;
    FlagRecord=0;
    _imgRecordViewRecord.image=[UIImage imageNamed:@"record a voice button_icon"];
    _imgRecordViewPlay.image=[UIImage imageNamed:@"play button_02"];
}

- (IBAction)btnClickedRecordViewRecord:(id)sender
{
    currSeconds=00;
    currMinute=00;
    FlagPlay=0;
    [_audioPlayer stop];
    [PlayRecordTimer invalidate];
    _lblRemainigTime.hidden=YES;
    _lblSeconds.hidden=NO;
    _lblMinutes.hidden=NO;
    _lblHours.hidden=NO;
    _lblRemainigTime.text=@"00";
    _imgRecordViewPlay.image=[UIImage imageNamed:@"play button_02"];
    if(FlagRecord==0)
    {
        FlagRecord=1;
        _imgRecordViewRecord.image=[UIImage imageNamed:@"square"];
        RecordTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
        if (!_audioRecorder.recording)
        {
            AVAudioSession *session = [AVAudioSession sharedInstance];
            [session setActive:YES error:nil];
            
            // Start recording
            [_audioRecorder record];
        }
    }
    else
    {
        FlagRecord=0;
        _lblSeconds.text=@"00";
        _lblMinutes.text=@"00:";
        _lblHours.text=@"00:";
        _imgRecordViewRecord.image=[UIImage imageNamed:@"record a voice button_icon"];
        [RecordTimer invalidate];
        if (_audioRecorder.recording)
        {
            [_audioRecorder stop];
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            [audioSession setActive:NO error:nil];
        }
        else if (_audioPlayer.playing) {
            [_audioPlayer stop];
        }
    }
}

-(void)timerFired
{
    currSeconds +=  1;
    NSString *stringseconds=[NSString stringWithFormat:@"0%d",currSeconds];
    _lblSeconds.text = stringseconds;
    if (currSeconds > 9) {
        _lblSeconds.text = [NSString stringWithFormat:@"%d",currSeconds];;
    }
    
    if (currSeconds == 60)
    {
        currSeconds = 1;
        currMinute += 1;
        //var stringm = String(format: "%d","%d", 0,minutes)
        _lblMinutes.text = [NSString stringWithFormat:@"0%d:",currMinute];
        if (currMinute > 9)
        {
            _lblMinutes.text = [NSString stringWithFormat:@"%d:",currMinute];
        }
        
        if (currMinute == 60)
        {
            currMinute = 0;
            /*hours += 1;
             lblHours.text = String(format:"0%d",hours)
             if hours > 9 {
             lblHours.text = String(hours)*/
        }
    }
    
}

- (IBAction)btnClickedRecordViewPlay:(id)sender
{
    [_audioRecorder stop];
    [RecordTimer invalidate];
    FlagRecord=0;
    _lblSeconds.text=@"00";
    _lblMinutes.text=@"00:";
    _lblHours.text=@"00:";
    _lblRemainigTime.hidden=NO;
    _lblSeconds.hidden=YES;
    _lblMinutes.hidden=YES;
    _lblHours.hidden=YES;
    _imgRecordViewRecord.image=[UIImage imageNamed:@"record a voice button_icon"];
    if(FlagPlay==0)
    {
        
        if (!_audioRecorder.recording)
        {
            NSError *error;
            _audioPlayer = [[AVAudioPlayer alloc]
                            initWithContentsOfURL:_audioRecorder.url
                            error:&error];
            _audioPlayer.delegate = self;
            if (error)
                NSLog(@"Error: %@",
                      [error localizedDescription]);
            else
                [_audioPlayer play];
            SFSpeechRecognizer *recognizer = [[SFSpeechRecognizer alloc] initWithLocale:[NSLocale localeWithLocaleIdentifier:@"en-IN"]];
            
            //Now it's part for request
            SFSpeechURLRecognitionRequest *request = [[SFSpeechURLRecognitionRequest alloc] initWithURL:outputFileURL];
            
            //
            [recognizer recognitionTaskWithRequest:request resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
                if(error != nil)
                {
                    NSLog(@"My Error:%@",error);
                }
                
                NSLog(@"My Test:%@",result.bestTranscription.formattedString);
                
                NSString *transcriptText = result.bestTranscription.formattedString;
                _tvRecordTraslate.text = [[NSString alloc] initWithFormat:@"%@",result.bestTranscription.formattedString];
                NSLog(@"%@",transcriptText);
                
            }];
            //_btnObjRecordDone.enabled=YES;
            _imgRecordViewPlay.image=[UIImage imageNamed:@"ic_pause_circle_outline"];
            FlagPlay=1;
            
            
            
            
            PlayRecordTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                               target:self
                                                             selector:@selector(PlayRecordTimer)
                                                             userInfo:nil
                                                              repeats:YES];
        }
    }
    else
    {
        FlagPlay=0;
        _imgRecordViewPlay.image=[UIImage imageNamed:@"play button_02"];
        [_audioPlayer pause];
        [PlayRecordTimer invalidate];
    }
}

-(void)PlayRecordTimer
{
    NSTimeInterval timeLeft = _audioPlayer.duration - _audioPlayer.currentTime;
//    cell.playSlider.value = _audioPlayer.currentTime / _audioPlayer.duration;
    _lblRemainigTime.text = [NSString stringWithFormat:@"-%@", [self convertTime:timeLeft]];
    
//    currSeconds +=  1;
//    NSString *stringseconds=[NSString stringWithFormat:@"0%d",currSeconds];
//    _lblSeconds.text = stringseconds;
//    if (currSeconds > 9) {
//        _lblSeconds.text = [NSString stringWithFormat:@"%d",currSeconds];;
//    }
//
//    if (currSeconds == 60)
//    {
//        currSeconds = 1;
//        currMinute += 1;
//        //var stringm = String(format: "%d","%d", 0,minutes)
//        _lblMinutes.text = [NSString stringWithFormat:@"0%d:",currMinute];
//        if (currMinute > 9)
//        {
//            _lblMinutes.text = [NSString stringWithFormat:@"%d:",currMinute];
//        }
//
//        if (currMinute == 60)
//        {
//            currMinute = 0;
//            /*hours += 1;
//             lblHours.text = String(format:"0%d",hours)
//             if hours > 9 {
//             lblHours.text = String(hours)*/
//        }
//    }
    
}

- (IBAction)btnClickedRecordViewCrop:(id)sender
{
    
}

- (IBAction)btnClickedRecordViewDone:(id)sender
{
    _viewRecord.hidden=YES;
    _viewMainRecordTraslate.hidden=NO;
    [_audioPlayer stop];
    [PlayRecordTimer invalidate];
    [_audioRecorder stop];
    [RecordTimer invalidate];
    _lblSeconds.text=@"00";
    _lblMinutes.text=@"00:";
    _lblHours.text=@"00:";
    _lblRemainigTime.text=@"00";
    FlagPlay=0;
    FlagRecord=0;
    _imgRecordViewRecord.image=[UIImage imageNamed:@"record a voice button_icon"];
    _imgRecordViewPlay.image=[UIImage imageNamed:@"play button_02"];
    
    /*NSURL *url = [[NSBundle mainBundle] URLForResource:@"MyAudioMemo" withExtension:@"m4a"];
    urlRequest = [[SFSpeechURLRecognitionRequest alloc] initWithURL:outputFileURL];
    recognitionTask = [_recognizer recognitionTaskWithRequest:urlRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        if (result != nil)
        {
            NSString *text = result.bestTranscription.formattedString;
            //_tvRecordText.text = text;
        }
        else
        {
            NSLog(@"Error, %@", error.description);
        }
    }];
    
    /*SFSpeechRecognizer *recognizer = [[SFSpeechRecognizer alloc] initWithLocale:[NSLocale localeWithLocaleIdentifier:@"en-IN"]];
    
    //Now it's part for request
    SFSpeechURLRecognitionRequest *request = [[SFSpeechURLRecognitionRequest alloc] initWithURL:outputFileURL];
    
    //
    [recognizer recognitionTaskWithRequest:request resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        if(error != nil)
        {
            NSLog(@"My Error:%@",error);
        }
        
        NSLog(@"My Test:%@",result.bestTranscription.formattedString);
        
        NSString *transcriptText = result.bestTranscription.formattedString;
        _tvRecordText.text = [[NSString alloc] initWithFormat:@"%@",result.bestTranscription.formattedString];
        NSLog(@"%@",transcriptText);
        
    }];*/

    
    /*_viewRecord.hidden=YES;
    [_audioPlayer stop];
    [PlayRecordTimer invalidate];
    [_audioRecorder stop];
    [RecordTimer invalidate];
    _lblSeconds.text=@"00";
    _lblMinutes.text=@"00:";
    _lblHours.text=@"00:";
    _lblRemainigTime.text=@"00";
    FlagPlay=0;
    FlagRecord=0;
    _imgRecordViewRecord.image=[UIImage imageNamed:@"record a voice button_icon"];
    _imgRecordViewPlay.image=[UIImage imageNamed:@"play button_02"];*/
}

#pragma mark - Private Functions

- (NSString*)convertTime:(NSInteger)time
{
    NSInteger minutes = time / 60;
    NSInteger seconds = time % 60;
    
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    
}

-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player{
    
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder
                          successfully:(BOOL)flag
{
    
}

-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"Encode Error occurred");
}

- (IBAction)btnClickedCloseRecordTraslate:(id)sender
{
    _viewRecord.hidden=NO;
    _viewMainRecordTraslate.hidden=YES;
    //_btnObjRecordDone.enabled=NO;
}

- (IBAction)btnClickedRecordTraslateAddStoryCheck:(id)sender
{
    if(FlagCheckStory==0)
    {
        FlagCheckStory=1;
        _imgCheckAddStory.image=[UIImage imageNamed:@"ic_check_box_checked"];
    }
    else
    {
        _imgCheckAddStory.image=[UIImage imageNamed:@"ic_check_box"];
        FlagCheckStory=0;
    }
}

- (IBAction)btnClickedUploadTextAndRecord:(id)sender
{
    [self showMBProgressWithShow:YES];
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc]
                          initWithContentsOfURL:_audioRecorder.url
                          error:&error];
    
    NSData *audio = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@",_audioPlayer]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *innerDict = @{@"heading":@"Record",
                                @"details":_tvRecordTraslate.text,
                                @"usertoken":strUserToken,
                                @"description":_tvRecordTraslate.text,
                                @"moodicon":@""
                                };
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"audio/mp4 m4a", nil];
    NSString *strUrl=[NSString stringWithFormat:@"%@stories",API_SERVER_URL];
    
    [manager POST:strUrl parameters:innerDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         if (audio)
         {
             [formData appendPartWithFileData:audio name:@"media1" fileName:@"MyAudioMemo.m4a" mimeType:@"audio/mp4 m4a"];
         }
     } success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         Boolean Status=[[responseObject valueForKey:@"success"]boolValue];
         if(Status==1)
         {
             [self showMBProgressWithShow:NO];
             _viewMainRecordTraslate.hidden=YES;
             //_lblMoodsProgressCount.text=@"0";
             //_ProgressMoodsCount.value
             page=1;
             isPageRefreshing=NO;
             arrayStoryData=[[NSMutableArray alloc]init];
             arrayStoryList=[[NSMutableArray alloc]init];
             [self getStoryList];
             
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
         [APP_DELEGATE showMBProgressWithShow:NO];
         NSLog(@"Error: %@", error);
         //  [APP_DELEGATE AlertMessage:@"Internal server error"];
     }];
    
}

@end
