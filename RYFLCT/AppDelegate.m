//
//  AppDelegate.m
//  RYFLCT
//
//  Created by Tops on 1/10/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import "AppDelegate.h"
#import "Header.h"
#import "GetStartedVC.h"
#import "HomeVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppDelegate ()
{
    MBProgressHUD * HUD;
    NSUserDefaults *prefs;
    AppDelegate *app;
    NSString *pref;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Set AudioSession
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setDelegate:self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    /* Pick any one of them */
    // 1. Overriding the output audio route
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    [self getvalidate];
    [APP_DELEGATE setViewControllerAccordingToStatus];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];
    // Add any custom logic here.
    return handled;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];
    // Add any custom logic here.
    return handled;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSUserDefaults *prefs1 = [NSUserDefaults standardUserDefaults];
     NSString *tokenString = [deviceToken description];
     tokenString = [tokenString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
     tokenString = [tokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
     [prefs1 setValue:tokenString forKey:@"MyAppSpecificGloballyUniqueString"];
     NSLog(@"%@",tokenString);
}

#pragma Mark OTHER Methods:

-(void)AlertMessage:(NSString *)message
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"RYFLCT"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        return ;
                                    }];
    
    [alert addAction:defaultAction];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

-(id)getUserDefaults:(NSString*)key
{
    prefs = [NSUserDefaults standardUserDefaults];
    id value = [prefs objectForKey:key];
    return value;
}

-(void)showMBProgressWithShow:(BOOL)show
{
    if(show == YES)
    {
        [HUD removeFromSuperview];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        HUD  = [[MBProgressHUD alloc]initWithView:self.window.rootViewController.view];
        HUD.label.text = @"";
        HUD.detailsLabel.text = @"Loading";
        HUD.mode = MBProgressHUDModeIndeterminate;
        [self.window.rootViewController.view addSubview:HUD];
        [HUD removeFromSuperViewOnHide];
        [HUD showAnimated:YES];
    }
    else
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [HUD hideAnimated:YES afterDelay:1];
        [HUD removeFromSuperview];
    }
}

-(void)setUserDefaults:(id)value andKey:(NSString *)key
{
    NSLog(@"Value %@",value);
    NSLog(@"Key %@",key);
    
    prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)getvalidate
{
    
    //pref= [app getUserDefaults:LOGIN_TYPE];
    BOOL isLogged = [[self getUserDefaults:DFL_IS_LOGGED]boolValue];
    
    pref=[[NSUserDefaults standardUserDefaults]objectForKey:@"LocalLogin"];
    
    if (isLogged == YES)
    {
        if([pref isEqualToString:@"Facebook"])
        {
            
        }
        else if([pref isEqualToString:@"Local"])
        {
            NSUserDefaults *prefsGCMID = [NSUserDefaults standardUserDefaults];
            NSString *setid=[prefsGCMID stringForKey:@"MyAppSpecificGloballyUniqueString"];
            
            if(setid == nil || setid == NULL || [setid isEqualToString:@""] || [setid isKindOfClass:[NSNull class]])
            {
                setid = @"MyAppSpecificGloballyUniqueString";
            }
            
            NSString *strUsername= [[NSUserDefaults standardUserDefaults]objectForKey:@"Login_Username"];
            NSString *strpassword= [[NSUserDefaults standardUserDefaults]objectForKey:@"Login_Password"];
            
            [APP_DELEGATE showMBProgressWithShow:YES];
            
            NSDictionary *innerDict = @{
                                        @"username":strUsername,
                                        @"password":strpassword
                                        };
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            
            NSString *strUrl=[NSString stringWithFormat:@"%@login",API_SERVER_URL];
            
            [manager POST:strUrl parameters:innerDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
             {
                 
             }success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 NSLog(@"JSON: %@", responseObject);
                 Boolean Status=[[responseObject valueForKey:@"success"]boolValue];
                 if(Status==1)
                 {
                     app = [[AppDelegate alloc]init];
                     [app setUserDefaults:[NSNumber numberWithBool:YES] andKey:DFL_IS_LOGGED];
                     [app setUserDefaults:LOGIN_LCL andKey:LOGIN_TYPE];
                     
                     [[NSUserDefaults standardUserDefaults]setObject:@"Local" forKey:@"LocalLogin"];
                     
                     [[NSUserDefaults standardUserDefaults]setObject:strUsername forKey:@"Login_Username"];
                     [[NSUserDefaults standardUserDefaults]setObject:strpassword forKey:@"Login_Password"];
                     
                     prefs = [NSUserDefaults standardUserDefaults];
                     NSDictionary *json1 = [responseObject objectForKey:@"data"] ;
                     
                     NSString *userToken =[json1 valueForKey:@"userToken"];
                     [[NSUserDefaults standardUserDefaults]setObject:userToken forKey:@"userToken"];
                     
                     UINavigationController *rootNavigationController = (UINavigationController*) self.window.rootViewController;
                     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                    
                     HomeVC *HomeVC = [storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
                     //HomeVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical
                     rootNavigationController.viewControllers = @[HomeVC];
                     [APP_DELEGATE showMBProgressWithShow:NO];
                 }
                 else
                 {
                     [APP_DELEGATE showMBProgressWithShow:NO];
                     
                     UINavigationController *rootNavigationController = (UINavigationController*) self.window.rootViewController;
                     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                     GetStartedVC *GetStartedVC = [storyboard instantiateViewControllerWithIdentifier:@"GetStartedVC"];
                     rootNavigationController.viewControllers = @[GetStartedVC];
                     [APP_DELEGATE AlertMessage:[responseObject valueForKey:@"message"]];
                 }
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                 [APP_DELEGATE showMBProgressWithShow:NO];
                 NSLog(@"Error: %@", error);
             }];
        }
    }
    else
    {
        UINavigationController *rootNavigationController = (UINavigationController*) self.window.rootViewController;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        
        GetStartedVC *GetStartedVC = [storyboard instantiateViewControllerWithIdentifier:@"GetStartedVC"];
        rootNavigationController.viewControllers = @[GetStartedVC];
    }
}

-(void)setViewControllerAccordingToStatus
{
    UINavigationController *rootNavigationController = (UINavigationController *) self.window.rootViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    BOOL isLogged = [[self getUserDefaults:DFL_IS_LOGGED]boolValue];
    //pref= [app getUserDefaults:LOGIN_TYPE];
    pref=[[NSUserDefaults standardUserDefaults]objectForKey:@"LocalLogin"];
    if (isLogged == YES)
    {
        if([pref isEqualToString:@"Facebook"])
        {
            
        }
        else if([pref isEqualToString:@"Local"])
        {
            HomeVC *HomeVC =[storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
            rootNavigationController.viewControllers = @[HomeVC];
        }
    }
    else
    {
        GetStartedVC *GetStartedVC = [storyboard instantiateViewControllerWithIdentifier:@"GetStartedVC"];
        rootNavigationController.viewControllers = @[GetStartedVC];
    }
}

@end
