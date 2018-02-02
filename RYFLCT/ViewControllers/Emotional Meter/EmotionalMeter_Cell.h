//
//  EmotionalMeter_Cell.h
//  RYFLCT
//
//  Created by Tops on 1/13/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmotionalMeter_Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblKeywordName;
@property (weak, nonatomic) IBOutlet UILabel *lblStoriesCount;

@property (weak, nonatomic) IBOutlet UILabel *lblScoreName;
@property (weak, nonatomic) IBOutlet UILabel *lblScoreStoriesCount;



@end
