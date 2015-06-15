//
//  SideMenuVC.m
//  SocialVapping
//
//  Created by Zeeshan Shaikh on 4/10/14.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import "SideMenuVC.h"
#import "Singleton.h"


#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


@interface SideMenuVC ()

@end

@implementation SideMenuVC

// - (id)initWithStyle:(UITableViewStyle)style
// {
// self = [super initWithStyle:style];
// if (self) {
// // Custom initialization
// }
// return self;
// }



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    // For resigning keyboard
   // [self.view endEditing:YES];
   
        
    
    // BACKGROUND
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, 320.0, 568.0)];
    bgView.image = [UIImage imageNamed:@"blus_bg.png"];
    [self.view addSubview:bgView];

    
    
    // HEADER
    UIImageView *headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 60.0)];
    UIImage *headerImg = [UIImage imageNamed:@"header_blus.png"];
    [headerView setImage:headerImg];
    [self.view addSubview:headerView];
    
    // HEADER TITLE
    UILabel *sideMenuLbl = [[UILabel alloc]initWithFrame:CGRectMake(100.0, 25.0, 250.0, 26.0)];
    sideMenuLbl.text = @"Blus Menu";
    sideMenuLbl.font =[UIFont fontWithName:@"Lato-Regular" size:18];
   // sideMenuLbl.font = [UIFont boldSystemFontOfSize:17.0];
    [sideMenuLbl setBackgroundColor:[UIColor clearColor]];
    sideMenuLbl.textColor = [UIColor whiteColor];
    [headerView addSubview:sideMenuLbl];
    
    UIImageView *headerLineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 60.0, 320.0, 1.0)];
    headerLineImgView.image = [UIImage imageNamed:@"test_bbline.png"];
   
    //[self.view addSubview:headerLineImgView];
    
    
    
    if (IS_IPHONE_5) {
    
        //HOME BUTTON
        UIImageView *HomeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 230.0, 270.0, 45.0)];
        HomeImgView.image = [UIImage imageNamed:@"blus_bg.png"];
        
        UIImageView *homeIconView = [[UIImageView alloc]initWithFrame:CGRectMake(25.0, 9.0, 30.0, 25.0)];
        homeIconView.image = [UIImage imageNamed:@"home_icon.png"];
        [HomeImgView addSubview:homeIconView];
        
        
        UILabel *homeLbl = [[UILabel alloc]initWithFrame:CGRectMake(70.0, 10.0, 100., 25.0)];
        homeLbl.font = [UIFont fontWithName:@"Lato-Regular" size:16];
        homeLbl.textColor = [UIColor whiteColor];
        [homeLbl setText:@"Home"];
        [HomeImgView addSubview:homeLbl];
        
        UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [homeBtn addTarget:self action:@selector(homeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        homeBtn.tag = 000;
        homeBtn.frame = CGRectMake(0.0, 230.0, 300.0, 40.0);
        [self.view addSubview:homeBtn];
        
        UIImageView *homelineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 275.0, 320.0, 1.0)];
        homelineImgView.image = [UIImage imageNamed:@"test_bbline.png"];
        [self.view addSubview:homelineImgView];
        
        [self.view addSubview:HomeImgView];
        
        
        //CONTACT BUTTON
        UIImageView *ContactsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 277.0, 270.0, 45.0)];
        ContactsImgView.image = [UIImage imageNamed:@"blus_bg.png"];
        
        UIImageView *contactsIconView = [[UIImageView alloc]initWithFrame:CGRectMake(25.0, 9.0, 30.0, 30.0)];
        contactsIconView.image = [UIImage imageNamed:@"contacts_icon.png"];
        [ContactsImgView addSubview:contactsIconView];
        
        
        UILabel *contactsLbl = [[UILabel alloc]initWithFrame:CGRectMake(70.0, 10.0, 100., 25.0)];
        contactsLbl.font = [UIFont fontWithName:@"Lato-Regular" size:16];
        contactsLbl.textColor = [UIColor whiteColor];
        [contactsLbl setText:@"Contacts"];
        [ContactsImgView addSubview:contactsLbl];
        
        UIButton *contactsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [contactsBtn addTarget:self action:@selector(contactsBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        contactsBtn.tag = 111;
        contactsBtn.frame = CGRectMake(0.0, 277.0, 300.0, 40.0);
        [self.view addSubview:contactsBtn];
        
        UIImageView *contactslineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 322.0, 320.0, 1.0)];
        contactslineImgView.image = [UIImage imageNamed:@"test_bbline.png"];
        [self.view addSubview:contactslineImgView];
        
        [self.view addSubview:ContactsImgView];
        
        
        // EVENTS BUTTON
        UIImageView *eventsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 323.0, 270.0, 45.0)];
        eventsImgView.image = [UIImage imageNamed:@"blus_bg.png"];
       
        UIImageView *eventIconView = [[UIImageView alloc]initWithFrame:CGRectMake(25.0, 9.0, 30.0, 30.0)];
        eventIconView.image = [UIImage imageNamed:@"event_icon.png"];
        [eventsImgView addSubview:eventIconView];
        
        UIButton *eventsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [eventsBtn addTarget:self action:@selector(eventsBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        eventsBtn.tag = 222;
        eventsBtn.frame = CGRectMake(0.0, 323.0, 300.0, 50.0);
        [self.view addSubview:eventsBtn];
        
        UILabel *eventsLbl = [[UILabel alloc]initWithFrame:CGRectMake(70.0, 10.0, 100., 25.0)];
        eventsLbl.font = [UIFont fontWithName:@"Lato-Regular" size:16];
        eventsLbl.textColor = [UIColor whiteColor];
        [eventsLbl setText:@"Events"];
        [eventsImgView addSubview:eventsLbl];
        
        UIImageView *eventsLineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 369.0, 320.0, 1.0)];
        eventsLineImgView.image = [UIImage imageNamed:@"test_bbline.png"];
        [self.view addSubview:eventsLineImgView];
        [self.view addSubview:eventsImgView];
        
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSLog(@"status_user---> %@", [defaults stringForKey:@"status_user"]);
        
        if ([[defaults stringForKey:@"status_user"] isEqualToString:@"1"]) {
            NSLog(@"Its Client");

        
        
        // SETTINGS
         UIImageView *settingsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 370.0, 270.0, 45.0)];
        settingsImgView.image = [UIImage imageNamed:@"blus_bg.png"];
        
        UIImageView *settingsIconView = [[UIImageView alloc]initWithFrame:CGRectMake(25.0, 9.0, 30.0, 30.0)];
        settingsIconView.image = [UIImage imageNamed:@"settings_icon.png"];
        [settingsImgView addSubview:settingsIconView];
        
        UIButton *settingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [settingsBtn addTarget:self action:@selector(settingsBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        settingsBtn.tag = 333;
        settingsBtn.frame = CGRectMake(0.0, 370.0, 300.0, 45.0);
        [self.view addSubview:settingsBtn];
        
        UILabel *settingsLbl = [[UILabel alloc]initWithFrame:CGRectMake(70.0, 10.0, 100.0, 25.0)];
        settingsLbl.font = [UIFont fontWithName:@"Lato-Regular" size:16];
        settingsLbl.textColor = [UIColor whiteColor];
        [settingsLbl setText:@"Settings"];
        [settingsImgView addSubview:settingsLbl];
        
    //    UIImageView *settingsLineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 507.0, 320.0, 1.0)];
        UIImageView *settingsLineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 415.0, 320.0, 1.0)];
        settingsLineImgView.image = [UIImage imageNamed:@"test_bbline.png"];
        [self.view addSubview:settingsLineImgView];
        [self.view addSubview:settingsImgView];
        
        
        
        // LOGOUTS
    //    UIImageView *logOutImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 508.0, 270.0, 60.0)];
        UIImageView *logOutImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 416.0, 270.0, 60.0)];
        logOutImgView.image = [UIImage imageNamed:@"blus_bg.png"];
        
        UIImageView *logOutIconView = [[UIImageView alloc]initWithFrame:CGRectMake(25.0, 9.0, 30.0, 30.0)];
        logOutIconView.image = [UIImage imageNamed:@"logout_icon.png"];
        [logOutImgView addSubview:logOutIconView];
        
        UIButton *logOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [logOutBtn addTarget:self action:@selector(logOutBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        logOutBtn.frame = CGRectMake(0.0, 416.0, 300.0, 50.0);
        [self.view addSubview:logOutBtn];
        
        UILabel *logOutLbl = [[UILabel alloc]initWithFrame:CGRectMake(70.0, 10.0, 100., 25.0)];
        logOutLbl.font = [UIFont fontWithName:@"Lato-Regular" size:16];
        logOutLbl.textColor = [UIColor whiteColor];
        [logOutLbl setText:@"Logout"];
        [logOutImgView addSubview:logOutLbl];
         [self.view addSubview:logOutImgView];
        
        }else{
            
            // Gallery will be shown to the Agent ONLY
            
            // GALLERY
            UIImageView *galleryImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 370.0, 270.0, 45.0)];
            galleryImgView.image = [UIImage imageNamed:@"blus_bg.png"];
            
            UIImageView *galleryIconView = [[UIImageView alloc]initWithFrame:CGRectMake(25.0, 9.0, 30.0, 30.0)];
            galleryIconView.image = [UIImage imageNamed:@"gallery_icon.png"];
            [galleryImgView addSubview:galleryIconView];
            
            UIButton *galleryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [galleryBtn addTarget:self action:@selector(galleryBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            galleryBtn.tag = 333;
            galleryBtn.frame = CGRectMake(0.0, 370.0, 300.0, 45.0);
            [self.view addSubview:galleryBtn];
            
            UILabel *galleryLbl = [[UILabel alloc]initWithFrame:CGRectMake(70.0, 10.0, 100., 25.0)];
            galleryLbl.font = [UIFont fontWithName:@"Lato-Regular" size:16];
            galleryLbl.textColor = [UIColor whiteColor];
            [galleryLbl setText:@"Blus Gallery"];
            [galleryImgView addSubview:galleryLbl];
            
            UIImageView *galleryLineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 415.0, 320.0, 1.0)];
            galleryLineImgView.image = [UIImage imageNamed:@"test_bbline.png"];
            [self.view addSubview:galleryLineImgView];
            [self.view addSubview:galleryImgView];
            
            // SETTINGS
            UIImageView *settingsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 416.0, 270.0, 45.0)];
            settingsImgView.image = [UIImage imageNamed:@"blus_bg.png"];
            
            UIImageView *settingsIconView = [[UIImageView alloc]initWithFrame:CGRectMake(25.0, 9.0, 30.0, 30.0)];
            settingsIconView.image = [UIImage imageNamed:@"settings_icon.png"];
            [settingsImgView addSubview:settingsIconView];
            
            UIButton *settingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [settingsBtn addTarget:self action:@selector(settingsBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            settingsBtn.tag = 333;
            settingsBtn.frame = CGRectMake(0.0, 416.0, 300.0, 45.0);
            [self.view addSubview:settingsBtn];
            
            UILabel *settingsLbl = [[UILabel alloc]initWithFrame:CGRectMake(70.0, 10.0, 100.0, 25.0)];
            settingsLbl.font = [UIFont fontWithName:@"Lato-Regular" size:16];
            settingsLbl.textColor = [UIColor whiteColor];
            [settingsLbl setText:@"Settings"];
            [settingsImgView addSubview:settingsLbl];
            
            //    UIImageView *settingsLineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 507.0, 320.0, 1.0)];
            UIImageView *settingsLineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 461.0, 320.0, 1.0)];
            settingsLineImgView.image = [UIImage imageNamed:@"test_bbline.png"];
            [self.view addSubview:settingsLineImgView];
            [self.view addSubview:settingsImgView];
            
            
            
            // LOGOUTS
            //    UIImageView *logOutImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 508.0, 270.0, 60.0)];
            UIImageView *logOutImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 462.0, 270.0, 60.0)];
            logOutImgView.image = [UIImage imageNamed:@"blus_bg.png"];
            
            UIImageView *logOutIconView = [[UIImageView alloc]initWithFrame:CGRectMake(25.0, 9.0, 30.0, 30.0)];
            logOutIconView.image = [UIImage imageNamed:@"logout_icon.png"];
            [logOutImgView addSubview:logOutIconView];
            
            UIButton *logOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [logOutBtn addTarget:self action:@selector(logOutBtnPressed) forControlEvents:UIControlEventTouchUpInside];
            logOutBtn.frame = CGRectMake(0.0, 462.0, 300.0, 50.0);
            [self.view addSubview:logOutBtn];
            
            UILabel *logOutLbl = [[UILabel alloc]initWithFrame:CGRectMake(70.0, 10.0, 100., 25.0)];
            logOutLbl.font = [UIFont fontWithName:@"Lato-Regular" size:16];
            logOutLbl.textColor = [UIColor whiteColor];
            [logOutLbl setText:@"Logout"];
            [logOutImgView addSubview:logOutLbl];
            [self.view addSubview:logOutImgView];
            
        }

        // SET UP FOR iPhone 4s
        
    }else{
        
        //HOME BUTTON
        UIImageView *HomeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 220.0, 270.0, 40.0)];
        HomeImgView.image = [UIImage imageNamed:@"blus_bg.png"];
        
        UIImageView *homeIconView = [[UIImageView alloc]initWithFrame:CGRectMake(25.0, 9.0, 30.0, 20.0)];
        homeIconView.image = [UIImage imageNamed:@"home_icon.png"];
        [HomeImgView addSubview:homeIconView];
        
        
        UILabel *homeLbl = [[UILabel alloc]initWithFrame:CGRectMake(70.0, 10.0, 100., 20.0)];
      //  homeLbl.font = [UIFont systemFontOfSize:16.0];
        homeLbl.font = [UIFont fontWithName:@"Lato-Regular" size:16];
        homeLbl.textColor = [UIColor whiteColor];
        [homeLbl setText:@"Home"];
        [HomeImgView addSubview:homeLbl];
        
        UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [homeBtn addTarget:self action:@selector(homeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        homeBtn.tag = 000;
        homeBtn.frame = CGRectMake(0.0, 220.0, 300.0, 35.0);
        [self.view addSubview:homeBtn];
        
        UIImageView *homelineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 260.0, 320.0, 1.0)];
        homelineImgView.image = [UIImage imageNamed:@"test_bbline.png"];
        [self.view addSubview:homelineImgView];
        
        [self.view addSubview:HomeImgView];
        
        
        //CONTACT BUTTON
        UIImageView *ContactsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 261.0, 270.0, 40.0)];
        ContactsImgView.image = [UIImage imageNamed:@"blus_bg.png"];
        
        UIImageView *contactsIconView = [[UIImageView alloc]initWithFrame:CGRectMake(25.0, 9.0, 30.0, 25.0)];
        contactsIconView.image = [UIImage imageNamed:@"contacts_icon.png"];
        [ContactsImgView addSubview:contactsIconView];
        
        
        UILabel *contactsLbl = [[UILabel alloc]initWithFrame:CGRectMake(70.0, 10.0, 100., 25.0)];
        contactsLbl.font = [UIFont fontWithName:@"Lato-Regular" size:16];
        contactsLbl.textColor = [UIColor whiteColor];
        [contactsLbl setText:@"Contacts"];
        [ContactsImgView addSubview:contactsLbl];
        
        UIButton *contactsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [contactsBtn addTarget:self action:@selector(contactsBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        contactsBtn.tag = 111;
        contactsBtn.frame = CGRectMake(0.0, 261.0, 300.0, 40.0);
        [self.view addSubview:contactsBtn];
        
        UIImageView *contactslineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 301.0, 320.0, 1.0)];
        contactslineImgView.image = [UIImage imageNamed:@"test_bbline.png"];
        [self.view addSubview:contactslineImgView];
        
        [self.view addSubview:ContactsImgView];
        
        
        // EVENTS BUTTON
        UIImageView *eventsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 303.0, 270.0, 40.0)];
        eventsImgView.image = [UIImage imageNamed:@"blus_bg.png"];
        
        UIImageView *eventIconView = [[UIImageView alloc]initWithFrame:CGRectMake(25.0, 9.0, 30.0, 25.0)];
        eventIconView.image = [UIImage imageNamed:@"event_icon.png"];
        [eventsImgView addSubview:eventIconView];
        
        UIButton *eventsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [eventsBtn addTarget:self action:@selector(eventsBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        eventsBtn.tag = 222;
        eventsBtn.frame = CGRectMake(0.0, 303.0, 300.0, 40.0);
        [self.view addSubview:eventsBtn];
        
        UILabel *eventsLbl = [[UILabel alloc]initWithFrame:CGRectMake(70.0, 10.0, 100., 25.0)];
        eventsLbl.font = [UIFont fontWithName:@"Lato-Regular" size:16];
        eventsLbl.textColor = [UIColor whiteColor];
        [eventsLbl setText:@"Events"];
        [eventsImgView addSubview:eventsLbl];
        
        UIImageView *eventsLineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 344.0, 320.0, 1.0)];
        eventsLineImgView.image = [UIImage imageNamed:@"test_bbline.png"];
        [self.view addSubview:eventsLineImgView];
        [self.view addSubview:eventsImgView];
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSLog(@"status_user---> %@", [defaults stringForKey:@"status_user"]);
        
        if ([[defaults stringForKey:@"status_user"] isEqualToString:@"1"]) {
            NSLog(@"Its Client");
            
            // SETTINGS
            // UIImageView *settingsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 462.0, 270.0, 45.0)];
            UIImageView *settingsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 345.0, 270.0, 40.0)];
            settingsImgView.image = [UIImage imageNamed:@"blus_bg.png"];
            
            UIImageView *settingsIconView = [[UIImageView alloc]initWithFrame:CGRectMake(25.0, 9.0, 30.0, 25.0)];
            settingsIconView.image = [UIImage imageNamed:@"settings_icon.png"];
            [settingsImgView addSubview:settingsIconView];
            
            UIButton *settingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [settingsBtn addTarget:self action:@selector(settingsBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            settingsBtn.tag = 333;
            settingsBtn.frame = CGRectMake(0.0, 345.0, 300.0, 40.0);
            [self.view addSubview:settingsBtn];
            
            UILabel *settingsLbl = [[UILabel alloc]initWithFrame:CGRectMake(70.0, 10.0, 100.0, 25.0)];
            settingsLbl.font = [UIFont fontWithName:@"Lato-Regular" size:16];
            settingsLbl.textColor = [UIColor whiteColor];
            [settingsLbl setText:@"Settings"];
            [settingsImgView addSubview:settingsLbl];
            
            
            UIImageView *settingsLineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 385.0, 320.0, 1.0)];
            settingsLineImgView.image = [UIImage imageNamed:@"test_bbline.png"];
            [self.view addSubview:settingsLineImgView];
            [self.view addSubview:settingsImgView];
            
            
            
            // LOGOUTS
            //    UIImageView *logOutImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 508.0, 270.0, 60.0)];
            UIImageView *logOutImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 387.0, 270.0, 100.0)];
            logOutImgView.image = [UIImage imageNamed:@"blus_bg.png"];
            
            UIImageView *logOutIconView = [[UIImageView alloc]initWithFrame:CGRectMake(25.0, 9.0, 30.0, 30.0)];
            logOutIconView.image = [UIImage imageNamed:@"logout_icon.png"];
            [logOutImgView addSubview:logOutIconView];
            
            UIButton *logOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [logOutBtn addTarget:self action:@selector(logOutBtnPressed) forControlEvents:UIControlEventTouchUpInside];
            logOutBtn.frame = CGRectMake(0.0, 387.0, 300.0, 50.0);
            [self.view addSubview:logOutBtn];
            
            UILabel *logOutLbl = [[UILabel alloc]initWithFrame:CGRectMake(70.0, 10.0, 100., 25.0)];
            logOutLbl.font = [UIFont fontWithName:@"Lato-Regular" size:16];
            logOutLbl.textColor = [UIColor whiteColor];
            [logOutLbl setText:@"Logout"];
            [logOutImgView addSubview:logOutLbl];
            [self.view addSubview:logOutImgView];

            
            
        }else{
        
            // GALLERY
            UIImageView *galleryImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 345.0, 270.0, 40.0)];
            galleryImgView.image = [UIImage imageNamed:@"blus_bg.png"];
            
            UIImageView *galleryIconView = [[UIImageView alloc]initWithFrame:CGRectMake(25.0, 9.0, 30.0, 25.0)];
            galleryIconView.image = [UIImage imageNamed:@"gallery_icon.png"];
            [galleryImgView addSubview:galleryIconView];
            
            UIButton *galleryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [galleryBtn addTarget:self action:@selector(galleryBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            galleryBtn.tag = 333;
            galleryBtn.frame = CGRectMake(0.0, 345.0, 300.0, 40.0);
            [self.view addSubview:galleryBtn];
            
            UILabel *galleryLbl = [[UILabel alloc]initWithFrame:CGRectMake(70.0, 10.0, 100., 25.0)];
            galleryLbl.font = [UIFont fontWithName:@"Lato-Regular" size:16];
            galleryLbl.textColor = [UIColor whiteColor];
            [galleryLbl setText:@"Blus Gallery"];
            [galleryImgView addSubview:galleryLbl];
            
            UIImageView *galleryLineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 385.0, 320.0, 1.0)];
            galleryLineImgView.image = [UIImage imageNamed:@"test_bbline.png"];
            [self.view addSubview:galleryLineImgView];
            [self.view addSubview:galleryImgView];
        
            // SETTINGS
            // UIImageView *settingsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 462.0, 270.0, 45.0)];
            UIImageView *settingsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 387.0, 270.0, 40.0)];
            settingsImgView.image = [UIImage imageNamed:@"blus_bg.png"];
            
            UIImageView *settingsIconView = [[UIImageView alloc]initWithFrame:CGRectMake(25.0, 9.0, 30.0, 25.0)];
            settingsIconView.image = [UIImage imageNamed:@"settings_icon.png"];
            [settingsImgView addSubview:settingsIconView];
            
            UIButton *settingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [settingsBtn addTarget:self action:@selector(settingsBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            settingsBtn.tag = 333;
            settingsBtn.frame = CGRectMake(0.0, 387.0, 300.0, 40.0);
            [self.view addSubview:settingsBtn];
            
            UILabel *settingsLbl = [[UILabel alloc]initWithFrame:CGRectMake(70.0, 10.0, 100.0, 25.0)];
            settingsLbl.font = [UIFont fontWithName:@"Lato-Regular" size:16];
            settingsLbl.textColor = [UIColor whiteColor];
            [settingsLbl setText:@"Settings"];
            [settingsImgView addSubview:settingsLbl];
            
            //    UIImageView *settingsLineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 507.0, 320.0, 1.0)];
            UIImageView *settingsLineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 427.0, 320.0, 1.0)];
            settingsLineImgView.image = [UIImage imageNamed:@"test_bbline.png"];
            [self.view addSubview:settingsLineImgView];
            [self.view addSubview:settingsImgView];
            
            
            
            // LOGOUTS
            //    UIImageView *logOutImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 508.0, 270.0, 60.0)];
            UIImageView *logOutImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 428.0, 270.0, 80.0)];
            logOutImgView.image = [UIImage imageNamed:@"blus_bg.png"];
            
            UIImageView *logOutIconView = [[UIImageView alloc]initWithFrame:CGRectMake(25.0, 9.0, 30.0, 30.0)];
            logOutIconView.image = [UIImage imageNamed:@"logout_icon.png"];
            [logOutImgView addSubview:logOutIconView];
            
            UIButton *logOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [logOutBtn addTarget:self action:@selector(logOutBtnPressed) forControlEvents:UIControlEventTouchUpInside];
            logOutBtn.frame = CGRectMake(0.0, 428.0, 300.0, 50.0);
            [self.view addSubview:logOutBtn];
            
            UILabel *logOutLbl = [[UILabel alloc]initWithFrame:CGRectMake(70.0, 10.0, 100., 25.0)];
            logOutLbl.font = [UIFont fontWithName:@"Lato-Regular" size:16];
            logOutLbl.textColor = [UIColor whiteColor];
            [logOutLbl setText:@"Logout"];
            [logOutImgView addSubview:logOutLbl];
            [self.view addSubview:logOutImgView];
        }
        
    }


}



