//
//  AppDelegate.h
//  RYFLCT
//
//  Created by Tops on 1/10/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)AlertMessage:(NSString *)message;
-(id)getUserDefaults:(NSString*)key;
-(void)showMBProgressWithShow:(BOOL)show;
-(void)setUserDefaults:(id)value andKey:(NSString *)key;
-(void)getvalidate;
-(void)setViewControllerAccordingToStatus;
@end

