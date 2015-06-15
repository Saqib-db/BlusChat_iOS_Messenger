

//
//  dbClass.m
//  BlusApp
//
//  Created by Usman Ghani on 27/06/2014.
//  Copyright (c) 2014 Gexton. All rights reserved.
//

#import "dbClass.h"

@implementation dbClass


- (id)init
{
	getValues = [[NSMutableArray alloc]init];
	return self;
	
}

/*
-(NSString *)getPath:(NSString *)dbName {

 
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
    
	
}
*/

-(NSString *)getPath:(NSString *)dbName {
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:dbName];
    
	return path;
}




-(void)emptyArray {
    
   // NSLog(@"GetValues--> %@", getValues);
    if ([getValues count]!= 0) {
		[getValues removeAllObjects];
	 //NSLog(@"GetValues--> %@", getValues);
    }
}

-(BOOL)userId_alreadyExist:(NSString *)user_id{
    
  NSMutableArray *userIDArr = [self get_user_id_from_users];
    
    if ([userIDArr count]==0) {
    
       return NO;

    }else{

        return YES;
    }
}

-(void)insertAdminContacts:(NSString *)email :(NSString *)username{
    
       
    // Befor inserting new record empty the table.
    [self emptyArray];
    
    
	NSString *path = [self getPath:@"blusApp.sqlite"];
    
	if(sqlite3_open([path UTF8String], &database) == SQLITE_OK)
	{
        static char *sql = "insert into users(user_id,fname,lname,mood,status_user,img_link,email,username,flag) values(?,?,?,?,?,?,?,?,?)";
        sqlite3_stmt *Statement1;
        int returnValue = sqlite3_prepare_v2(database, sql, -1, &Statement1, NULL);
        if(returnValue == SQLITE_OK)
        {
            
            sqlite3_bind_text(Statement1, 1, [@"0" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(Statement1, 2, [@"Admin" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(Statement1, 3, [@"" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(Statement1, 4, [@"Blus" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(Statement1, 5, [@"" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(Statement1, 6, [@"" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(Statement1, 7, [email UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(Statement1, 8, [username UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(Statement1, 9, [@"" UTF8String], -1, SQLITE_TRANSIENT);
            
            
			int success = sqlite3_step(Statement1);
            if(success != SQLITE_ERROR)
            {
               // NSLog(@"Success");
            }
            
        }
        else {
			printf( "could not prepare statemnt: %s\n", sqlite3_errmsg(database) );
        }
        
        sqlite3_finalize(Statement1);
        
    }
    
    
	//Release the select statement memory.

    else {
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
    }

    sqlite3_close(database);
}



-(void)insertContacts:(NSMutableArray *)contactsArray
{
    
    //NSLog(@"contactsArray----> %@", contactsArray);
    
    // Befor inserting new record empty the table.
       [self emptyArray];

    
	NSString *path = [self getPath:@"blusApp.sqlite"];
   // NSLog(@"Path---> %@", path);
    
    
	if(sqlite3_open([path UTF8String], &database) == SQLITE_OK)
	{

		for (int x =0 ; x < [contactsArray count]; x++)
		{

			NSMutableDictionary *contactList = [contactsArray objectAtIndex:x];
			NSString *user_id = [contactList objectForKey:@"id"];
			NSString *fname = [contactList objectForKey:@"fname"];
			NSString *lname = [contactList objectForKey:@"lname"];
			NSString *mood = [contactList objectForKey:@"mood"];
			NSString *status_user = [contactList objectForKey:@"status_user"];
            
			NSString *img_link = [contactList objectForKey:@"img_link"];
            if ([img_link isEqual:[NSNull null]]) {
                img_link = @"";
            }
			NSString *email = [contactList objectForKey:@"email"];
			NSString *username = [contactList objectForKey:@"username"];
			NSString *flag = [contactList objectForKey:@"flag"];


			static char *sql = "insert into users(user_id,fname,lname,mood,status_user,img_link,email,username,flag) values(?,?,?,?,?,?,?,?,?)";
			sqlite3_stmt *Statement1;
			int returnValue = sqlite3_prepare_v2(database, sql, -1, &Statement1, NULL);
			if(returnValue == SQLITE_OK)
			{

				sqlite3_bind_text(Statement1, 1, [user_id UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(Statement1, 2, [fname UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(Statement1, 3, [lname UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(Statement1, 4, [mood UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(Statement1, 5, [status_user UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(Statement1, 6, [img_link UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(Statement1, 7, [email UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(Statement1, 8, [username UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(Statement1, 9, [flag UTF8String], -1, SQLITE_TRANSIENT);


                int success = sqlite3_step(Statement1);
                
				if(success != SQLITE_ERROR)
			
                {
					//	NSLog(@"Success");
			
                }
                
            }
		
            else {
		
                printf( "could not prepare statemnt: %s\n", sqlite3_errmsg(database) );
		
            }

            sqlite3_finalize(Statement1);

		}
    
	//Release the select statement memory.

    }

	else {
	
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
	
    }

	
    sqlite3_close(database);
}



-(NSMutableArray *)get_status_user{
    
      NSString *path = [self getPath:@"blusApp.sqlite"];
    
    
    // Open the database from the users filessytem
    
    if(sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        NSString *sqlQuery = [NSString stringWithFormat:@"Select * from users Where status_user = 0"];
       // NSLog(@"sqlQuery---> %@", sqlQuery);
        
        const char *sqlStatement = [sqlQuery UTF8String];
        
        
        static sqlite3_stmt *compiledStatement=nil;
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
                NSMutableDictionary *infoDict = [[NSMutableDictionary alloc] init];
            
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)] forKey:@"user_id"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)] forKey:@"fname"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)] forKey:@"lname"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)] forKey:@"mood"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)] forKey:@"img_link"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)] forKey:@"email"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)] forKey:@"username"];
          
                [getValues addObject:infoDict];
        
    }
        }
        
    // Release the compiled statement from memory
    sqlite3_finalize(compiledStatement);
    
    }
    sqlite3_close(database);

  
    return getValues;


}

-(NSMutableArray *)get_user_detail :(NSString *)user_id{ // here user_id is user_to from the json
    
    NSString *path = [self getPath:@"blusApp.sqlite"];
    
   // [self emptyArray];

    
    // Open the database from the users filessytem
    
    if(sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        NSString *sqlQuery = [NSString stringWithFormat:@"Select * from users Where user_id = %@", user_id];
       
       // NSLog(@"sqlQuery---> %@", sqlQuery);
        
        const char *sqlStatement = [sqlQuery UTF8String];
        
        
        static sqlite3_stmt *compiledStatement=nil;
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
                NSMutableDictionary *infoDict = [[NSMutableDictionary alloc] init];
                
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)] forKey:@"user_id"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)] forKey:@"fname"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)] forKey:@"lname"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)] forKey:@"mood"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)] forKey:@"img_link"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)] forKey:@"email"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)] forKey:@"username"];
                
                [getValues addObject:infoDict];
                
            }
        }
        
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
        
    }
    sqlite3_close(database);
    
   // NSLog(@"GetValues--> %@", getValues);
    
    
    return getValues;
    
    
}
-(BOOL)isPresentInDb:(NSString *)user_id {
    
    
    NSString *path = [self getPath:@"blusApp.sqlite"];
   
    // Open the database from the users filessytem
    
    if(sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        NSString *sqlQuery = [NSString stringWithFormat:@"Select * from users Where user_id = %@", user_id];
        
        //NSLog(@"sqlQuery---> %@", sqlQuery);
        
        const char *sqlStatement = [sqlQuery UTF8String];
        
        
        static sqlite3_stmt *compiledStatement=nil;
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
                NSMutableDictionary *infoDict = [[NSMutableDictionary alloc] init];
                
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)] forKey:@"user_id"];
               
                
                [getValues addObject:infoDict];
                
            }
        }
        
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
        
    }
    sqlite3_close(database);
    
    // NSLog(@"GetValues--> %@", getValues);
    
    
    return YES;

}

