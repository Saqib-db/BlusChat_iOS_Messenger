//
//  Post.m
//


#import "Post.h"
//#import "Defines.h"
//#define BASE_URL @"http://www.demii.com/demo/blus-app/apps"

//#define BASE_URL @"http://saqib.gexwork.com/social-clothing/apps"

#define BASE_URL @"http://www.blusserver.com/bluschat/apps"

@implementation POST
@synthesize delegate;
#pragma mark -
#pragma mark init
- (id)init {
	if (self = [super init]) {
        
        responseData = [[NSMutableData alloc] init];
	}
	return self;
}

-(BOOL)connectedToWiFi
{
	Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	bool result = false;
	if (internetStatus == ReachableViaWiFi )
	{
	    result = true;
	}
	else if(internetStatus == ReachableViaWWAN){
		result = true;
	}
	return result;
}

#pragma mark -
#pragma mark Sync DB-Web




-(void)login:(NSString *)email :(NSString *)pass :(NSString *)token {
    
    
    NSLog(@"token---> %@", token);
    
    
    if ([self connectedToWiFi]){
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@/login", BASE_URL];
        
        
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"urlString is %@", urlString);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *requestURL = [NSURL URLWithString:urlString];
        
        
        [request setURL:requestURL];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        //param 1
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"email\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",email] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //param 2
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"pass\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",pass] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //param 3
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"token\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",token] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [request setHTTPBody:body];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   NSLog(@"ERROR = %@",error.localizedDescription);
                                   if(error.localizedDescription == NULL)
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> succ %@",returnString);
                                       [delegate ConnectionDidFinishLoading:returnString : @"login"];
                                   }
                                   else
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> fail %@",returnString);
                                       [delegate ConnectiondidFailWithError:returnString : @"login"];
                                   }
                                   
                               }];
        
    }
   
    
}
 


-(void)logout:(NSString *)user_id{
   
    if ([self connectedToWiFi]){
        
        NSString *urlString = [NSString stringWithFormat:@"%@/logout", BASE_URL];
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"urlString is %@", urlString);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *requestURL = [NSURL URLWithString:urlString];
        [request setURL:requestURL];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        //param 1
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",user_id] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [request setHTTPBody:body];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   NSLog(@"ERROR = %@",error.localizedDescription);
                                   if(error.localizedDescription == NULL)
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> succ %@",returnString);
                                      // [delegate ConnectionDidFinishLoading:returnString : @"logout"];
                                   }
                                   else
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> fail %@",returnString);
                                     //  [delegate ConnectiondidFailWithError:returnString : @"logout"];
                                   }
                                   
                               }];
        
        
    }

    
}


-(void)getAllContacts:(NSString *)user_id{
    
    NSLog(@"user_id---> %@", user_id);
    
    
    if ([self connectedToWiFi]){
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@/getFreshContacts", BASE_URL];
        
        
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"urlString is %@", urlString);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *requestURL = [NSURL URLWithString:urlString];
        
        
        [request setURL:requestURL];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        //param 1
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"user_id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",user_id] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [request setHTTPBody:body];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   NSLog(@"ERROR = %@",error.localizedDescription);
                                   if(error.localizedDescription == NULL)
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> succ %@",returnString);
                                        [delegate ConnectionDidFinishLoading:returnString : @"getAllContacts"];
                                   }
                                   else
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> fail %@",returnString);
                                         [delegate ConnectiondidFailWithError:returnString : @"getAllContacts"];
                                   }
                                   
                               }];
        
        
        
        
        
    }

    
}

-(void)profile_img:(NSData *)image :(NSString *)user_id{
    
    
    NSLog(@"ID--:> %@", user_id);
    
    if ([self connectedToWiFi]){
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@/userProfileImg",BASE_URL];
        NSLog(@"urlString is %@", urlString);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *requestURL = [NSURL URLWithString:urlString];
        
        [request setURL:requestURL];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[@"Content-Disposition: form-data; name=\"%image\"; filename=\"item.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Append ID with image name
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@_item.png\"\r\n" , user_id] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [body appendData:image];
        
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // final boundary
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        [request setHTTPBody:body];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   NSLog(@"ERROR = %@",error.localizedDescription);
                                   if(error.localizedDescription == NULL)
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> succ %@",returnString);
                                       [delegate ConnectionDidFinishLoading:returnString : @"profile_img"];
                                   }
                                   else
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> fail %@",returnString);
                                       [delegate ConnectiondidFailWithError:returnString : @"profile_img"];
                                   }
                                   
                               }];
        
    }
    
    
}



