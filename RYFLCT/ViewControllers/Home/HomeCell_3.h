//
//  HomeCell_3.h
//  RYFLCT
//
//  Created by admin on 28/01/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCircularProgressView.h"

@interface HomeCell_3 : UITableViewCell

#pragma mark Home Outlets ::

@property (weak, nonatomic) IBOutlet UIView *viewHomecell3;
@property (weak, nonatomic) IBOutlet UIImageView *imgHome1;
@property (weak, nonatomic) IBOutlet UIImageView *imgHome2;
@property (weak, nonatomic) IBOutlet UIImageView *imgHome3;
@property (weak, nonatomic) IBOutlet UILabel *lblHome3Time;
@property (weak, nonatomic) IBOutlet UILabel *lblHome3Description;
@property (weak, nonatomic) IBOutlet UIButton *btnObjHome3Share;
@property (weak, nonatomic) IBOutlet UILabel *lblHome3Feelings;
@property (weak, nonatomic) IBOutlet UIImageView *imgHome3Emoji;
@property (weak, nonatomic) IBOutlet MRCircularProgressView *ProgressHome3Emoji;
@property (weak, nonatomic) IBOutlet UILabel *lblHome3ImageCount;


@end