-(NSMutableArray*)getContactsName
{
	
     [self emptyArray];
    
	
    NSString *path = [self getPath:@"blusApp.sqlite"];
    
    // Open the database from the users filessytem
    
    if(sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        
        NSString *sqlQuery = [NSString stringWithFormat:@"Select fname,lname,mood, img_link From users"];
        const char *sqlStatement = [sqlQuery UTF8String];
        
        
        static sqlite3_stmt *compiledStatement=nil;
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Loop through the results and add them to the feeds array
            
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
                NSMutableDictionary *infoDict = [[NSMutableDictionary alloc] init];
                
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)] forKey:@"fname"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)] forKey:@"lname"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)] forKey:@"mood"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)] forKey:@"img_link"];
                [getValues addObject:infoDict];
            }
            
            
            
            
        }
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
        
    }
    sqlite3_close(database);
    
    //NSLog(@"GetValues--> %@", getValues);
    
    return getValues;
    
	
}


//-(void)insertMessages :(NSString *)user_to :(NSString *)user_from :(NSString *)message{

-(void)insertMessages:(NSString *)user_to :(NSString *)user_from :(NSString *)message :(NSString *)date_time :(NSString *)is_sent :(NSString *)serverMsgId :(NSString *)is_image :(NSString *)is_url
{
    [self emptyArray];
    
    NSString *path = [self getPath:@"blusApp.sqlite"];
    //NSLog(@"path--> %@", path);
	if(sqlite3_open([path UTF8String], &database) == SQLITE_OK)
	{
        
        
        static char *sql = "insert into messages(user_to,user_from,msg,date_time,is_sent,server_msg_id, is_image,is_url) values(?,?,?,?,?,?,?,?)";
       
       // NSLog(@"sql---> %s", sql);
        
        sqlite3_stmt *Statement1;
       
        int returnValue = sqlite3_prepare_v2(database, sql, -1, &Statement1, NULL);
        if(returnValue == SQLITE_OK)
        {
            
            sqlite3_bind_text(Statement1, 1, [user_to UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(Statement1, 2, [user_from UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(Statement1, 3, [message UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(Statement1, 4, [date_time UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(Statement1, 5, [is_sent UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(Statement1, 6, [serverMsgId UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(Statement1, 7, [is_image UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(Statement1, 8, [is_url UTF8String], -1, SQLITE_TRANSIENT);
            
            int success = sqlite3_step(Statement1);
            
            if(success != SQLITE_ERROR)
            {
              //  NSLog(@"Success");
            }
            
        }
        else {
            
            printf( "could not prepare statemnt: %s\n", sqlite3_errmsg(database) );
        }
        
        sqlite3_finalize(Statement1);
        
    }
    
    
    
    //Release the select statement memory.
    
    
	else {
        
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
    }
    
	sqlite3_close(database);
    
    
}

-(void)insertAllMessages:(NSMutableArray *)allMessagesArray
{
    [self emptyArray];
    
    [self deleteAllRecrodsFromTable];
    
    
    NSString *path = [self getPath:@"blusApp.sqlite"];
    // NSLog(@"path--> %@", path);
	if(sqlite3_open([path UTF8String], &database) == SQLITE_OK)
	{
        
		for (int x =0 ; x < [allMessagesArray count]; x++)
		{
            
			NSMutableDictionary *allMessagesList = [allMessagesArray objectAtIndex:x];
			NSString *user_to = [allMessagesList objectForKey:@"user_to"];
			NSString *user_from = [allMessagesList objectForKey:@"user_from"];
			NSString *msg = [allMessagesList objectForKey:@"msg"];
			NSString *date_time = [allMessagesList objectForKey:@"date_time"];
//			NSString *is_sent = [allMessagesList objectForKey:@"is_sent"];
			NSString *server_msg_id = [allMessagesList objectForKey:@"server_msg_id"];
			NSString *is_image = [allMessagesList objectForKey:@"is_image"];
			NSString *is_url = [allMessagesList objectForKey:@"is_url"];

        
        static char *sql = "insert into messages(user_to,user_from,msg,date_time,server_msg_id, is_image,is_url) values(?,?,?,?,?,?,?)";
        
        //NSLog(@"sql---> %s", sql);
        
        sqlite3_stmt *Statement1;
        
        int returnValue = sqlite3_prepare_v2(database, sql, -1, &Statement1, NULL);
        if(returnValue == SQLITE_OK)
        {
            
            sqlite3_bind_text(Statement1, 1, [user_to UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(Statement1, 2, [user_from UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(Statement1, 3, [msg UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(Statement1, 4, [date_time UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(Statement1, 5, [server_msg_id UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(Statement1, 6, [is_image UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(Statement1, 7, [is_url UTF8String], -1, SQLITE_TRANSIENT);
            
            int success = sqlite3_step(Statement1);
           
            if(success != SQLITE_ERROR)
            {
               // NSLog(@"Success");
            }
            
        }
        else {
            printf( "could not prepare statemnt: %s\n", sqlite3_errmsg(database) );
        }
        
        sqlite3_finalize(Statement1);
    }
    
    }
    
    //Release the select statement memory.
    
    
	else {
        
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
   
    }
    
	sqlite3_close(database);
    
    
}

-(void)insertEvents:(NSMutableArray *)eventsArray{
    
   // NSLog(@"eventsArray--> %lu", (unsigned long)[eventsArray count]);
    
    [self emptyArray];
    
    NSString *path = [self getPath:@"blusApp.sqlite"];
    
	if(sqlite3_open([path UTF8String], &database) == SQLITE_OK)
	{
        
		for (int x =0 ; x < [eventsArray count]; x++)
		{
            
			NSMutableDictionary *eventList = [[eventsArray objectAtIndex:x]objectForKey:@"event_detail"];
			NSString *title = [eventList objectForKey:@"title"];
			NSString *detail = [eventList objectForKey:@"detail"];
			NSString *start = [eventList objectForKey:@"start"];
			NSString *end = [eventList objectForKey:@"end"];
            NSString *status_user= [eventList objectForKey:@"status_user"];
			  
            
            static char *sql = "insert into events(to_user_id, from_user_id, title, details, to_fname, to_lname, from_fname, from_lname, from_date_time, to_date_time, statusUser) values(?,?,?,?,?,?,?,?,?,?,?)";
          
            sqlite3_stmt *Statement1;
            
            int returnValue = sqlite3_prepare_v2(database, sql, -1, &Statement1, NULL);
            if(returnValue == SQLITE_OK)
            {
                
                sqlite3_bind_text(Statement1, 3, [title UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(Statement1, 4, [detail UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(Statement1, 9, [start UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(Statement1, 10, [end UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(Statement1, 11, [status_user UTF8String], -1, SQLITE_TRANSIENT);
                
                
                int success = sqlite3_step(Statement1);
                
                if(success != SQLITE_ERROR)
                {
                   // NSLog(@"Success");
                }
                
            }
            else {
                
                printf( "could not prepare statemnt: %s\n", sqlite3_errmsg(database) );
            }
            
            sqlite3_finalize(Statement1);
        }
        
    }
    
    
    //Release the select statement memory.
    
    
	else {
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
    }
    
	sqlite3_close(database);
    
}

-(void)deletemsgs:(NSString *)msg_id{
    
    
   // NSLog(@"msgid==> %@", msg_id);
    
    NSString *path = [self getPath:@"blusApp.sqlite"];
    
    if(sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        static char *sql = "DELETE FROM MESSAGES WHERE ID =?";
        
        sqlite3_stmt *Statement1;
        
        int returnValue = sqlite3_prepare_v2(database, sql, -1, &Statement1, NULL);
      
        if(returnValue == SQLITE_OK)
        {
     
          //  sqlite3_bind_text(Statement1, 5, [msg_id UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(Statement1,1, [msg_id UTF8String], -1, SQLITE_TRANSIENT);
            
            int success = sqlite3_step(Statement1);
            
            if(success != SQLITE_ERROR)
            {
               // NSLog(@"Success");
            }
            
        }
        else {
            printf( "could not prepare statemnt: %s\n", sqlite3_errmsg(database) );
        }
        
        sqlite3_finalize(Statement1);
        
    }
    
    
    //Release the select statement memory.
    
    else {
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
    }
    
    sqlite3_close(database);

    
}

-(void)insertEvents_users:(NSMutableArray *)events_userArray{
    
    [self emptyArray];
    
    NSString *path = [self getPath:@"blusApp.sqlite"];
    
	if(sqlite3_open([path UTF8String], &database) == SQLITE_OK)
	{
        
		for (int x =0 ; x < [[[events_userArray objectAtIndex:0]objectForKey:@"users" ] count]; x++)
		{
            
			NSMutableDictionary *event_users_List = [[[events_userArray objectAtIndex:x]objectForKey:@"users"]objectAtIndex:x];
			NSString *user_to = [event_users_List objectForKey:@"user_to"];
			NSString *user_from = [event_users_List objectForKey:@"user_from"];
			NSString *event_id = [event_users_List objectForKey:@"event_id"];

            
            
            static char *sql = "insert into event_users(user_to,user_from, event_id) values(?,?,?)";
            
            sqlite3_stmt *Statement1;
            
            int returnValue = sqlite3_prepare_v2(database, sql, -1, &Statement1, NULL);
         
            if(returnValue == SQLITE_OK)
            {
                
                sqlite3_bind_text(Statement1, 1, [user_to UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(Statement1, 2, [user_from UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(Statement1, 3, [event_id UTF8String], -1, SQLITE_TRANSIENT);
              
                
                
                int success = sqlite3_step(Statement1);
                
                if(success != SQLITE_ERROR)
                {
                   // NSLog(@"Success");
                }
                
            }
            else {
                printf( "could not prepare statemnt: %s\n", sqlite3_errmsg(database) );
            }
            
            sqlite3_finalize(Statement1);
        }
        
    }
    
    
    //Release the select statement memory.
    
    
	else {
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
    }
    
	sqlite3_close(database);
    
}


-(void)deleteAllRecrodsFromTable {
    
//     NSString *path = [self getPath:@"blusApp.sqlite"];
//   
//    if(sqlite3_open([path UTF8String], &database) == SQLITE_OK)
//    {
//        const char *sql = "DELETE FROM messages";
//        sqlite3_stmt *statement;
//        if(sqlite3_prepare_v2(database, sql,-1, &statement, NULL) == SQLITE_OK)
//        {
//            sqlite3_step(statement);
//        }
//    }

    NSString *path = [self getPath:@"blusApp.sqlite"];
    
    if(sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        static char *sql = "DELETE FROM MESSAGES";
        
        sqlite3_stmt *Statement1;
        
        int returnValue = sqlite3_prepare_v2(database, sql, -1, &Statement1, NULL);
        
        if(returnValue == SQLITE_OK)
        {
            
            int success = sqlite3_step(Statement1);
            
            if(success != SQLITE_ERROR)
            {
                 NSLog(@"Success");
            }
            
        }
        else {
            printf( "could not prepare statemnt: %s\n", sqlite3_errmsg(database) );
        }
        
        sqlite3_finalize(Statement1);
        
    }
    
    
    //Release the select statement memory.
    
    else {
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
    }
    
    sqlite3_close(database);

    
}

-(NSMutableArray*)getMessage:(NSString *)user_to UserFrom:(NSString *)user_from{

    
   // NSLog(@"userto--> %@", user_to);
   // NSLog(@"userfr--> %@", user_from);
    
    [self emptyArray];
    
    
    NSString *path = [self getPath:@"blusApp.sqlite"];
    
    // Open the database from the users filessytem
    if(sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        
        NSString *sqlQuery = [NSString stringWithFormat:@"SELECT m2.user_id AS from_id,m2.fname AS from_fname,m2.lname AS from_lname,m2.img_link AS from_img_link,messages.msg, messages.is_image, messages.is_url,messages.id,messages.server_msg_id, m3.user_id AS to_id,m3.fname AS to_fname,m3.lname AS to_lname, m3.img_link AS to_img_link,messages.date_time, messages.is_read, messages.is_sent FROM messages Inner JOIN users m3 ON messages.user_to=m3.user_id INNER JOIN users m2 ON messages.user_from=m2.user_id WHERE (messages.is_deleted=0 OR messages.is_deleted !=1) AND messages.user_from='%@' AND messages.user_to='%@' OR(messages.user_from='%@' AND messages.user_to='%@')",user_to,user_from,user_from,user_to];
        
      
            const char *sqlStatement = [sqlQuery UTF8String];
        
//        NSLog(@"Sql statement--> %s", sqlStatement);
        
        
        static sqlite3_stmt *compiledStatement=nil;
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Loop through the results and add them to the feeds array
            
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
                NSMutableDictionary *infoDict = [[NSMutableDictionary alloc] init];

//            [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)] forKey:@"from_id"];

                [infoDict setObject:((char *)sqlite3_column_text(compiledStatement, 0)) ?
                 [NSString stringWithUTF8String:
                  (char *)sqlite3_column_text(compiledStatement, 0)] : nil forKey:@"from_id"];
                
                
                
                
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)] forKey:@"from_fname"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)] forKey:@"from_lname"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)] forKey:@"from_img_link"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)] forKey:@"msg"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)] forKey:@"is_image"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)] forKey:@"is_url"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)] forKey:@"id"];
               
            //    [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)] forKey:@"server_msg_id"];
                
                
                
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)] forKey:@"to_id"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)] forKey:@"to_fname"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)] forKey:@"to_lname"];
                
                [infoDict setObject:((char *)sqlite3_column_text(compiledStatement, 12)) ?
                 [NSString stringWithUTF8String:
                  (char *)sqlite3_column_text(compiledStatement, 12)] : nil forKey:@"to_img_link"];
                
                
               // [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)] forKey:@"to_img_link"];
                
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 13)] forKey:@"date_time"];
//                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 14)] forKey:@"is_read"];
 //               [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 15)] forKey:@"is_sent"];

                [getValues addObject:infoDict];
            }
            
            
        }
        
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
        
    }
    sqlite3_close(database);
    
    //NSLog(@"Values--> %@", getValues);
    
    return getValues;

}






-(NSMutableArray *)get_conversation :(NSString *)user_id{
    
    //NSLog(@"userid--> %@", user_id);
    
    NSString *path = [self getPath:@"blusApp.sqlite"];
   // NSLog(@"path--> %@", path);
    
    
    // Open the database from the users filessytem
    if(sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
    
        NSString *sqlQuery = [NSString stringWithFormat:@"select * from (SELECT * FROM (SELECT `messages`.*,`fname`,`lname`, user_id, img_link  FROM `messages` JOIN `users` ON `users`.`user_id`=`messages`.`user_to` WHERE `user_from`='%@' AND (is_deleted=0 OR is_deleted !=1) ORDER BY id DESC )f  UNION SELECT * FROM (SELECT `messages`.*,`fname`,`lname`, user_id,img_link FROM `messages` JOIN `users` ON `users`.`user_id`=`messages`.`user_from` WHERE `user_to`='%@' ORDER BY id DESC)c ) r1  group by fname order by id desc", user_id, user_id];
      
                                                                                                                                                                                                                                                                                                                                               
        const char *sqlStatement = [sqlQuery UTF8String];
        
        static sqlite3_stmt *compiledStatement=nil;
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Loop through the results and add them to the feeds array
            
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
                NSMutableDictionary *infoDict = [[NSMutableDictionary alloc] init];
                
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)] forKey:@"id"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)] forKey:@"user_from_id"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)] forKey:@"user_to_id"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)] forKey:@"msg"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)] forKey:@"date_time"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)] forKey:@"is_read"];
                
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)] forKey:@"is_sent"];
                
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)] forKey:@"is_image"];
                
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)] forKey:@"fname"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)] forKey:@"lname"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 14)] forKey:@"img_link"];
                
                
//                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)] forKey:@"msg6"];
//                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)] forKey:@"msg87"];
//                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)] forKey:@"msg8"];
                
                [getValues addObject:infoDict];
            }
    
    }

    sqlite3_finalize(compiledStatement);

    }
    
    sqlite3_close(database);
    
   // NSLog(@"GetConversation---> %@", getValues);
        return getValues;
}