-(void)updateProfile_firstName:(NSString *)fname lastName:(NSString *)lname username:(NSString *)user_name user_id:(NSString *)user_id{
    
    if ([self connectedToWiFi]){
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@/updateProfile", BASE_URL];
        
        NSLog(@"urlString is %@", urlString);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *requestURL = [NSURL URLWithString:urlString];
        
        [request setURL:requestURL];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        //param 1
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"fname\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",fname] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //param 2
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"lname\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",lname] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        //param 3
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"username\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",user_name] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //param 4
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",user_id] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setHTTPBody:body];
        
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   NSLog(@"ERROR = %@",error.localizedDescription);
                                   if(error.localizedDescription == NULL)
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> succ %@",returnString);
                                       [delegate ConnectionDidFinishLoading:returnString : @"updateProfile"];
                                   }
                                   else
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> fail %@",returnString);
                                       [delegate ConnectiondidFailWithError:returnString : @"updateProfile"];
                                   }
                                   
                               }];
        
    }
    
    
}


-(void)changePassword_oldPass:(NSString *)oldPass newPass:(NSString *)newPass confirmPass:(NSString *)confirmPass Id:(NSString *)id{
    
    
    
    if ([self connectedToWiFi]){
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@/updatePassword", BASE_URL];
        
        NSLog(@"urlString is %@", urlString);
        
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *requestURL = [NSURL URLWithString:urlString];
        
        
        [request setURL:requestURL];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        //param 1
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"old_password\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",oldPass] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //param 2
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"new_password\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",newPass] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //param 3
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"confirm_password\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",confirmPass] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //param 4
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",id] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [request setHTTPBody:body];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   NSLog(@"ERROR = %@",error.localizedDescription);
                                   if(error.localizedDescription == NULL)
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> succ %@",returnString);
                                       [delegate ConnectionDidFinishLoading:returnString : @"changePassword"];
                                   }
                                   else
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> fail %@",returnString);
                                       [delegate ConnectiondidFailWithError:returnString : @"changePassword"];
                                   }
                                   
                               }];
        
        
            }
}


-(void)setMood:(NSString *)mood :(NSString *)user_id{
    
    if ([self connectedToWiFi]){
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@/updateMood", BASE_URL];
        
        
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"urlString is %@", urlString);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *requestURL = [NSURL URLWithString:urlString];
        
        
        [request setURL:requestURL];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        
        
        //param 1
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"mood\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",mood] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        //param 2
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",user_id] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [request setHTTPBody:body];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   NSLog(@"ERROR = %@",error.localizedDescription);
                                   if(error.localizedDescription == NULL)
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> succ %@",returnString);
                                        [delegate ConnectionDidFinishLoading:returnString : @"updateMood"];
                                   }
                                   else
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> fail %@",returnString);
                                         [delegate ConnectiondidFailWithError:returnString : @"updateMood"];
                                   }
                                   
                               }];
        
        
        
        
        
    }
    
    
}

#pragma mark - SEND MESSAGES
-(void)sendMessages :(NSString *)userID_to UserID_from:(NSString *)userID_from Message:(NSString *)msg database_lastID:(NSString *)lastId Status:(NSString *)status{
    

    if ([self connectedToWiFi]){
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@/messages?user_to=%@&user_from=%@&msg=%@&last_id=%@&status=%@", BASE_URL, userID_to,userID_from,msg,lastId,status];
        
        
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"urlString is %@", urlString);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *requestURL = [NSURL URLWithString:urlString];
        
        
        [request setURL:requestURL];
        [request setHTTPMethod:@"GET"];
        
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   NSLog(@"ERROR = %@",error.localizedDescription);
                                   if(error.localizedDescription == NULL)
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> succ %@",returnString);
                                       [delegate ConnectionDidFinishLoading:returnString : @"sendMessages"];
                                   }
                                   else
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> fail %@",returnString);
                                       [delegate ConnectiondidFailWithError:returnString : @"sendMessages"];
                                   }
                                   
                               }];
        
            }
    
    
}

