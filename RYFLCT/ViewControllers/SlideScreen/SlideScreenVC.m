
//
//  SlideScreenVC.m
//  RYFLCT
//
//  Created by admin on 18/01/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import "SlideScreenVC.h"
#import "GetStartedVC.h"
#import "CollectionSlideScreen_Cell.h"

@interface SlideScreenVC ()
{
    UIViewController *currentVC;
    NSMutableArray *arrySlideScreen;
}
@end

@implementation SlideScreenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    currentVC = self;
    arrySlideScreen =[[NSMutableArray alloc]initWithObjects:@"Welcome_1",@"Welcome_2",@"Welcome_3",@"Welcome_4",@"Welcome_5",nil];
    
    /*ALScrollViewPaging *scrollView = [[ALScrollViewPaging alloc] initWithFrame:CGRectMake(20,30, 340, 600)];
    //array for views to add to the scrollview
    NSMutableArray *views = [[NSMutableArray alloc] init];
    //array for colors of views
    NSArray *colors = @[@"onboarding 01",
                        @"onboarding 02",
                        @"onboarding 03",
                        @"onboarding 04",
                        @"onboarding 05"];
    //cycle which creates views for the scrollview
    for (int i = 0; i < colors.count; i++) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 340, 600)];
        [view setImage:[UIImage imageNamed:[colors objectAtIndex:i]]];
        
        [views addObject:view];
    }
    
    //add pages to scrollview
    [scrollView addPages:views];
    
    //add scrollview to the view
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20 , 617, 335, 40)];
    [button setTitle:@"Get Started" forState:UIControlStateNormal];
    [button setFont:[UIFont fontWithName:@"Champagne & Limousines Bold" size:18.0]];
    [button addTarget:currentVC action:@selector(btnClickedGetStartedIn:)forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    [self.view addSubview:scrollView];
    
    [scrollView setHasPageControl:YES];*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrySlideScreen.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionSlideScreen_Cell *cellCollectionSlideScreen = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionSlideScreen_Cell" forIndexPath:indexPath];
    
    cellCollectionSlideScreen.imgSlide.image = [UIImage imageNamed:[arrySlideScreen objectAtIndex:indexPath.row]];
    
    cellCollectionSlideScreen.btnObjGetStarted.layer.cornerRadius = 5;
    cellCollectionSlideScreen.btnObjGetStarted.layer.masksToBounds = YES;
    
   [cellCollectionSlideScreen.btnObjGetStarted addTarget:currentVC action:@selector(btnClickedGetStartedCollection:)forControlEvents:UIControlEventTouchUpInside];
    
    return cellCollectionSlideScreen;
}

-(CGSize)collectionView:(UICollectionView *)collectionView
                 layout:(UICollectionViewLayout *)collectionViewLayout
 sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.bounds.size;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int pageNum = (int)(scrollView.contentOffset.x / scrollView.frame.size.width);
    self.pagecontrol.currentPage =pageNum;
}

-(void) btnClickedGetStartedCollection:(UIButton*)sender
{
    GetStartedVC *GetStartedVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GetStartedVC"];
    [self.navigationController pushViewController:GetStartedVC animated:YES];
}

- (IBAction)btnClickedGetStartedIn:(id)sender
{
    GetStartedVC *GetStartedVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GetStartedVC"];
    [self.navigationController pushViewController:GetStartedVC animated:YES];
}

- (IBAction)btnClickedGetStarted:(id)sender
{
    GetStartedVC *GetStartedVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GetStartedVC"];
    [self.navigationController pushViewController:GetStartedVC animated:YES];
}

- (IBAction)PageControlChange:(id)sender
{
    
}
@end
