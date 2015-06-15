//
//  Post.h
//  Funeral
//
//  Created by Zeeshan Syed on 11/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "JSONKit.h"
#import "JSON.h"



@protocol PostProtocoal <NSObject>

-(void)ConnectionDidFinishLoading:(NSString *)responseString :(NSString *)serviceName;
-(void)ConnectiondidFailWithError:(NSString *)responseString :(NSString *)serviceName;
@end


@interface POST : NSObject
{
    id delegate;
    NSMutableData *responseData;
}
@property(nonatomic,retain)id delegate;



-(void)login :(NSString *)username :(NSString *)pass :(NSString *)token;

-(void)logout :(NSString *)user_id;

-(void)getAllContacts :(NSString *)user_id;

-(void)profile_img:(NSData *)image :(NSString *)user_id;

-(void)updateProfile_firstName:(NSString *)fname lastName:(NSString *)lname username:(NSString *)user_name user_id:(NSString *)user_id;

-(void)changePassword_oldPass :(NSString *)oldPass newPass:(NSString *)newPass confirmPass:(NSString *)confirmPass Id :(NSString *)id;

-(void)setMood :(NSString *)mood :(NSString *)user_id;

-(void)sendMessages :(NSString *)userID_to UserID_from:(NSString *)userID_from Message:(NSString *)msg database_lastID:(NSString *)last_id Status:(NSString *)status;

-(void)getNotification: (NSString *)user_id;

-(void)uploadMsgImg :(NSString *)user_to :(NSString *)user_from :(NSString *)last_id :(NSString *)status :(NSData *)image;

-(void)get_gallery :(NSString *)user_id;

-(void)insert_payment_information :(NSString *)user_id :(NSString *)paymentInfo;

-(void)get_payment_information :(NSString *)user_id;

-(void)get_events:(NSString *)user_id;

-(void)insert_event :(NSString *)event_title :(NSString *)event_detail :(NSString *)start_time :(NSString *)end_time :(NSString *)user_to :(NSString *)user_from;

-(void)getCountries;

-(void)getAllAgents;

//-(void)create_client:(NSString *)fname :(NSString *)lname :(NSString *)country_id :(NSString *)dob :(NSString *)username :(NSString *)email :(NSString *)password :(NSString *)gender :(NSString *)status_user :(NSString *)agent_ids;

-(void)create_client:(NSString *)fname :(NSString *)lname :(NSString *)country_id :(NSString *)username :(NSString *)email :(NSString *)password :(NSString *)status_user :(NSString *)agent_ids;

-(void)delEvents :(NSString *)event_id;

-(void)delMsgs :(NSString *)server_msg_id;

-(void)inviteClientsForEvent:(NSString *)user_from :(NSString *)user_to :(NSString *)event_id :(NSString *)status;

-(void)forgetPassword :(NSString *)email_address;

@end