-(void)viewWillAppear:(BOOL)animated{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   
    // PROFILE IMAGE
    
    NSLog(@"img_link--> %@", [defaults stringForKey:@"img_link"]);
    
    if ([defaults stringForKey:@"img_link"] == nil || [[defaults stringForKey:@"img_link"] isEqualToString:@""]|| [[defaults stringForKey:@"img_link"] isEqualToString:@" "]) {
        UIImageView *defaultPic = [[UIImageView alloc]initWithFrame:CGRectMake(130.0, 80.0, 80.0, 70.0)];
        
        [defaultPic setImage:[UIImage imageNamed:@"test_dp.png"]];
        [self.view addSubview:defaultPic];
        
    }else{
    
    
        IphoneAsyncImageView *participantImg = [[IphoneAsyncImageView alloc] initWithFrame:CGRectMake(80.0f, 65.0f,100.0f,100.0f)];
        
        participantImg.cv_width = 120.0f;
        participantImg.cv_height = 120.0f;
        participantImg.contentMode = UIViewContentModeScaleAspectFit;
        participantImg.backgroundColor = [UIColor clearColor];
        
        NSLog(@"image_link=> %@", [defaults stringForKey:@"img_link"]);
        [participantImg loadImageFromURL:[NSURL URLWithString:[defaults stringForKey:@"img_link"]]];
        participantImg.tag = 201;
        [participantImg setContentMode:UIViewContentModeScaleAspectFit];
        [self.view addSubview:participantImg];
    }
    
    fnameLname = [[UILabel alloc]initWithFrame:CGRectMake(30.0, 170.0, 200.0, 30.0)];
    [fnameLname setText:[NSString stringWithFormat:@"%@ %@", [defaults stringForKey:@"fname"], [defaults stringForKey:@"lname"]]];
    fnameLname.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    fnameLname.textColor = [UIColor whiteColor];
    [fnameLname setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:fnameLname];
    
   
    moodLbl.tag = 111;

    moodLbl = [[UILabel alloc]initWithFrame:CGRectMake(30.0, 190.0, 200.0, 30.0)];
    
    [moodLbl setText:[defaults stringForKey:@"mood"]];
    [defaults synchronize];
    
    moodLbl.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    moodLbl.textColor = [UIColor whiteColor];
    [moodLbl setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:moodLbl];

}


