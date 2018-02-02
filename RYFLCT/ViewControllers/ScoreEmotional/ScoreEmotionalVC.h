//
//  ScoreEmotionalVC.h
//  RYFLCT
//
//  Created by Tops on 1/13/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreEmotionalVC : UIViewController
{
    
}

@property (weak, nonatomic) IBOutlet UITableView *tblScoreEmotional;
@property (weak, nonatomic) IBOutlet UILabel *lblScore;
@property (weak, nonatomic) IBOutlet UILabel *lblStories;
- (IBAction)btnClickedBack:(id)sender;


@end