-(void)getNotification: (NSString *)user_id{
    
     if ([self connectedToWiFi]){
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@/getNotification?user_id=%@", BASE_URL, user_id];
        
        
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"urlString is %@", urlString);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *requestURL = [NSURL URLWithString:urlString];
        
        
        [request setURL:requestURL];
        [request setHTTPMethod:@"GET"];
        
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   NSLog(@"ERROR = %@",error.localizedDescription);
                                   if(error.localizedDescription == NULL)
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> succ %@",returnString);
                                       [delegate ConnectionDidFinishLoading:returnString : @"getNotification"];
                                   }
                                   else
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> fail %@",returnString);
                                       [delegate ConnectiondidFailWithError:returnString : @"getNotification"];
                                   }
                                   
                               }];
        
    }

}




-(void)uploadMsgImg:(NSString *)user_to :(NSString *)user_from :(NSString *)last_id :(NSString *)status :(NSData *)image{
//    
//    NSLog(@"userto--> %@", user_to);
//    NSLog(@"user_from--> %@", user_from);
//    NSLog(@"last_id--> %@", last_id);
//    NSLog(@"status--> %@", status);
//    NSLog(@"image--> %@", image);
    
    
    
    if ([self connectedToWiFi]){
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@/uploadMsgImg", BASE_URL];
        NSLog(@"urlString is %@", urlString);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *requestURL = [NSURL URLWithString:urlString];
        
        [request setURL:requestURL];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"user_to\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",user_to] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"user_from\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",user_from] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"last_id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",last_id] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"status\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",status] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[@"Content-Disposition: form-data; name=\"%image\"; filename=\"item.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Append ID with image name
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@_%@_item.png\"\r\n" , user_to, user_from] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [body appendData:image];
        
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // final boundary
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        [request setHTTPBody:body];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   NSLog(@"ERROR = %@",error.localizedDescription);
                                   if(error.localizedDescription == NULL)
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> succ %@",returnString);
                                       [delegate ConnectionDidFinishLoading:returnString : @"uploadMsgImg"];
                                   }
                                   else
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> fail %@",returnString);
                                       [delegate ConnectiondidFailWithError:returnString : @"uploadMsgImg"];
                                   }
                                   
                               }];
        
    }
    

}

-(void)get_gallery :(NSString *)user_id{
    
    if ([self connectedToWiFi]){
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@/gallery/%@", BASE_URL, user_id];
        
        
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"urlString is %@", urlString);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *requestURL = [NSURL URLWithString:urlString];
        
        
        [request setURL:requestURL];
        [request setHTTPMethod:@"GET"];
        
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   NSLog(@"ERROR = %@",error.localizedDescription);
                                   if(error.localizedDescription == NULL)
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> succ %@",returnString);
                                       [delegate ConnectionDidFinishLoading:returnString : @"get_gallery"];
                                   }
                                   else
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> fail %@",returnString);
                                       [delegate ConnectiondidFailWithError:returnString : @"get_gallery"];
                                   }
                                   
                               }];
        
    }
    
    
}


-(void)insert_payment_information :(NSString *)user_id :(NSString *)paymentInfo{
    
    if ([self connectedToWiFi]){
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@/insertPaymentInfo", BASE_URL];
        
        
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"urlString is %@", urlString);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *requestURL = [NSURL URLWithString:urlString];
        
        
        [request setURL:requestURL];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        //param 1
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"user_id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",user_id] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //param 2
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"paymentInfo\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",paymentInfo] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [request setHTTPBody:body];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   NSLog(@"ERROR = %@",error.localizedDescription);
                                   if(error.localizedDescription == NULL)
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> succ %@",returnString);
                                       [delegate ConnectionDidFinishLoading:returnString : @"insertPaymentInfo"];
                                   }
                                   else
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> fail %@",returnString);
                                       [delegate ConnectiondidFailWithError:returnString : @"insertPaymentInfo"];
                                   }
                                   
                               }];
        
    }

}

-(void)get_payment_information:(NSString *)user_id{
    
    if ([self connectedToWiFi]){
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@/getPayInfo?user_id=%@", BASE_URL, user_id];
        
        
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"urlString is %@", urlString);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *requestURL = [NSURL URLWithString:urlString];
        
        
        [request setURL:requestURL];
        [request setHTTPMethod:@"GET"];
        
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   NSLog(@"ERROR = %@",error.localizedDescription);
                                   if(error.localizedDescription == NULL)
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> succ %@",returnString);
                                       [delegate ConnectionDidFinishLoading:returnString : @"get_payment_information"];
                                   }
                                   else
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> fail %@",returnString);
                                       [delegate ConnectiondidFailWithError:returnString : @"get_payment_information"];
                                   }
                                   
                               }];
        
    }
    
}

