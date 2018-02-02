
//
//  PostRecordVC.m
//  RYFLCT
//
//  Created by admin on 25/01/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import "PostRecordVC.h"

@interface PostRecordVC ()
{
    AVAudioPlayer *_audioPlayer;
    NSTimer *myTimer,*RecordTimer,*PlayRecordTimer;
    int currMinute;
    int currSeconds;
    int FlagRecord,FlagPlay;
}

@end

@implementation PostRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_audioPlayer prepareToPlay];
    _viewRecordMain.layer.cornerRadius = 5;
    _viewRecordMain.layer.masksToBounds = YES;
    FlagRecord=0;
    FlagPlay=0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClickedRecord:(id)sender
{
    currSeconds=00;
    currMinute=00;
    FlagPlay=0;
    [_audioPlayer stop];
    [PlayRecordTimer invalidate];
    
    if(FlagRecord==0)
    {
        FlagRecord=1;
        RecordTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
        if (!_audioRecorder.recording)
        {
            [_audioRecorder record];
        }
    }
    else
    {
        FlagRecord=0;
        _lblSecond.text=@"00";
        _lblMinute.text=@"00:";
        _lblHours.text=@"00:";
        [RecordTimer invalidate];
        if (_audioRecorder.recording)
        {
            [_audioRecorder stop];
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
    _lblSecond.text = stringseconds;
    if (currSeconds > 9) {
        _lblSecond.text = [NSString stringWithFormat:@"%d",currSeconds];;
    }
    
    if (currSeconds == 60)
    {
        currSeconds = 1;
        currMinute += 1;
        //var stringm = String(format: "%d","%d", 0,minutes)
        _lblMinute.text = [NSString stringWithFormat:@"0%d:",currMinute];
        if (currMinute > 9)
        {
            _lblMinute.text = [NSString stringWithFormat:@"%d:",currMinute];
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

- (IBAction)btnClickedPlay:(id)sender
{
    [_audioRecorder stop];
    [RecordTimer invalidate];
    FlagRecord=0;
    _lblSecond.text=@"00";
    _lblMinute.text=@"00:";
    _lblHours.text=@"00:";
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
        [_audioPlayer pause];
        [PlayRecordTimer invalidate];
    }
}

-(void)PlayRecordTimer
{
    currSeconds +=  1;
    NSString *stringseconds=[NSString stringWithFormat:@"0%d",currSeconds];
    _lblSecond.text = stringseconds;
    if (currSeconds > 9) {
        _lblSecond.text = [NSString stringWithFormat:@"%d",currSeconds];;
    }
    
    if (currSeconds == 60)
    {
        currSeconds = 1;
        currMinute += 1;
        //var stringm = String(format: "%d","%d", 0,minutes)
        _lblMinute.text = [NSString stringWithFormat:@"0%d:",currMinute];
        if (currMinute > 9)
        {
            _lblMinute.text = [NSString stringWithFormat:@"%d:",currMinute];
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

- (IBAction)btnClickedSuffle:(id)sender
{
    
}

- (IBAction)btnClickedDoneRecord:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (IBAction)btnClickedClose:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}
@end
