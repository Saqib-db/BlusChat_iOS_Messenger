//
//  dbClass.h
//  BlusApp
//
//  Created by Usman Ghani on 27/06/2014.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface dbClass : NSObject{
    
    sqlite3 *database;
    NSMutableArray *getValues;
    NSString *getStringValue;
}

-(NSString *)getPath:(NSString *)dbName;-(void)updateProfilePicturepath :(NSString *)img_link :(NSString *)user_id;

-(void)updateMessages :(NSString *)date_time is_sent:(NSString *)is_sent server_msg_id:(NSString *)server_msg_id return_id:(NSString *)return_id;


-(void)emptyArray;

-(void)insertAdminContacts:(NSString *)email :(NSString *)username;

-(void)insertContacts:(NSMutableArray *)contactsArray;


-(void)insertMessages :(NSString *)user_to :(NSString *)user_from :(NSString *)message :(NSString *)date_time :(NSString *)is_sent :(NSString *)serverMsgId :(NSString *)is_image :(NSString *)is_url;

-(NSMutableArray*)getContactsName;
//-(NSMutableArray*)getMessages;
-(NSMutableArray*)getMessage:(NSString *)user_to UserFrom :(NSString *)user_from;
-(NSMutableArray*)getAllMessage:(NSString *)user_to UserFrom:(NSString *)user_from;

-(NSMutableArray *)getMaxID;

-(void)updatePicturepath :(NSString *)msg :(NSString *)return_id;


-(BOOL)userId_alreadyExist:(NSString *)user_id;

-(NSMutableArray *)get_status_user;

-(NSMutableArray *)get_user_detail :(NSString *)user_i; // here user_id is user_from from the json
    
-(NSMutableArray *)get_conversation: (NSString *)user_id;

-(void)update_isRead:(NSString *)user_to_id; // not your own id

-(void)insertAllMessages:(NSMutableArray *)allMessagesArray;

-(void)insertEvents :(NSMutableArray *)eventsArray;

-(void)insertEvents_users :(NSMutableArray *)events_userArray;

-(NSMutableArray *)getAll_Events;

-(void)deletemsgs:(NSString *)msg_id;

-(BOOL)isPresentInDb:(NSString *)user_id;

@end