-(void)homeBtnPressed:(id)sender{
    UIButton *btn = (UIButton*)sender;
    NSLog(@"Button tag %ld", (long)btn.tag);
    NSString *btnTagStr = [NSString stringWithFormat:@"%ld", (long)btn.tag];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:btnTagStr forKey:@"btnTag"];
    
    
    HomeViewController *homeVC = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
      [self.menuContainerViewController setCenterViewController:homeVC];
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed completion:nil];

    
}



-(void)contactsBtnPressed:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    NSLog(@"Button tag %ld", (long)btn.tag);
    NSString *btnTagStr = [NSString stringWithFormat:@"%ld", (long)btn.tag];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:btnTagStr forKey:@"btnTag"];
    
    
    ContactsViewController *contactsVC = [[ContactsViewController alloc]initWithNibName:@"ContactsViewController" bundle:nil];
   
    
    [self.menuContainerViewController setCenterViewController:contactsVC];
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed completion:nil];
    
    
    
}
-(void)eventsBtnPressed:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    NSLog(@"Button tag %ld", (long)btn.tag);
    NSString *btnTagStr = [NSString stringWithFormat:@"%ld", (long)btn.tag];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:btnTagStr forKey:@"btnTag"];
    
    EventsTableVC *eventVC = [[EventsTableVC alloc]initWithNibName:@"EventsTableVC" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:eventVC];
    [self.menuContainerViewController setCenterViewController:nav];
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed completion:nil];
    
    /*
     
     [22/08/2014 5:45:33 pm] aftab Saraz: jese he events k screen pa araha hei tou agr net hei tou webservce se events ki list la raha hei, vrna database se events ki list la raha hei
     [22/08/2014 5:46:05 pm] aftab Saraz: net se events latay hue, pehlay database mei events k table ko khali krk phr updated insert kr raha hei
     [22/08/2014 5:46:43 pm] aftab Saraz: getEvents method call ho raha hei to get events from webserivce
     [22/08/2014 5:47:20 pm] aftab Saraz: phr event pa click krne se uski detail show kr raha hun jo events lete wakt database mei save hui hei
     
     */
}

