//
//  SlideScreenVC.h
//  RYFLCT
//
//  Created by admin on 18/01/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALScrollViewPaging.h"

@interface SlideScreenVC : UIViewController
@property (weak, nonatomic) IBOutlet ALScrollViewPaging *scrollview;
@property (weak, nonatomic) IBOutlet UIImageView *img;
- (IBAction)btnClickedGetStarted:(id)sender;


@property (weak, nonatomic) IBOutlet UICollectionView *collectionSlideScreen;
@property (weak, nonatomic) IBOutlet UIPageControl *pagecontrol;
- (IBAction)PageControlChange:(id)sender;


@end
