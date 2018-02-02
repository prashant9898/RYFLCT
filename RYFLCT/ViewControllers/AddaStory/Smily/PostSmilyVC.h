//
//  PostSmilyVC.h
//  RYFLCT
//
//  Created by admin on 25/01/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostSmilyVC : UIViewController
{
    
}
@property (weak, nonatomic) IBOutlet UIView *viewSmily;
@property (weak, nonatomic) IBOutlet UITextField *txtAddaStory;
@property (weak, nonatomic) IBOutlet UILabel *lblSliderValue;
@property (weak, nonatomic) IBOutlet UISlider *sliderSmily;

- (IBAction)btnClickedClose:(id)sender;
- (IBAction)btnClickedDone:(id)sender;


@end
