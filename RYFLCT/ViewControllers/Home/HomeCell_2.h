//
//  HomeCell_2.h
//  RYFLCT
//
//  Created by admin on 28/01/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCircularProgressView.h"

@interface HomeCell_2 : UITableViewCell

#pragma mark Home Outlets ::

@property (weak, nonatomic) IBOutlet UIView *viewHome2;
@property (weak, nonatomic) IBOutlet UIImageView *imgHome1;
@property (weak, nonatomic) IBOutlet UIImageView *imgHome2;
@property (weak, nonatomic) IBOutlet UILabel *lblHome2Time;
@property (weak, nonatomic) IBOutlet UILabel *lblHome2Description;
@property (weak, nonatomic) IBOutlet UIButton *btnObjHome2Share;
@property (weak, nonatomic) IBOutlet UILabel *lblHome2Feelings;
@property (weak, nonatomic) IBOutlet UIImageView *imgHome2Emoji;
@property (weak, nonatomic) IBOutlet MRCircularProgressView *ProgressHome2Emoji;


@end