-(void)get_events:(NSString *)user_id{
    
    if ([self connectedToWiFi]){
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@/getEvents?user_id=%@", BASE_URL,user_id];
        
        
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"urlString is %@", urlString);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *requestURL = [NSURL URLWithString:urlString];
        
        
        [request setURL:requestURL];
        [request setHTTPMethod:@"GET"];
        
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   NSLog(@"ERROR = %@",error.localizedDescription);
                                   if(error.localizedDescription == NULL)
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> succ %@",returnString);
                                       [delegate ConnectionDidFinishLoading:returnString : @"get_events"];
                                   }
                                   else
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> fail %@",returnString);
                                       [delegate ConnectiondidFailWithError:returnString : @"get_events"];
                                   }
                                   
                               }];
        
    }
    
    
}

-(void)insert_event:(NSString *)event_title :(NSString *)event_detail :(NSString *)start_time :(NSString *)end_time :(NSString *)user_to :(NSString *)user_from{
    
    if ([self connectedToWiFi]){
        
        
        NSLog(@"title-->%@", event_title);
        NSLog(@"detail-->%@", event_detail);
        NSLog(@"start---> %@", start_time); //2014-07-27 15:25:00
        NSLog(@"end---> %@", end_time);
        NSLog(@"user_to--> %@", user_to);    //10_3_4_6
        NSLog(@"user_from--> %@", user_from);
        
        
        
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@/events?title=%@&detail=%@&start=%@&end=%@&user_to=%@&user_from=%@",BASE_URL, event_title, event_detail, start_time, end_time, user_to, user_from];
        

        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"urlString is %@", urlString);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *requestURL = [NSURL URLWithString:urlString];
        
        
        [request setURL:requestURL];
        [request setHTTPMethod:@"GET"];

        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   NSLog(@"ERROR = %@",error.localizedDescription);
                                   if(error.localizedDescription == NULL)
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> succ %@",returnString);
                                       [delegate ConnectionDidFinishLoading:returnString : @"insert_event"];
                                   }
                                   else
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> fail %@",returnString);
                                       [delegate ConnectiondidFailWithError:returnString : @"insert_event"];
                                   }
                                   
                               }];
        
    }

}

-(void)getCountries{
 
    if ([self connectedToWiFi]){
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@/getCountries", BASE_URL];
        
        
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"urlString is %@", urlString);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *requestURL = [NSURL URLWithString:urlString];
        
        
        [request setURL:requestURL];
        [request setHTTPMethod:@"GET"];
        
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   NSLog(@"ERROR = %@",error.localizedDescription);
                                   if(error.localizedDescription == NULL)
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> succ %@",returnString);
                                       [delegate ConnectionDidFinishLoading:returnString : @"getCountries"];
                                   }
                                   else
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> fail %@",returnString);
                                       [delegate ConnectiondidFailWithError:returnString : @"getCountries"];
                                   }
                                   
                               }];
        

    }

}


-(void)getAllAgents{
    
    if ([self connectedToWiFi]){
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@/getAllAgents", BASE_URL];
        
        
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"urlString is %@", urlString);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *requestURL = [NSURL URLWithString:urlString];
        
        
        [request setURL:requestURL];
        [request setHTTPMethod:@"GET"];
        
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   NSLog(@"ERROR = %@",error.localizedDescription);
                                   if(error.localizedDescription == NULL)
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> succ %@",returnString);
                                       [delegate ConnectionDidFinishLoading:returnString : @"getAllAgents"];
                                   }
                                   else
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> fail %@",returnString);
                                       [delegate ConnectiondidFailWithError:returnString : @"getAllAgents"];
                                   }
                                   
                               }];
        
        
    }
    

}

//-(void)create_client:(NSString *)fname :(NSString *)lname :(NSString *)country_id :(NSString *)dob :(NSString *)username :(NSString *)email :(NSString *)password :(NSString *)gender :(NSString *)status_user :(NSString *)agent_ids{

