//
//  PostCameraVC.h
//  RYFLCT
//
//  Created by admin on 15/01/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostCameraVC : UIViewController
{
    
}

- (IBAction)btnClickedBack:(id)sender;
- (IBAction)btnClickedCameraPost:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewCamera;
@property (weak, nonatomic) IBOutlet UISlider *CameraSlider;
@property (weak, nonatomic) IBOutlet UILabel *lblCameraCountEmozi;
- (IBAction)btnClickedCamera:(id)sender;
- (IBAction)btnClickedPhoto:(id)sender;
- (IBAction)btnClickedRecord:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imgCamera;
@property (weak, nonatomic) IBOutlet UITextField *txtCameraAddText;

@property (strong,nonatomic) NSString *strCameraOrNot;

@end
