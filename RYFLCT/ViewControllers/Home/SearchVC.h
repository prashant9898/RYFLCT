//
//  SearchVC.h
//  RYFLCT
//
//  Created by admin on 03/02/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSCalendarView.h"
#import "RMPZoomTransitionAnimator.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <Speech/Speech.h>

@interface SearchVC : UIViewController<WSCalendarViewDelegate,RMPZoomTransitionAnimating,AVAudioPlayerDelegate,AVAudioRecorderDelegate,SFSpeechRecognizerDelegate,AVSpeechSynthesizerDelegate>
{
    
}
@property (weak, nonatomic) IBOutlet UIView *ContainerView;
- (IBAction)btnClickedSearchBack:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblDayTime;
- (IBAction)btnClickedSearch:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblToday;
@property (weak, nonatomic) IBOutlet UIButton *btnObjHeader;
- (IBAction)btnClickedHeader:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewSearch;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
- (IBAction)btnClikcedSearchDone:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tblSearch;


@end