-(void)create_client:(NSString *)fname :(NSString *)lname :(NSString *)country_id :(NSString *)username :(NSString *)email :(NSString *)password :(NSString *)status_user :(NSString *)agent_ids{

     if ([self connectedToWiFi]){
         
         
//         NSString *urlString = [NSString stringWithFormat:@"http://www.demii.com/demo/blus-app/apps/createUser?fname=%@&lname=%@&country_id=%@&dob=%@&username=%@&email=%@&pass=%@&gender=%@&status_user=%@&agent_id=%@", fname, lname, country_id, dob, username, email, password,gender,status_user,agent_ids];

         NSString *urlString = [NSString stringWithFormat:@"%@/createUser?fname=%@&lname=%@&country_id=%@&username=%@&email=%@&pass=%@&status_user=%@&agent_id=%@", BASE_URL ,fname, lname, country_id, username, email, password, @"1",agent_ids];
    
         urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
         NSLog(@"urlString is %@", urlString);
    
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *requestURL = [NSURL URLWithString:urlString];
        
        
        [request setURL:requestURL];
        [request setHTTPMethod:@"GET"];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   NSLog(@"ERROR = %@",error.localizedDescription);
                                   if(error.localizedDescription == NULL)
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> succ %@",returnString);
                                       [delegate ConnectionDidFinishLoading:returnString : @"create_client"];
                                   }
                                   else
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> fail %@",returnString);
                                       [delegate ConnectiondidFailWithError:returnString : @"create_client"];
                                   }
                                   
                               }];
        
     }


}



-(void)delEvents:(NSString *)event_id{
   

    if ([self connectedToWiFi]){
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@/delEvents?id=%@",BASE_URL, event_id];
        
        
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"urlString is %@", urlString);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *requestURL = [NSURL URLWithString:urlString];
        
        
        [request setURL:requestURL];
        [request setHTTPMethod:@"GET"];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   NSLog(@"ERROR = %@",error.localizedDescription);
                                   if(error.localizedDescription == NULL)
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> succ %@",returnString);
                                       [delegate ConnectionDidFinishLoading:returnString : @"delEvents"];
                                   }
                                   else
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> fail %@",returnString);
                                       [delegate ConnectiondidFailWithError:returnString : @"delEvents"];
                                   }
                                   
                               }];
        
    }

    
}

-(void)delMsgs:(NSString *)server_msg_id{
    
    if ([self connectedToWiFi]){
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@/delMsgs?server_msg_id=%@",BASE_URL, server_msg_id];
        
        
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"urlString is %@", urlString);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *requestURL = [NSURL URLWithString:urlString];
        
        
        [request setURL:requestURL];
        [request setHTTPMethod:@"GET"];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   NSLog(@"ERROR = %@",error.localizedDescription);
                                   if(error.localizedDescription == NULL)
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> succ %@",returnString);
                                       [delegate ConnectionDidFinishLoading:returnString : @"delMsgs"];
                                   }
                                   else
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> fail %@",returnString);
                                       [delegate ConnectiondidFailWithError:returnString : @"delMsgs"];
                                   }
                                   
                               }];
        
    }

}


-(void)inviteClientsForEvent:(NSString *)user_from :(NSString *)user_to :(NSString *)event_id :(NSString *)status{
    
    if([self connectedToWiFi]){
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@/inviteClientsForEvent?user_from=%@&user_to=%@&event_id=%@&status=%@", BASE_URL, user_from, user_to,event_id, status];
        
        
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"urlString is %@", urlString);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *requestURL = [NSURL URLWithString:urlString];
        
        
        [request setURL:requestURL];
        [request setHTTPMethod:@"GET"];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   NSLog(@"ERROR = %@",error.localizedDescription);
                                   if(error.localizedDescription == NULL)
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> succ %@",returnString);
                                       [delegate ConnectionDidFinishLoading:returnString : @"inviteClientsForEvent"];
                                   }
                                   else
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> fail %@",returnString);
                                       [delegate ConnectiondidFailWithError:returnString : @"inviteClientsForEvent"];
                                   }
                                   
                               }];
        
    }
    
}

-(void)forgetPassword :(NSString *)email_address{
    
    if([self connectedToWiFi]){
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@/forgotPassword?email=%@", BASE_URL, email_address];
        
        
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"urlString is %@", urlString);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *requestURL = [NSURL URLWithString:urlString];
        
        
        [request setURL:requestURL];
        [request setHTTPMethod:@"GET"];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   NSLog(@"ERROR = %@",error.localizedDescription);
                                   if(error.localizedDescription == NULL)
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> succ %@",returnString);
                                       [delegate ConnectionDidFinishLoading:returnString : @"forgetPassword"];
                                   }
                                   else
                                   {
                                       NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"response >>>>>>>>> fail %@",returnString);
                                       [delegate ConnectiondidFailWithError:returnString : @"forgetPassword"];
                                   }
                                   
                               }];
        
    }
}

@end