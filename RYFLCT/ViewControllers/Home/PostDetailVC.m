//
//  PostDetailVC.m
//  rylfct
//
//  Created by promptmac on 10/01/18.
//  Copyright © 2018 Prompt. All rights reserved.
//

#import "PostDetailVC.h"
#import "CollectionViewHomeDetails_Cell.h"

@interface PostDetailVC ()

@end

@implementation PostDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*self.imgProfile.layer.cornerRadius = 10.0;
    self.imgProfile.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.imgProfile.layer.shadowOffset = CGSizeMake(0, 1);
    self.imgProfile.layer.shadowOpacity = 2;
    self.imgProfile.layer.shadowRadius = 2.0;
    self.imgProfile.clipsToBounds = NO;*/
    
    self.imgCancel.layer.cornerRadius = self.imgCancel.bounds.size.width/2;
    self.imgCancel.layer.masksToBounds = YES;
    
    NSLog(@"%@",_arrayHomeData);
    NSLog(@"%ld",[[_arrayHomeData valueForKey:@"StoryFile"]count]);
    
    NSString *strTime=[NSString stringWithFormat:@"%@",[[_arrayHomeData valueForKey:@"Story"] valueForKey:@"modified"] ];
    
    //NSString *myString = @"2012-11-22 10:19:04";
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *yourDate1 = [dateFormatter dateFromString:strTime];
    dateFormatter.dateFormat = @"hh:mm aaa";
    NSLog(@"%@",[dateFormatter stringFromDate:yourDate1]);
    
    NSString *strFinalTime = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:yourDate1]];
    NSLog(@"%@",strFinalTime);
    
    _lblHomeDetailsTime.text = [strFinalTime uppercaseString];
    
    _lblHomeDetailsDescrption.text=[[_arrayHomeData valueForKey:@"Story"] valueForKey:@"description"];
    _tvHomeDescptionDetails.text=[[_arrayHomeData valueForKey:@"Story"] valueForKey:@"description"];
    [self GetFellings];
    
    
    if([[_arrayHomeData valueForKey:@"StoryFile"]count] == 0)
    {
        NSString *strMoods=[NSString stringWithFormat:@"%@",[[_arrayHomeData valueForKey:@"Story"] valueForKey:@"heading"]];
        NSLog(@"%@",strMoods);
        
        NSString *strProgressValue=[NSString stringWithFormat:@"%@",[[_arrayHomeData valueForKey:@"Story"] valueForKey:@"moodicon"]];
        if([strMoods isEqualToString:@"Moods"])
        {
            //cellHome.imgHome.contentMode=UIViewContentModeScaleAspectFit;
             _imgMoods.hidden=NO;
            _imgProfile.hidden=YES;
            _imgProfile.contentMode=UIViewContentModeScaleAspectFit;
            _pagecontrollHomeDetails.hidden=NO;
            _pagecontrollHomeDetails.numberOfPages=1;
            if([strProgressValue isEqualToString:@"0"] || [strProgressValue isEqualToString:@"1"] || [strProgressValue isEqualToString:@"2"] || [strProgressValue isEqualToString:@"3"] || [strProgressValue isEqualToString:@"4"] || [strProgressValue isEqualToString:@"5"])
            {
                _imgMoods.image=[UIImage imageNamed:@"01sad"];
            }
            else if([strProgressValue isEqualToString:@"6"] || [strProgressValue isEqualToString:@"7"] || [strProgressValue isEqualToString:@"8"] || [strProgressValue isEqualToString:@"9"] || [strProgressValue isEqualToString:@"10"])
            {
                _imgMoods.image=[UIImage imageNamed:@"02sad"];
            }
            else if([strProgressValue isEqualToString:@"11"] || [strProgressValue isEqualToString:@"12"] || [strProgressValue isEqualToString:@"13"] || [strProgressValue isEqualToString:@"14"] || [strProgressValue isEqualToString:@"15"])
            {
                _imgMoods.image=[UIImage imageNamed:@"03sad"];
            }
            else if([strProgressValue isEqualToString:@"16"] || [strProgressValue isEqualToString:@"17"] || [strProgressValue isEqualToString:@"18"] || [strProgressValue isEqualToString:@"19"] || [strProgressValue isEqualToString:@"20"])
            {
                _imgMoods.image=[UIImage imageNamed:@"04sad"];
            }
            else if([strProgressValue isEqualToString:@"21"] || [strProgressValue isEqualToString:@"22"] || [strProgressValue isEqualToString:@"23"] || [strProgressValue isEqualToString:@"24"] || [strProgressValue isEqualToString:@"25"])
            {
                _imgMoods.image=[UIImage imageNamed:@"05sad"];
            }
            else if([strProgressValue isEqualToString:@"26"] || [strProgressValue isEqualToString:@"27"] || [strProgressValue isEqualToString:@"28"] || [strProgressValue isEqualToString:@"29"] || [strProgressValue isEqualToString:@"30"])
            {
                _imgMoods.image=[UIImage imageNamed:@"06sad"];
            }
            else if([strProgressValue isEqualToString:@"31"] || [strProgressValue isEqualToString:@"32"] || [strProgressValue isEqualToString:@"33"] || [strProgressValue isEqualToString:@"34"] || [strProgressValue isEqualToString:@"35"])
            {
                _imgMoods.image=[UIImage imageNamed:@"07sad"];
            }
            else if([strProgressValue isEqualToString:@"36"] || [strProgressValue isEqualToString:@"37"] || [strProgressValue isEqualToString:@"38"] || [strProgressValue isEqualToString:@"39"] || [strProgressValue isEqualToString:@"40"])
            {
                _imgMoods.image=[UIImage imageNamed:@"08sad"];
            }
            else if([strProgressValue isEqualToString:@"41"] || [strProgressValue isEqualToString:@"42"] || [strProgressValue isEqualToString:@"43"] || [strProgressValue isEqualToString:@"44"] || [strProgressValue isEqualToString:@"45"])
            {
                _imgMoods.image=[UIImage imageNamed:@"09sad"];
            }
            else if([strProgressValue isEqualToString:@"46"] || [strProgressValue isEqualToString:@"47"] || [strProgressValue isEqualToString:@"48"] || [strProgressValue isEqualToString:@"49"] || [strProgressValue isEqualToString:@"50"])
            {
                _imgMoods.image=[UIImage imageNamed:@"10sad"];
            }
            else if([strProgressValue isEqualToString:@"51"] || [strProgressValue isEqualToString:@"52"] || [strProgressValue isEqualToString:@"53"] || [strProgressValue isEqualToString:@"54"] || [strProgressValue isEqualToString:@"55"])
            {
                _imgMoods.image=[UIImage imageNamed:@"11sad"];
            }
            else if([strProgressValue isEqualToString:@"56"] || [strProgressValue isEqualToString:@"57"] || [strProgressValue isEqualToString:@"58"] || [strProgressValue isEqualToString:@"59"] || [strProgressValue isEqualToString:@"60"])
            {
                _imgMoods.image=[UIImage imageNamed:@"12happy"];
            }
            else if([strProgressValue isEqualToString:@"61"] || [strProgressValue isEqualToString:@"62"] || [strProgressValue isEqualToString:@"63"] || [strProgressValue isEqualToString:@"64"] || [strProgressValue isEqualToString:@"65"])
            {
                _imgMoods.image=[UIImage imageNamed:@"13happy"];
            }
            else if([strProgressValue isEqualToString:@"66"] || [strProgressValue isEqualToString:@"67"] || [strProgressValue isEqualToString:@"68"] || [strProgressValue isEqualToString:@"69"] || [strProgressValue isEqualToString:@"70"])
            {
                _imgMoods.image=[UIImage imageNamed:@"14happy"];
            }
            else if([strProgressValue isEqualToString:@"71"] || [strProgressValue isEqualToString:@"72"] || [strProgressValue isEqualToString:@"73"] || [strProgressValue isEqualToString:@"74"] || [strProgressValue isEqualToString:@"75"])
            {
                _imgMoods.image=[UIImage imageNamed:@"15happy"];
            }
            else if([strProgressValue isEqualToString:@"76"] || [strProgressValue isEqualToString:@"77"] || [strProgressValue isEqualToString:@"78"] || [strProgressValue isEqualToString:@"79"] || [strProgressValue isEqualToString:@"80"])
            {
                _imgMoods.image=[UIImage imageNamed:@"16happy"];
            }
            else if([strProgressValue isEqualToString:@"81"] || [strProgressValue isEqualToString:@"82"] || [strProgressValue isEqualToString:@"83"] || [strProgressValue isEqualToString:@"84"] || [strProgressValue isEqualToString:@"85"])
            {
                _imgMoods.image=[UIImage imageNamed:@"17happy"];
            }
            else if([strProgressValue isEqualToString:@"86"] || [strProgressValue isEqualToString:@"87"] || [strProgressValue isEqualToString:@"88"] || [strProgressValue isEqualToString:@"89"] || [strProgressValue isEqualToString:@"90"])
            {
                _imgMoods.image=[UIImage imageNamed:@"18happy"];
            }
            else if([strProgressValue isEqualToString:@"91"] || [strProgressValue isEqualToString:@"92"] || [strProgressValue isEqualToString:@"93"] || [strProgressValue isEqualToString:@"94"] || [strProgressValue isEqualToString:@"95"])
            {
                _imgMoods.image=[UIImage imageNamed:@"19happy"];
            }
            else //if([strValue isEqualToString:@"96"] || [strValue isEqualToString:@"97"] || [strValue isEqualToString:@"98"] || [strValue isEqualToString:@"99"] || [strValue isEqualToString:@"100"])
            {
                _imgMoods.image=[UIImage imageNamed:@"20happy"];
            }
            
        }
        else
        {
            //cellHome.imgHome.hidden=NO;
            _imgProfile.hidden=NO;
            _imgMoods.hidden=YES;
            //cellHome.imgHomeMoodsShow.contentMode=UIViewContentModeScaleAspectFit;
            _imgProfile.contentMode=UIViewContentModeScaleAspectFill;
            _imgProfile.image =[UIImage imageNamed:@"Image_5"];
        }
    }
    else
    {
        _collectionHomeDetails.hidden=NO;
        _imgProfile.hidden=YES;
        _imgMoods.hidden=YES;
        _pagecontrollHomeDetails.hidden=NO;
        _pagecontrollHomeDetails.numberOfPages=[[_arrayHomeData valueForKey:@"StoryFile"]count];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnCancelAction:(id)sender
{
   [self dismissViewControllerAnimated:YES completion:Nil];
}

#pragma mark - <RMPZoomTransitionAnimating>

- (UIImageView *)transitionSourceImageView
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.imgProfile.image];
    imageView.contentMode = self.imgProfile.contentMode;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = NO;
    imageView.frame = self.imgProfile.frame;
    return imageView;
}

