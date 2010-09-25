//
//  PenetrateAppDelegate.m
//  Penetrate
//
//  Created by Ruben Fonseca on 7/8/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "PenetrateAppDelegate.h"


@implementation PenetrateAppDelegate

@synthesize window;
@synthesize tabBarController;

@synthesize db = _db;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // Add the tab bar controller's view to the window and display.
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
  
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self performSelector:@selector(closeDatabase)];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
  [self performSelector:@selector(openDatabase)];
}


- (void)applicationWillTerminate:(UIApplication *)application {
  [self.db close];
}


#pragma mark -
#pragma mark UITabBarControllerDelegate methods

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

-(void)openDatabase {
  NSLog(@"Opening database");
  
  NSString *dbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"database.sqlite3"];
  _db = [[FMDatabase databaseWithPath:dbPath] retain];
  NSAssert([self.db open], @"Can't open database");
  
  [self.db setTraceExecution:YES];
  [self.db setLogsErrors:YES];
  [self.db setCrashOnErrors:YES];
}

-(void)closeDatabase {
  NSLog(@"Closing database");
  
  [_db close];
  [_db release];
  _db = nil;
}

- (void)dealloc {
  [self.db release];
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

