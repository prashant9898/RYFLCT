//
//  HomeVC.h
//  RYFLCT
//
//  Created by Tops on 1/11/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSCalendarView.h"
#import "RMPZoomTransitionAnimator.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <Speech/Speech.h>

@interface HomeVC : UIViewController<WSCalendarViewDelegate,RMPZoomTransitionAnimating,AVAudioPlayerDelegate,AVAudioRecorderDelegate,SFSpeechRecognizerDelegate,AVSpeechSynthesizerDelegate>
{
    
}

@property (weak, nonatomic) IBOutlet UITableView *tblHome;

- (IBAction)btnClickedProfile:(id)sender;
- (IBAction)btnClickedText:(id)sender;
- (IBAction)btnClickedPhoto:(id)sender;
- (IBAction)btnClickedCamera:(id)sender;
- (IBAction)btnClickedRecord:(id)sender;
- (IBAction)btnClickedSmily:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblDayTime;
@property (weak, nonatomic) IBOutlet UILabel *lblToday;
- (IBAction)btnClickedDayTime:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtDayTime;
@property (weak, nonatomic) IBOutlet UIView *ContainerView;
@property (weak, nonatomic) IBOutlet UIButton *btnTrasparent;
- (IBAction)btnClickedTrasparent:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UIView *viewSearch;
- (IBAction)btnClickedSearch:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
- (IBAction)btnClickedDone:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnObjHeader;


#pragma mark Moods View Outlets ::

@property (weak, nonatomic) IBOutlet UIView *viewMoods;
- (IBAction)btnClickedMoodsDone:(id)sender;

- (IBAction)btnClickedMoodsClose:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtMoodsAddaStory;
@property (weak, nonatomic) IBOutlet UILabel *lblMoodsProgressCount;
@property (weak, nonatomic) IBOutlet UISlider *ProgressMoodsCount;
@property (weak, nonatomic) IBOutlet UIView *viewMoodsSmily;
@property (weak, nonatomic) IBOutlet UIButton *btnObjMoodsTrasparent;
- (IBAction)btnObjClickedMoodsTrasparent:(id)sender;



#pragma mark Record View Outlets ::

@property (weak, nonatomic) IBOutlet UIView *viewRecord;
- (IBAction)btnClickedCloseRecord:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewRecordSecond;
@property (weak, nonatomic) IBOutlet UILabel *lblHours;
@property (weak, nonatomic) IBOutlet UILabel *lblMinutes;
@property (weak, nonatomic) IBOutlet UILabel *lblSeconds;
@property (weak, nonatomic) IBOutlet UIImageView *imgRecordViewRecord;
- (IBAction)btnClickedRecordViewRecord:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imgRecordViewPlay;
- (IBAction)btnClickedRecordViewPlay:(id)sender;
- (IBAction)btnClickedRecordViewCrop:(id)sender;
- (IBAction)btnClickedRecordViewDone:(id)sender;
@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (weak, nonatomic) IBOutlet UILabel *lblRemainigTime;
@property (weak, nonatomic) IBOutlet UIButton *btnObjRecordDone;


#pragma mark Record To Text Outlets ::

@property (weak, nonatomic) IBOutlet UIView *viewMainRecordTraslate;
@property (weak, nonatomic) IBOutlet UIView *viewRecordTraslate;
@property (weak, nonatomic) IBOutlet UITextView *tvRecordTraslate;
@property (weak, nonatomic) IBOutlet UIImageView *imgCheckAddStory;
- (IBAction)btnClickedCloseRecordTraslate:(id)sender;
- (IBAction)btnClickedRecordTraslateAddStoryCheck:(id)sender;

- (IBAction)btnClickedUploadTextAndRecord:(id)sender;


@end