- (UIColor *)transitionSourceBackgroundColor
{
    return self.view.backgroundColor;
}

- (CGRect)transitionDestinationImageViewFrame
{
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGRect frame = self.imgProfile.frame;
    frame.size.width = width;
    return frame;
}

#pragma mark - <RMPZoomTransitionDelegate>

- (void)zoomTransitionAnimator:(RMPZoomTransitionAnimator *)animator
         didCompleteTransition:(BOOL)didComplete
      animatingSourceImageView:(UIImageView *)imageView
{
    self.imgProfile.image = imageView.image;
}

#pragma mark UICollectionview Outlets ::

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[_arrayHomeData valueForKey:@"StoryFile"]count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewHomeDetails_Cell *cellCollectionViewHomeDetails = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewHomeDetails_Cell" forIndexPath:indexPath];
    
    //cellCollectionViewHomeDetails.imgDetailsShow.image = [UIImage imageNamed:[[_arrayHomeData valueForKey:@"StoryFile"] objectAtIndex:indexPath.row]];
    
    return cellCollectionViewHomeDetails;
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
    self.pagecontrollHomeDetails.currentPage =pageNum;
}
- (IBAction)PageControllClickedHomeDetails:(id)sender
{
    
}
- (IBAction)btnClickedHomeDetailsShare:(id)sender
{
    
}
-(void)GetFellings
{
    NSString *strProgressValue=[NSString stringWithFormat:@"%@",[[_arrayHomeData valueForKey:@"Story"] valueForKey:@"moodicon"]];
    
    float strProgress;
    if(strProgressValue == nil || strProgressValue == NULL || [strProgressValue isEqualToString:@""] || [strProgressValue isKindOfClass:[NSNull class]] || [strProgressValue isEqualToString:@"<null>"])
    {
        strProgress=0.0/100;
        strProgressValue=@"0";
    }
    else
    {
        strProgress=[[[_arrayHomeData valueForKey:@"Story"] valueForKey:@"moodicon"] floatValue]/100;
    }
    
    // CircularProgressViews
    _progressHomeDetailsMoods.delegate = self;
    _progressHomeDetailsMoods.progressColor = self.view.tintColor;
    _progressHomeDetailsMoods.progressColor = [UIColor colorWithRed:217.0 / 255.0 green:47.0 / 255.0 blue:78.0 / 255.0 alpha:1.0];
    _progressHomeDetailsMoods.progressArcWidth = 3.0f;
    
    [_progressHomeDetailsMoods setProgress:strProgress animated:YES];
    
    _lblHomeDetaislFeelings.text=[NSString stringWithFormat:@"Feeling a %@",strProgressValue];
    
    if([strProgressValue isEqualToString:@"0"] || [strProgressValue isEqualToString:@"1"] || [strProgressValue isEqualToString:@"2"] || [strProgressValue isEqualToString:@"3"] || [strProgressValue isEqualToString:@"4"] || [strProgressValue isEqualToString:@"5"])
    {
        _imgHomeDetailsMoods.image=[UIImage imageNamed:@"01sad1"];
    }
    else if([strProgressValue isEqualToString:@"6"] || [strProgressValue isEqualToString:@"7"] || [strProgressValue isEqualToString:@"8"] || [strProgressValue isEqualToString:@"9"] || [strProgressValue isEqualToString:@"10"])
    {
        _imgHomeDetailsMoods.image=[UIImage imageNamed:@"02sad1"];
    }
    else if([strProgressValue isEqualToString:@"11"] || [strProgressValue isEqualToString:@"12"] || [strProgressValue isEqualToString:@"13"] || [strProgressValue isEqualToString:@"14"] || [strProgressValue isEqualToString:@"15"])
    {
        _imgHomeDetailsMoods.image=[UIImage imageNamed:@"03sad1"];
    }
    else if([strProgressValue isEqualToString:@"16"] || [strProgressValue isEqualToString:@"17"] || [strProgressValue isEqualToString:@"18"] || [strProgressValue isEqualToString:@"19"] || [strProgressValue isEqualToString:@"20"])
    {
        _imgHomeDetailsMoods.image=[UIImage imageNamed:@"04sad1"];
    }
    else if([strProgressValue isEqualToString:@"21"] || [strProgressValue isEqualToString:@"22"] || [strProgressValue isEqualToString:@"23"] || [strProgressValue isEqualToString:@"24"] || [strProgressValue isEqualToString:@"25"])
    {
        _imgHomeDetailsMoods.image=[UIImage imageNamed:@"05sad1"];
    }
    else if([strProgressValue isEqualToString:@"26"] || [strProgressValue isEqualToString:@"27"] || [strProgressValue isEqualToString:@"28"] || [strProgressValue isEqualToString:@"29"] || [strProgressValue isEqualToString:@"30"])
    {
        _imgHomeDetailsMoods.image=[UIImage imageNamed:@"06sad1"];
    }
    else if([strProgressValue isEqualToString:@"31"] || [strProgressValue isEqualToString:@"32"] || [strProgressValue isEqualToString:@"33"] || [strProgressValue isEqualToString:@"34"] || [strProgressValue isEqualToString:@"35"])
    {
       _imgHomeDetailsMoods.image=[UIImage imageNamed:@"07sad1"];
    }
    else if([strProgressValue isEqualToString:@"36"] || [strProgressValue isEqualToString:@"37"] || [strProgressValue isEqualToString:@"38"] || [strProgressValue isEqualToString:@"39"] || [strProgressValue isEqualToString:@"40"])
    {
        _imgHomeDetailsMoods.image=[UIImage imageNamed:@"08sad1"];
    }
    else if([strProgressValue isEqualToString:@"41"] || [strProgressValue isEqualToString:@"42"] || [strProgressValue isEqualToString:@"43"] || [strProgressValue isEqualToString:@"44"] || [strProgressValue isEqualToString:@"45"])
    {
       _imgHomeDetailsMoods.image=[UIImage imageNamed:@"09sad1"];
    }
    else if([strProgressValue isEqualToString:@"46"] || [strProgressValue isEqualToString:@"47"] || [strProgressValue isEqualToString:@"48"] || [strProgressValue isEqualToString:@"49"] || [strProgressValue isEqualToString:@"50"])
    {
        _imgHomeDetailsMoods.image=[UIImage imageNamed:@"10sad1"];
    }
    else if([strProgressValue isEqualToString:@"51"] || [strProgressValue isEqualToString:@"52"] || [strProgressValue isEqualToString:@"53"] || [strProgressValue isEqualToString:@"54"] || [strProgressValue isEqualToString:@"55"])
    {
        _imgHomeDetailsMoods.image=[UIImage imageNamed:@"11sad1"];
    }
    else if([strProgressValue isEqualToString:@"56"] || [strProgressValue isEqualToString:@"57"] || [strProgressValue isEqualToString:@"58"] || [strProgressValue isEqualToString:@"59"] || [strProgressValue isEqualToString:@"60"])
    {
        _imgHomeDetailsMoods.image=[UIImage imageNamed:@"12happy1"];
    }
    else if([strProgressValue isEqualToString:@"61"] || [strProgressValue isEqualToString:@"62"] || [strProgressValue isEqualToString:@"63"] || [strProgressValue isEqualToString:@"64"] || [strProgressValue isEqualToString:@"65"])
    {
        _imgHomeDetailsMoods.image=[UIImage imageNamed:@"13happy1"];
    }
    else if([strProgressValue isEqualToString:@"66"] || [strProgressValue isEqualToString:@"67"] || [strProgressValue isEqualToString:@"68"] || [strProgressValue isEqualToString:@"69"] || [strProgressValue isEqualToString:@"70"])
    {
        _imgHomeDetailsMoods.image=[UIImage imageNamed:@"14happy1"];
    }
    else if([strProgressValue isEqualToString:@"71"] || [strProgressValue isEqualToString:@"72"] || [strProgressValue isEqualToString:@"73"] || [strProgressValue isEqualToString:@"74"] || [strProgressValue isEqualToString:@"75"])
    {
        _imgHomeDetailsMoods.image=[UIImage imageNamed:@"15happy1"];
    }
    else if([strProgressValue isEqualToString:@"76"] || [strProgressValue isEqualToString:@"77"] || [strProgressValue isEqualToString:@"78"] || [strProgressValue isEqualToString:@"79"] || [strProgressValue isEqualToString:@"80"])
    {
        _imgHomeDetailsMoods.image=[UIImage imageNamed:@"16happy1"];
    }
    else if([strProgressValue isEqualToString:@"81"] || [strProgressValue isEqualToString:@"82"] || [strProgressValue isEqualToString:@"83"] || [strProgressValue isEqualToString:@"84"] || [strProgressValue isEqualToString:@"85"])
    {
        _imgHomeDetailsMoods.image=[UIImage imageNamed:@"17happy1"];
    }
    else if([strProgressValue isEqualToString:@"86"] || [strProgressValue isEqualToString:@"87"] || [strProgressValue isEqualToString:@"88"] || [strProgressValue isEqualToString:@"89"] || [strProgressValue isEqualToString:@"90"])
    {
        _imgHomeDetailsMoods.image=[UIImage imageNamed:@"18happy1"];
    }
    else if([strProgressValue isEqualToString:@"91"] || [strProgressValue isEqualToString:@"92"] || [strProgressValue isEqualToString:@"93"] || [strProgressValue isEqualToString:@"94"] || [strProgressValue isEqualToString:@"95"])
    {
        _imgHomeDetailsMoods.image=[UIImage imageNamed:@"19happy1"];
    }
    else //if([strValue isEqualToString:@"96"] || [strValue isEqualToString:@"97"] || [strValue isEqualToString:@"98"] || [strValue isEqualToString:@"99"] || [strValue isEqualToString:@"100"])
    {
        _imgHomeDetailsMoods.image=[UIImage imageNamed:@"20happy1"];
    }
}

@end
