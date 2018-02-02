//
//  PostDetailVC.h
//  rylfct
//
//  Created by promptmac on 10/01/18.
//  Copyright © 2018 Prompt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMPZoomTransitionAnimator.h"
#import "MRCircularProgressView.h"

@interface PostDetailVC : UIViewController<RMPZoomTransitionAnimating, RMPZoomTransitionDelegate>{
    
}
@property (nonatomic,weak) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UIImageView *imgCancel;

@property (strong ,nonatomic) NSMutableArray *arrayHomeData;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionHomeDetails;
@property (weak, nonatomic) IBOutlet UIPageControl *pagecontrollHomeDetails;
- (IBAction)PageControllClickedHomeDetails:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgMoods;
@property (weak, nonatomic) IBOutlet UILabel *lblHomeDetailsTime;
- (IBAction)btnClickedHomeDetailsShare:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblHomeDetaislFeelings;
@property (weak, nonatomic) IBOutlet UIImageView *imgHomeDetailsMoods;
@property (weak, nonatomic) IBOutlet MRCircularProgressView *progressHomeDetailsMoods;
@property (weak, nonatomic) IBOutlet UILabel *lblHomeDetailsDescrption;
@property (weak, nonatomic) IBOutlet UITextView *tvHomeDescptionDetails;

@property (nonatomic) NSUInteger index;
@end