//-(void)galleryBtnPressed:(id)sender{
//    
//    
//     UIButton *btn = (UIButton*)sender;
//     NSLog(@"Button tag %ld", (long)btn.tag);
//     NSString *btnTagStr = [NSString stringWithFormat:@"%ld", (long)btn.tag];
//     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//     [defaults setObject:btnTagStr forKey:@"btnTag"];
//     
//     
//     GalleryViewController *galleryVC = [[GalleryViewController alloc]initWithNibName:@"GalleryViewController" bundle:nil];
//     [self.menuContainerViewController setCenterViewController:galleryVC];
//     [self.menuContainerViewController setMenuState:MFSideMenuStateClosed completion:nil];
//     
//}

-(void)galleryBtnPressed:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    NSLog(@"Button tag %ld", (long)btn.tag);
    NSString *btnTagStr = [NSString stringWithFormat:@"%ld", (long)btn.tag];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:btnTagStr forKey:@"btnTag"];
    
    GalleryViewController *galleryVC = [[GalleryViewController alloc]initWithNibName:@"GalleryViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:galleryVC];
    [self.menuContainerViewController setCenterViewController:nav];
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed completion:nil];
    
}

-(void)paymentsBtnPressed:(id)sender{
    
}

-(void)settingsBtnPressed:(id)sender{
    
    SettingsViewController *settingVC = [[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:nil];
    [self.menuContainerViewController setCenterViewController:settingVC];
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed completion:nil];
    
}


-(void)logOutBtnPressed{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Logout" message:@"Are you sure you want to log out?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alertView.tag = 777;
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (alertView.tag == 777) {
        
        if (buttonIndex == 1) {
            
            [post logout:[defaults stringForKey:@"user_from_id"]];
            
            [defaults removeObjectForKey:@"user_from_id"];
            [defaults removeObjectForKey:@"login_status"];
            [defaults removeObjectForKey:@"status_user"];
            [defaults synchronize];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
