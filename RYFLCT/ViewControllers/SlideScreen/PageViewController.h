//
//  PageViewController.h
//  RYFLCT
//
//  Created by Tops on 1/10/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageViewController : UIViewController{
    
}
// Item controller information
@property (nonatomic) NSUInteger itemIndex;
@property (nonatomic, strong) NSString *imageName;
- (IBAction)btnClickedGetStarted:(id)sender;

// IBOutlets
@property (nonatomic, weak) IBOutlet UIImageView *contentImageView;
@end
