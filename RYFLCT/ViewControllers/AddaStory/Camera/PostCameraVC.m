
//
//  PostCameraVC.m
//  RYFLCT
//
//  Created by admin on 15/01/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import "PostCameraVC.h"
#import "HomeVC.h"

@interface PostCameraVC ()<UIImagePickerControllerDelegate>
{
    UIImage *img1;
    NSData *imageData;
}

@end

@implementation PostCameraVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _viewCamera.layer.cornerRadius=10;
    _viewCamera.layer.masksToBounds=YES;
    
    if([_strCameraOrNot isEqualToString:@"Camera"])
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.allowsEditing = YES;
            
            [self presentModalViewController:imagePicker animated:YES];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"RYFLCT"
                                                           message:@"Unable to find a camera on your device."
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil, nil];
            [alert show];
            alert = nil;
        }
    }
    else
    {
        UIImagePickerController *imgpickr1=[[UIImagePickerController alloc]init];
        imgpickr1.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        imgpickr1.delegate =(id)self;
        imgpickr1.allowsEditing=YES;
        [self presentViewController:imgpickr1 animated:YES completion:nil];
    }
    
    [_CameraSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [_CameraSlider setThumbImage: [UIImage imageNamed:@"01sad1"] forState:UIControlStateNormal];
}

