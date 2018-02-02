//
//  TouchIdVC.h
//  RYFLCT
//
//  Created by admin on 24/01/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSplashView.h"

@interface TouchIdVC : UIViewController<SKSplashDelegate>
{
    
}

- (IBAction)btnClickedTouchId:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnObjTouchId;

- (IBAction)btnClickedBack:(id)sender;

@end
