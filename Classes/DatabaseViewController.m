//
//  DatabaseViewController.m
//  Penetrate
//
//  Created by Ruben Fonseca on 7/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DatabaseViewController.h"

#import "FMResultSet.h"

@implementation DatabaseViewController
@synthesize tableView = _tableView;
@synthesize ssidTableViewCell = _ssidTableViewCell;
@synthesize ssidTextField = _ssidTextField;
@synthesize results = _results;
@synthesize banner = _banner;
@synthesize bannerIsVisible = _bannerIsVisible;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
  
  self.results = [[NSMutableArray alloc] init];
  self.navigationItem.title = @"Penetrate";
  self.bannerIsVisible = true;
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if(section == 0)
    return @"Enter SSID name";
  else
    return @"Results";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
  if(section == 0)
    return nil;
  else {
    if([self.results count] > 0)
      return [NSString stringWithFormat:@"Found %d results", [self.results count]];
    else
      return @"No results found";
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if(section == 0)
    return 2;
  else
    return [self.results count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([indexPath section] == 0 && [indexPath row] == 0)
      return self.ssidTableViewCell;
  
    static NSString* DataIdentifier = @"DataCell";
    static NSString* ResultIdentifier = @"ResultCell";
  
  NSString *identifier = [indexPath section] == 0 ? DataIdentifier : ResultIdentifier;
  
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
  if([indexPath section] == 0) {
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.textLabel.text = @"Search";
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
  } else {
    cell.textLabel.text = (NSString*) [self.results objectAtIndex:[indexPath row]];
  }

  return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if([indexPath section] == 0 && [indexPath row] == 1) {
    [self search:tableView];
  } else {
    UIPasteboard *b = [UIPasteboard generalPasteboard];
    b.string = [self.results objectAtIndex:[indexPath row]];
    
    [tableView cellForRowAtIndexPath:indexPath].textLabel.text = [NSString stringWithFormat:@"%@ (copied)", (NSString*) [self.results objectAtIndex:[indexPath row]]];
  }
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark Methods
- (IBAction)search:(id)sender {
  NSString *text = [self.ssidTextField.text uppercaseString];
  
  if([text length] < 6) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid SSID"
                                                    message:@"The SSID must have at least 6 characters"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    return;
  }
  
  text = [text substringWithRange:NSMakeRange([text length] - 6, 6)];
  [self.ssidTextField resignFirstResponder];
  
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  
  dispatch_async(queue, ^{
    FMResultSet *rs = [APP_DELEGATE.db executeQuery:@"SELECT key FROM database WHERE ssid = ?" withArgumentsInArray:[NSArray arrayWithObject:text]];
  
    [self.results removeAllObjects];
    
    while([rs next]) {
      [self.results addObject:[rs stringForColumnIndex:0]];
    }
    [rs close];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    });
  });
}

#pragma mark -
#pragma mark UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self search:textField];
  return YES;
}

#pragma mark -
#pragma mark ABBannerViewDelegate
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
  if (self.bannerIsVisible) {
    [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
    self.tableView.frame = CGRectUnion(self.tableView.frame, banner.frame);
    banner.frame = CGRectOffset(banner.frame, 0, 50);
    [UIView commitAnimations];
    self.bannerIsVisible = NO;
  }
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
  [_results dealloc];
  
  [self.ssidTextField dealloc];
  [self.ssidTableViewCell dealloc];
  [self.banner dealloc];
    [self.tableView dealloc];
    [super dealloc];
}


@end