- (IBAction)sliderValueChanged:(UISlider *)sender
{
    NSLog(@"slider value = %f", sender.value);
    
    NSString *strValue = [NSString stringWithFormat:@"%d",(int)sender.value];
    NSLog(@"Value %@",strValue);
    
    _lblCameraCountEmozi.text = [NSString stringWithFormat:@"%d",(int)sender.value];
    
    if([strValue isEqualToString:@"0"] || [strValue isEqualToString:@"1"] || [strValue isEqualToString:@"2"] || [strValue isEqualToString:@"3"] || [strValue isEqualToString:@"4"] || [strValue isEqualToString:@"5"])
    {
        [_CameraSlider setThumbImage: [UIImage imageNamed:@"01sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"6"] || [strValue isEqualToString:@"7"] || [strValue isEqualToString:@"8"] || [strValue isEqualToString:@"9"] || [strValue isEqualToString:@"10"])
    {
        [_CameraSlider setThumbImage: [UIImage imageNamed:@"02sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"11"] || [strValue isEqualToString:@"12"] || [strValue isEqualToString:@"13"] || [strValue isEqualToString:@"14"] || [strValue isEqualToString:@"15"])
    {
        [_CameraSlider setThumbImage: [UIImage imageNamed:@"03sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"16"] || [strValue isEqualToString:@"17"] || [strValue isEqualToString:@"18"] || [strValue isEqualToString:@"19"] || [strValue isEqualToString:@"20"])
    {
        [_CameraSlider setThumbImage: [UIImage imageNamed:@"04sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"21"] || [strValue isEqualToString:@"22"] || [strValue isEqualToString:@"23"] || [strValue isEqualToString:@"24"] || [strValue isEqualToString:@"25"])
    {
        [_CameraSlider setThumbImage: [UIImage imageNamed:@"05sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"26"] || [strValue isEqualToString:@"27"] || [strValue isEqualToString:@"28"] || [strValue isEqualToString:@"29"] || [strValue isEqualToString:@"30"])
    {
        [_CameraSlider setThumbImage: [UIImage imageNamed:@"06sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"31"] || [strValue isEqualToString:@"32"] || [strValue isEqualToString:@"33"] || [strValue isEqualToString:@"34"] || [strValue isEqualToString:@"35"])
    {
        [_CameraSlider setThumbImage: [UIImage imageNamed:@"07sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"36"] || [strValue isEqualToString:@"37"] || [strValue isEqualToString:@"38"] || [strValue isEqualToString:@"39"] || [strValue isEqualToString:@"40"])
    {
        [_CameraSlider setThumbImage: [UIImage imageNamed:@"08sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"41"] || [strValue isEqualToString:@"42"] || [strValue isEqualToString:@"43"] || [strValue isEqualToString:@"44"] || [strValue isEqualToString:@"45"])
    {
        [_CameraSlider setThumbImage: [UIImage imageNamed:@"09sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"46"] || [strValue isEqualToString:@"47"] || [strValue isEqualToString:@"48"] || [strValue isEqualToString:@"49"] || [strValue isEqualToString:@"50"])
    {
        [_CameraSlider setThumbImage: [UIImage imageNamed:@"10sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"51"] || [strValue isEqualToString:@"52"] || [strValue isEqualToString:@"53"] || [strValue isEqualToString:@"54"] || [strValue isEqualToString:@"55"])
    {
        [_CameraSlider setThumbImage: [UIImage imageNamed:@"11sad1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"56"] || [strValue isEqualToString:@"57"] || [strValue isEqualToString:@"58"] || [strValue isEqualToString:@"59"] || [strValue isEqualToString:@"60"])
    {
        [_CameraSlider setThumbImage: [UIImage imageNamed:@"12happy1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"61"] || [strValue isEqualToString:@"62"] || [strValue isEqualToString:@"63"] || [strValue isEqualToString:@"64"] || [strValue isEqualToString:@"65"])
    {
        [_CameraSlider setThumbImage: [UIImage imageNamed:@"13happy1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"66"] || [strValue isEqualToString:@"67"] || [strValue isEqualToString:@"68"] || [strValue isEqualToString:@"69"] || [strValue isEqualToString:@"70"])
    {
        [_CameraSlider setThumbImage: [UIImage imageNamed:@"14happy1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"71"] || [strValue isEqualToString:@"72"] || [strValue isEqualToString:@"73"] || [strValue isEqualToString:@"74"] || [strValue isEqualToString:@"75"])
    {
        [_CameraSlider setThumbImage: [UIImage imageNamed:@"15happy1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"76"] || [strValue isEqualToString:@"77"] || [strValue isEqualToString:@"78"] || [strValue isEqualToString:@"79"] || [strValue isEqualToString:@"80"])
    {
        [_CameraSlider setThumbImage: [UIImage imageNamed:@"16happy1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"81"] || [strValue isEqualToString:@"82"] || [strValue isEqualToString:@"83"] || [strValue isEqualToString:@"84"] || [strValue isEqualToString:@"85"])
    {
        [_CameraSlider setThumbImage: [UIImage imageNamed:@"17happy1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"86"] || [strValue isEqualToString:@"87"] || [strValue isEqualToString:@"88"] || [strValue isEqualToString:@"89"] || [strValue isEqualToString:@"90"])
    {
        [_CameraSlider setThumbImage: [UIImage imageNamed:@"18happy1"] forState:UIControlStateNormal];
    }
    else if([strValue isEqualToString:@"91"] || [strValue isEqualToString:@"92"] || [strValue isEqualToString:@"93"] || [strValue isEqualToString:@"94"] || [strValue isEqualToString:@"95"])
    {
        [_CameraSlider setThumbImage: [UIImage imageNamed:@"19happy1"] forState:UIControlStateNormal];
    }
    else //if([strValue isEqualToString:@"96"] || [strValue isEqualToString:@"97"] || [strValue isEqualToString:@"98"] || [strValue isEqualToString:@"99"] || [strValue isEqualToString:@"100"])
    {
        [_CameraSlider setThumbImage: [UIImage imageNamed:@"20happy1"] forState:UIControlStateNormal];
    }
}

#pragma Mark ImagePickerController::

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    img1=[info valueForKey:UIImagePickerControllerEditedImage];
    
    _imgCamera.image = img1;
    
    //    _imgProfile.layer.cornerRadius=_imgProfile.frame.size.height/2;
    //    _imgProfile.layer.borderWidth=1;
    //    _imgProfile.layer.borderColor=[[UIColor blackColor]CGColor];
    
    _imgCamera.clipsToBounds = YES;
    imageData =UIImageJPEGRepresentation(img1, 50.0);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClickedBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (IBAction)btnClickedCameraPost:(id)sender
{
    HomeVC *HomeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
    [self presentViewController:HomeVC animated:YES completion:nil];
}


- (IBAction)btnClickedCamera:(id)sender
{
    
}

- (IBAction)btnClickedPhoto:(id)sender
{
    
}

- (IBAction)btnClickedRecord:(id)sender
{
    
}
@end
