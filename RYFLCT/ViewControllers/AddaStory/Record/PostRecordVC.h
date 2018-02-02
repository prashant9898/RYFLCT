//
//  PostRecordVC.h
//  RYFLCT
//
//  Created by admin on 25/01/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface PostRecordVC : UIViewController<AVAudioPlayerDelegate,AVAudioRecorderDelegate>
{
    
}

@property (weak, nonatomic) IBOutlet UIView *viewRecordMain;
@property (weak, nonatomic) IBOutlet UILabel *lblMinute;
@property (weak, nonatomic) IBOutlet UILabel *lblHours;
@property (weak, nonatomic) IBOutlet UILabel *lblSecond;
@property (weak, nonatomic) IBOutlet UIImageView *imgRecord;
@property (weak, nonatomic) IBOutlet UIImageView *imgPlay;
@property (weak, nonatomic) IBOutlet UIImageView *imgSuffle;

- (IBAction)btnClickedRecord:(id)sender;
- (IBAction)btnClickedPlay:(id)sender;
- (IBAction)btnClickedSuffle:(id)sender;
- (IBAction)btnClickedDoneRecord:(id)sender;
- (IBAction)btnClickedClose:(id)sender;

@property (strong, nonatomic) AVAudioRecorder *audioRecorder;

@end
