//
//  RegisterVC.h
//  RYFLCT
//
//  Created by Tops on 1/10/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterVC : UIViewController
{
    
}
- (IBAction)btnClickedBack:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;
- (IBAction)btnClickedSignUp:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtGender;

- (IBAction)btnClickedTermsAndCondition:(id)sender;


@end