-(NSMutableArray *)getAll_Events{
    
    [self emptyArray];
    
    NSString *path = [self getPath:@"blusApp.sqlite"];
   
    // Open the database from the users filessytem
    
    if(sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        NSString *sqlQuery = [NSString stringWithFormat:@"Select * From events"];
     
        const char *sqlStatement = [sqlQuery UTF8String];
        
        
        static sqlite3_stmt *compiledStatement=nil;
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Loop through the results and add them to the feeds array
            
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
                NSMutableDictionary *infoDict = [[NSMutableDictionary alloc] init];

               [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)] forKey:@"title"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)] forKey:@"detail"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)] forKey:@"from_date_time"];
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)] forKey:@"to_date_time"];
                
                [getValues addObject:infoDict];
                
            }
            
        }
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
        
    }
    sqlite3_close(database);
    
  //  NSLog(@"getValues--> %@", getValues);
    
    return getValues;

    
}


-(NSMutableArray *)getMaxID{
    
    NSString *path = [self getPath:@"blusApp.sqlite"];
   
    
    // Open the database from the users filessytem
    
    if(sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        
        NSString *sqlQuery = [NSString stringWithFormat:@"Select MAX(id) From messages"];
        const char *sqlStatement = [sqlQuery UTF8String];
        
        
        static sqlite3_stmt *compiledStatement=nil;
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Loop through the results and add them to the feeds array
            
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
                NSMutableDictionary *infoDict = [[NSMutableDictionary alloc] init];
                
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)] forKey:@"id"];
                
               
                [getValues addObject:infoDict];
              
            }
            
        }
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
        
    }
    sqlite3_close(database);
    
    
    
    return getValues;
}

