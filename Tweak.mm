#import "StraitsTimes/NewsStandViewController.h";
#import "StraitsTimes/InAppPurchaseManager.h";
#import "StraitsTimes/APIManagerResponse.h";
#import "UIKit/UIAlertView.h";
#import "StraitsTimes/WebRequestObject.h";
#import "StraitsTimes/PDFManager.h";
#import "StraitsTimes/ASIHTTPRequest.h";

#import "substrate.h";
/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.
*/
%hook NewsStandViewController 

// Hooking a class method
/*-(void)showPDFEdition {
    NSLog(@"hiiiI!!");
    InAppPurchaseManager* manager = [objc_getClass("InAppPurchaseManager") defaultManager];
    [manager setMadePurchaseInSimulator: YES];
    //get the purchasemanager
    NSLog(@"made purchase in simulator %@, hasexpired %@", manager.madePurchaseInSimulator, [manager hasExpired]); 
	%orig;
}*/
/*-(void)showiPadEdition {
    [[objc_getClass("InAppPurchaseManager") defaultManager] setMadePurchaseInSimulator: YES];
    //get the purchasemanager
	%orig;
}*/
/*-(void)onStoreButtonPressed:(id)pressed {
    NSLog(@"damn.");
    return;
}*/
/*-(void)onPDFDownloading:(id)downloading {
    NSLog(@"downloading: %@", downloading);
}*/
%end
%hook 
%hook InAppPurchaseManager 
-(BOOL)isSimulator {
    BOOL lol = %orig;
    NSLog(@"is simulator %@", lol);
    return lol;
}
/*-(BOOL)hasExpired {
    BOOL expired = %orig;
    NSLog(@"expire %@", expired);
    return expired;
    
}*/
%end
/*%hook PDFManager 

-(id)folderForNewsDate:(id)newsDate {
    NSLog(@"newsdate %@", newsDate);
    id data = %orig;
    NSLog(@"data folderforepre[repkt: %@", data);
    return data;
}

%end*/
%hook APIManager
-(id)loginToSPHServer:(id)sphserver {
    
    NSLog(@"sphserver: %@", sphserver);
    id data = %orig(sphserver);
    NSLog(@"sphserver data: %@", data);
    return data;
}
-(id)serverPath {
    id data = %orig;
    NSLog(@"server path %@", data);
    return data;
}
- (void) setIsServerDown {
    BOOL isServerDown = MSHookIvar<BOOL>(self, "isServerDown");
    isServerDown = NO;
}
- (id) adServerPath {
    return (id) @"http://loe-roeprkefjeofjefjefjf/";
}
%end

%hook UIFloatingAdvertisementControl
-(void)loadAd:(int)ad {
    NSLog(@"ad: %@", ad);
    return;
}
%end
%hook WebRequestObject
-(id) urlString {
    NSString *string = (NSString*) %orig;
    NSLog(@"WEBREQUEST URL: %@", string);
    if ([string rangeOfString:@"ldap"].location != NSNotFound) {
        return (id) @"http://localhost/";
    }
    else {
        return (id) string;
    }
    [string release];
}
%end
/*
%hook ASIHTTPRequest
+(id)requestWithURL:(id)url {
    id data = %orig;
    NSLog(@"request thing %@: %@", url, data);
    return data;
}
%end*/

%hook SPHLoginManager
-(void)onLoginToSPHCompleted:(id)sphcompleted {
    APIManagerResponse *response = (APIManagerResponse*) sphcompleted;
    NSLog(@"data: %@", sphcompleted);   
    NSLog(@"responsedcit: %@", response.result);
    if ([response.result count] == 0) {
        %orig(sphcompleted);
    }
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Success", @"Active",
                          @"Success", @"User-Password",
                          @"Success", @"Service", nil];
    response.result = dict;
    %orig((id) response);
}
-(void)loginToSPHServerAtStartup:(id)startup {
    APIManagerResponse *response = (APIManagerResponse*) startup;  
    NSLog(@"responsedcit: %@", response.result);
    if ([response.result count] == 0) {
        %orig(startup);
    }
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Success", @"Active",
                          @"Success", @"User-Password",
                          @"Success", @"Service", nil];
    response.result = dict;
    %orig((id) response);
}
%end

/*
 // Hooking an instance method with an argument.
- (void)messageName:(int)argument {
	%log; // Write a message about this call, including its class, name and arguments, to the system log.

	%orig; // Call through to the original function with its original arguments.
	%orig(nil); // Call through to the original function with a custom argument.

	// If you use %orig(), you MUST supply all arguments (except for self and _cmd, the automatically generated ones.)
}

// Hooking an instance method with no arguments.
- (id)noArguments {
	%log;
	id awesome = %orig;
	[awesome doSomethingElse];

	return awesome;
}

// Always make sure you clean up after yourself; Not doing so could have grave consequences!
%end
*/
