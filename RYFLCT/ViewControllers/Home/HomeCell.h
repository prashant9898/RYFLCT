//
//  HomeCell.h
//  RYFLCT
//
//  Created by Tops on 1/11/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCircularProgressView.h"

@interface HomeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgHomeMoodsShow;

@property (weak, nonatomic) IBOutlet UIImageView *imgHome;
@property (weak, nonatomic) IBOutlet UIView *viewHome;
@property (weak, nonatomic) IBOutlet MRCircularProgressView *HomeSmilyProgress;
@property (weak, nonatomic) IBOutlet UILabel *lblHomeTime;
@property (weak, nonatomic) IBOutlet UILabel *lblHomeDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnObjHomeShare;
@property (weak, nonatomic) IBOutlet UILabel *lblHomeFeelings;
@property (weak, nonatomic) IBOutlet UIImageView *imgHomeEmoji;
@property (weak, nonatomic) IBOutlet UIImageView *imgBlackData;


#pragma mark Record Outlets::

@property (weak, nonatomic) IBOutlet UIView *viewDataRecord;
@property (weak, nonatomic) IBOutlet UITextView *tcRecordData;
@property (weak, nonatomic) IBOutlet UIView *viewRecordProgressData;
@property (weak, nonatomic) IBOutlet UISlider *progressRecordPlay;
@property (weak, nonatomic) IBOutlet UIButton *btnObjPlayRecord;


#pragma mark Score Emotional Outlets ::

@property (weak, nonatomic) IBOutlet UIView *viewScoreEmotional;
@property (weak, nonatomic) IBOutlet UIImageView *imgScoreEmotional;



@end
