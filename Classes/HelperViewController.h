//
//  HelperViewController.h
//  Penetrate
//
//  Created by Ruben Fonseca on 7/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HelperViewController : UIViewController {
  UIWebView *_webView;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;

@end
