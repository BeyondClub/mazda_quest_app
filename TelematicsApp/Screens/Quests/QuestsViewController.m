//
//  QuestsViewController.m
//  TelematicsApp
//
//  Created by Keshav Infotech on 04/11/23.
//  Copyright © 2023 DATA MOTION PTE. LTD. All rights reserved.
//

#import "QuestsViewController.h"
#import "WebKit/WebKit.h"
#import "SettingsViewController.h"

@interface QuestsViewController () <WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@end

@implementation QuestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.navigationDelegate = self;
    
    UITabBarItem *tabBarItem1 = [self.tabBarController.tabBar.items objectAtIndex:[[Configurator sharedInstance].questsTabBarNumber intValue]];
    [tabBarItem1 setImage:[[UIImage imageNamed:@"quests_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem1 setSelectedImage:[[UIImage imageNamed:@"quests_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem1 setTitle:localizeString(@"quests_title")];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://mazda.staging.beyondclub.xyz/quests?device_token=%@&user_id=%@",[GeneralService sharedService].device_token_number, [GeneralService sharedService].firebase_user_id]]]];
}

- (IBAction)settingsBtnAction:(id)sender {
    SettingsViewController *settingsVC = [[UIStoryboard storyboardWithName:@"Settings" bundle:nil] instantiateInitialViewController];
    [self presentViewController:settingsVC animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self.activityIndicatorView startAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.activityIndicatorView stopAnimating];
}

@end
