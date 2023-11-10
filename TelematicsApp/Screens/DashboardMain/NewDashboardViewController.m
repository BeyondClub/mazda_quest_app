//
//  NewDashboardViewController.m
//  TelematicsApp
//
//  Created by Keshav Infotech on 10/11/23.
//  Copyright © 2023 DATA MOTION PTE. LTD. All rights reserved.
//

#import "NewDashboardViewController.h"

@interface NewDashboardViewController ()

@end

@implementation NewDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITabBarItem *tabBarItem0 = [self.tabBarController.tabBar.items objectAtIndex:[[Configurator sharedInstance].dashboardTabBarNumber intValue]];
    [tabBarItem0 setImage:[[UIImage imageNamed:@"dashboard_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem0 setSelectedImage:[[UIImage imageNamed:@"dashboard_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem0 setTitle:localizeString(@"dashboard_title")];
}

@end
