//
//  PostTextVC.h
//  RYFLCT
//
//  Created by Tops on 1/13/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+YMSPhotoHelper.h"

@interface PostTextVC : UIViewController
{
    
}
- (IBAction)btnClickedBack:(id)sender;
- (IBAction)btnClickedTextPost:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *tvTextPost;
@property (weak, nonatomic) IBOutlet UIView *viewTextSmily;
@property (weak, nonatomic) IBOutlet UISlider *sliderTextSmily;
@property (weak, nonatomic) IBOutlet UILabel *lblTextSmilyScore;
- (IBAction)btnClickeTextCamera:(id)sender;
- (IBAction)btnClickedTextPhoto:(id)sender;
- (IBAction)btnClcikedTextRecord:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imgAddCameraText;
@property (weak, nonatomic) IBOutlet UIImageView *imgAddPhotoText;
@property (weak, nonatomic) IBOutlet UITableView *tblUploadText;

@property (weak, nonatomic) IBOutlet UITextField *txtAddaStoryUploadText;

@end
