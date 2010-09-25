//
//  DatabaseViewController.h
//  Penetrate
//
//  Created by Ruben Fonseca on 7/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/ADBannerView.h>

@interface DatabaseViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, ADBannerViewDelegate> {
    
  UITableView *_tableView;
  UITableViewCell *_ssidTableViewCell;
  UITextField *_ssidTextField;
  ADBannerView *_banner;
  
  NSMutableArray *_results;
  
  bool _bannerIsVisible;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITableViewCell *ssidTableViewCell;
@property (nonatomic, retain) IBOutlet UITextField *ssidTextField;
@property (nonatomic, retain) IBOutlet ADBannerView *banner;

@property (nonatomic, retain) NSMutableArray *results;

@property (nonatomic, assign) bool bannerIsVisible;

- (IBAction)search:(id)sender;

@end
