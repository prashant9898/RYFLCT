
//
//  PostSmilyVC.m
//  RYFLCT
//
//  Created by admin on 25/01/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import "PostSmilyVC.h"
#import "HomeVC.h"

@interface PostSmilyVC ()

@end

@implementation PostSmilyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _viewSmily.layer.cornerRadius = 5;
    _viewSmily.layer.masksToBounds = YES;
    
    [_sliderSmily addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [_sliderSmily setThumbImage: [UIImage imageNamed:@"01sad1"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sliderValueChanged:(UISlider *)sender
{
    NSLog(@"slider value = %f", sender.value);
    
    NSString *strValue = [NSString stringWithFormat:@"%d",(int)sender.value];
    NSLog(@"Value %@",strValue);
    
    _lblSliderValue.text = [NSString stringWithFormat:@"%d",(int)sender.value];
    
    if([strValue isEqualToString:@"0"] || [strValue isEqualToString:@"1"] || [strValue isEqualToString:@"2"] || [strValue isEqualToString:@"3"] || [strValue isEqualToString:@"4"] || [strValue isEqualToString:@"5"])
    {
        [_sliderSmily setThumbImage: [UIImage imageNamed:@"01sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"6"] || [strValue isEqualToString:@"7"] || [strValue isEqualToString:@"8"] || [strValue isEqualToString:@"9"] || [strValue isEqualToString:@"10"])
    {
        [_sliderSmily setThumbImage: [UIImage imageNamed:@"02sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"11"] || [strValue isEqualToString:@"12"] || [strValue isEqualToString:@"13"] || [strValue isEqualToString:@"14"] || [strValue isEqualToString:@"15"])
    {
        [_sliderSmily setThumbImage: [UIImage imageNamed:@"03sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"16"] || [strValue isEqualToString:@"17"] || [strValue isEqualToString:@"18"] || [strValue isEqualToString:@"19"] || [strValue isEqualToString:@"20"])
    {
        [_sliderSmily setThumbImage: [UIImage imageNamed:@"04sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"21"] || [strValue isEqualToString:@"22"] || [strValue isEqualToString:@"23"] || [strValue isEqualToString:@"24"] || [strValue isEqualToString:@"25"])
    {
        [_sliderSmily setThumbImage: [UIImage imageNamed:@"05sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"26"] || [strValue isEqualToString:@"27"] || [strValue isEqualToString:@"28"] || [strValue isEqualToString:@"29"] || [strValue isEqualToString:@"30"])
    {
        [_sliderSmily setThumbImage: [UIImage imageNamed:@"06sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"31"] || [strValue isEqualToString:@"32"] || [strValue isEqualToString:@"33"] || [strValue isEqualToString:@"34"] || [strValue isEqualToString:@"35"])
    {
        [_sliderSmily setThumbImage: [UIImage imageNamed:@"07sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"36"] || [strValue isEqualToString:@"37"] || [strValue isEqualToString:@"38"] || [strValue isEqualToString:@"39"] || [strValue isEqualToString:@"40"])
    {
        [_sliderSmily setThumbImage: [UIImage imageNamed:@"08sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"41"] || [strValue isEqualToString:@"42"] || [strValue isEqualToString:@"43"] || [strValue isEqualToString:@"44"] || [strValue isEqualToString:@"45"])
    {
        [_sliderSmily setThumbImage: [UIImage imageNamed:@"09sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"46"] || [strValue isEqualToString:@"47"] || [strValue isEqualToString:@"48"] || [strValue isEqualToString:@"49"] || [strValue isEqualToString:@"50"])
    {
        [_sliderSmily setThumbImage: [UIImage imageNamed:@"10sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"51"] || [strValue isEqualToString:@"52"] || [strValue isEqualToString:@"53"] || [strValue isEqualToString:@"54"] || [strValue isEqualToString:@"55"])
    {
        [_sliderSmily setThumbImage: [UIImage imageNamed:@"11sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"56"] || [strValue isEqualToString:@"57"] || [strValue isEqualToString:@"58"] || [strValue isEqualToString:@"59"] || [strValue isEqualToString:@"60"])
    {
        [_sliderSmily setThumbImage: [UIImage imageNamed:@"12happy1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"61"] || [strValue isEqualToString:@"62"] || [strValue isEqualToString:@"63"] || [strValue isEqualToString:@"64"] || [strValue isEqualToString:@"65"])
    {
        [_sliderSmily setThumbImage: [UIImage imageNamed:@"13happy1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"66"] || [strValue isEqualToString:@"67"] || [strValue isEqualToString:@"68"] || [strValue isEqualToString:@"69"] || [strValue isEqualToString:@"70"])
    {
        [_sliderSmily setThumbImage: [UIImage imageNamed:@"14happy1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"71"] || [strValue isEqualToString:@"72"] || [strValue isEqualToString:@"73"] || [strValue isEqualToString:@"74"] || [strValue isEqualToString:@"75"])
    {
        [_sliderSmily setThumbImage: [UIImage imageNamed:@"15happy1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"76"] || [strValue isEqualToString:@"77"] || [strValue isEqualToString:@"78"] || [strValue isEqualToString:@"79"] || [strValue isEqualToString:@"80"])
    {
        [_sliderSmily setThumbImage: [UIImage imageNamed:@"16happy1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"81"] || [strValue isEqualToString:@"82"] || [strValue isEqualToString:@"83"] || [strValue isEqualToString:@"84"] || [strValue isEqualToString:@"85"])
    {
        [_sliderSmily setThumbImage: [UIImage imageNamed:@"17happy1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"86"] || [strValue isEqualToString:@"87"] || [strValue isEqualToString:@"88"] || [strValue isEqualToString:@"89"] || [strValue isEqualToString:@"90"])
    {
        [_sliderSmily setThumbImage: [UIImage imageNamed:@"18happy1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"91"] || [strValue isEqualToString:@"92"] || [strValue isEqualToString:@"93"] || [strValue isEqualToString:@"94"] || [strValue isEqualToString:@"95"])
    {
        [_sliderSmily setThumbImage: [UIImage imageNamed:@"19happy1"] forState:UIControlStateNormal];
    }
    else //if([strValue isEqualToString:@"96"] || [strValue isEqualToString:@"97"] || [strValue isEqualToString:@"98"] || [strValue isEqualToString:@"99"] || [strValue isEqualToString:@"100"])
    {
        [_sliderSmily setThumbImage: [UIImage imageNamed:@"20happy1"] forState:UIControlStateNormal];
    }
}

- (IBAction)btnClickedClose:(id)sender
{
     [self dismissViewControllerAnimated:YES completion:Nil];
}

- (IBAction)btnClickedDone:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}


@end