-(NSMutableArray *)get_user_id_from_users{
    
    NSString *path = [self getPath:@"blusApp.sqlite"];
    
    
    // Open the database from the users filessytem
    
    if(sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        
        NSString *sqlQuery = [NSString stringWithFormat:@"Select user_id From users"];
        const char *sqlStatement = [sqlQuery UTF8String];
        
        
        static sqlite3_stmt *compiledStatement=nil;
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Loop through the results and add them to the feeds array
            
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
                NSMutableDictionary *infoDict = [[NSMutableDictionary alloc] init];
                
                [infoDict setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)] forKey:@"user_id"];
                
                
                [getValues addObject:infoDict];
                
            }
            
        }
        
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
        
    }
    
    sqlite3_close(database);
    
    return getValues;
}


-(void)update_isRead:(NSString *)user_to_id // not your own id
{
    
  //  NSLog(@"userto--> %@", user_to_id);
    NSString *path = [self getPath:@"blusApp.sqlite"];
    
   // NSLog(@"user_id---> %@", user_to_id);
    
    if(sqlite3_open([path UTF8String], &database) == SQLITE_OK)
        
	{
        // update messages set date_time=date_time, is_sent=1, server_msg_id=serverMsgId where id=returnID
		static char *sql = "update messages set is_read=1 where user_from = ?";
        
		sqlite3_stmt *Statement1;
        
		int returnValue = sqlite3_prepare_v2(database, sql, -1, &Statement1, NULL);
        
		if(returnValue == SQLITE_OK)
		{
			sqlite3_bind_text(Statement1, 1, [user_to_id UTF8String], -1, SQLITE_TRANSIENT);
			         
            
			int success = sqlite3_step(Statement1);
            
			if(success != SQLITE_ERROR)
			{
				//NSLog(@"Success");
			}
            
		}
		else {
			printf( "could not prepare statemnt: %s\n", sqlite3_errmsg(database) );
		}
		sqlite3_finalize(Statement1);
	}
    
	//Release the select statement memory.
    
	else {
		// Even though the open failed, call close to properly clean up resources.
		NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
		// Additional error handling, as appropriate...
	}
	sqlite3_close(database);
    

    
}
-(void)updatePicturepath :(NSString *)msg :(NSString *)return_id{
    
    NSString *path = [self getPath:@"blusApp.sqlite"];
    
   // NSLog(@"pngPath--> %@", msg);
    
	if(sqlite3_open([path UTF8String], &database) == SQLITE_OK)
        
	{
        // update messages set date_time=date_time, is_sent=1, server_msg_id=serverMsgId where id=returnID
		static char *sql = "update messages set msg = ? Where id = ?";
        
        sqlite3_stmt *Statement1;
        
        
		int returnValue = sqlite3_prepare_v2(database, sql, -1, &Statement1, NULL);
        
		if(returnValue == SQLITE_OK)
		{
			sqlite3_bind_text(Statement1, 1, [msg UTF8String], -1, SQLITE_TRANSIENT);
		
            sqlite3_bind_text(Statement1, 2, [return_id UTF8String], -1, SQLITE_TRANSIENT);
            
            
			int success = sqlite3_step(Statement1);
            
			if(success != SQLITE_ERROR)
			{
				NSLog(@"Success");
			}
            
		}
		else {
			printf( "could not prepare statemnt: %s\n", sqlite3_errmsg(database) );
		}
		sqlite3_finalize(Statement1);
	}
    
	//Release the select statement memory.
    
	else {
		// Even though the open failed, call close to properly clean up resources.
		NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
		// Additional error handling, as appropriate...
	}
	sqlite3_close(database);
   
}

