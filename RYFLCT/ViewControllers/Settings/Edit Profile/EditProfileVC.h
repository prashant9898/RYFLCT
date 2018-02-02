//
//  EditProfileVC.h
//  RYFLCT
//
//  Created by admin on 25/01/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProfileVC : UIViewController
{
    
}

- (IBAction)btnClickedBack:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtGender;
- (IBAction)btnClickedUpdate:(id)sender;
- (IBAction)btnClickedEditProfile:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;

@end
