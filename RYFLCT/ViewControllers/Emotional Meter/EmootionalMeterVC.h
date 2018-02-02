//
//  EmootionalMeterVC.h
//  RYFLCT
//
//  Created by Tops on 1/13/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"

@interface EmootionalMeterVC : UIViewController<XYPieChartDelegate, XYPieChartDataSource>
{
    
}
- (IBAction)btnClickedSetting:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrEmotionalMeter;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblStories;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayFirst;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaySecond;
@property (weak, nonatomic) IBOutlet UILabel *lblTestThird;
@property (weak, nonatomic) IBOutlet UILabel *lblPhotoFourth;
@property (weak, nonatomic) IBOutlet UITableView *tblKeywords;
@property (weak, nonatomic) IBOutlet UITableView *tblScore;
@property (weak, nonatomic) IBOutlet UIView *KeywordView;
@property (weak, nonatomic) IBOutlet UIView *ScoreView;

- (IBAction)btnClickedBack:(id)sender;

@property (weak, nonatomic) IBOutlet XYPieChart *PiechartEmotional;

@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray        *sliceColors;


@end