-(void)updateProfilePicturepath :(NSString *)img_link :(NSString *)user_id{
    
    NSString *path = [self getPath:@"blusApp.sqlite"];
    

    if(sqlite3_open([path UTF8String], &database) == SQLITE_OK)
        
    {
        // update messages set date_time=date_time, is_sent=1, server_msg_id=serverMsgId where id=returnID
        static char *sql = "update users set img_link = ? Where user_id = ?";
        
        sqlite3_stmt *Statement1;
        
        
        int returnValue = sqlite3_prepare_v2(database, sql, -1, &Statement1, NULL);
        
        if(returnValue == SQLITE_OK)
        {
            sqlite3_bind_text(Statement1, 1, [img_link UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(Statement1, 2, [user_id UTF8String], -1, SQLITE_TRANSIENT);
            
            
            int success = sqlite3_step(Statement1);
            
            if(success != SQLITE_ERROR)
            {
               // NSLog(@"Success");
            }
            
        }
        else {
            printf( "could not prepare statemnt: %s\n", sqlite3_errmsg(database) );
        }
        sqlite3_finalize(Statement1);
    }
    
    //Release the select statement memory.
    
    else {
        // Even though the open failed, call close to properly clean up resources.
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
        // Additional error handling, as appropriate...
    }
    sqlite3_close(database);
    
}


-(void)updateMessages:(NSString *)date_time is_sent:(NSString *)is_sent server_msg_id:(NSString *)server_msg_id return_id:(NSString *)return_id
{
    
    NSString *path = [self getPath:@"blusApp.sqlite"];
    
	if(sqlite3_open([path UTF8String], &database) == SQLITE_OK)

	{
       // update messages set date_time=date_time, is_sent=1, server_msg_id=serverMsgId where id=returnID
		static char *sql = "update messages set date_time = ?, is_sent = ?, server_msg_id = ? Where id = ?";
   
		sqlite3_stmt *Statement1;

        
		int returnValue = sqlite3_prepare_v2(database, sql, -1, &Statement1, NULL);
        
		if(returnValue == SQLITE_OK)
		{
			sqlite3_bind_text(Statement1, 1, [date_time UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(Statement1, 2, [is_sent UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(Statement1, 3, [server_msg_id  UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(Statement1, 4, [return_id UTF8String], -1, SQLITE_TRANSIENT);


			int success = sqlite3_step(Statement1);

			if(success != SQLITE_ERROR)
			{
			//	NSLog(@"Success");
			}

		}
		else {
			printf( "could not prepare statemnt: %s\n", sqlite3_errmsg(database) );
		}
		sqlite3_finalize(Statement1);
	}

	//Release the select statement memory.

	else {
		// Even though the open failed, call close to properly clean up resources.
		NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
		// Additional error handling, as appropriate...
	}
	sqlite3_close(database);

}



@end
