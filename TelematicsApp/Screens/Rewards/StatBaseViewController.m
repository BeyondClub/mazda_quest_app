//
//  StatBaseViewController.m
//  TelematicsApp
//
//  Created by Keshav Infotech on 07/11/23.
//  Copyright © 2023 DATA MOTION PTE. LTD. All rights reserved.
//

#import "StatBaseViewController.h"
#import "DashMainViewController.h"
#import "LeaderboardViewCtrl.h"
#import "DriveCoinsViewController.h"
#import "SettingsViewController.h"

@interface StatBaseViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *baseScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indicatorLabelLeadingConstraint;
@property (weak, nonatomic) IBOutlet UIButton *driveScoreButton;
@property (weak, nonatomic) IBOutlet UIButton *pointsButton;
@property (weak, nonatomic) IBOutlet UIButton *leaderboardButton;
@property (weak, nonatomic) IBOutlet UIView *headerButtonView;

@end

@implementation StatBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITabBarItem *tabBarItem3 = [self.tabBarController.tabBar.items objectAtIndex:[[Configurator sharedInstance].statsTabBarNumber intValue]];
    [tabBarItem3 setImage:[[UIImage imageNamed:@"rewards_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem3 setSelectedImage:[[UIImage imageNamed:@"rewards_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem3 setTitle:localizeString(@"rewards_title")];
    
    [_pointsButton setTitleColor:[Color grayLineColor] forState:UIControlStateNormal];
    [_leaderboardButton setTitleColor:[Color grayLineColor] forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupScrollView];
}

- (void)setupScrollView {
    
    DashMainViewController *dashboardView = [[UIStoryboard storyboardWithName:@"DashboardMain" bundle:nil] instantiateViewControllerWithIdentifier:@"DashMainViewController"];
    dashboardView.isFromStats = YES;
    
    LeaderboardViewCtrl *leaderboardView = [[UIStoryboard storyboardWithName:@"Leaderboard" bundle:nil] instantiateInitialViewController];
    DriveCoinsViewController *driverCoinsView = [[UIStoryboard storyboardWithName:@"Rewards" bundle:nil] instantiateViewControllerWithIdentifier:@"DriveCoinsViewController"];
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGFloat width = bounds.size.width;
    CGFloat height = _baseScrollView.frame.size.height;
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithObjects:dashboardView, driverCoinsView, leaderboardView, nil];
    _baseScrollView.contentSize = CGSizeMake((self.view.frame.size.width * 3), _baseScrollView.frame.size.height);
    
    int idx = 0;
    for (UIViewController *viewController in viewControllers) {
        [self addChildViewController:viewController];
        CGFloat originX = idx * width;
        viewController.view.frame = CGRectMake(originX, 0, width, height);
        [_baseScrollView addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
        idx++;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat scrolledPosition = scrollView.contentOffset.x / scrollView.contentSize.width;
    
    if (!isnan(scrolledPosition)) {
        self.indicatorLabelLeadingConstraint.constant = self.view.frame.size.width * scrolledPosition;
        [self.headerButtonView layoutIfNeeded];
    }
    
    CGFloat pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width);
    if (pageNumber == 0.0) {
        [_driveScoreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_pointsButton setTitleColor:[Color grayLineColor] forState:UIControlStateNormal];
        [_leaderboardButton setTitleColor:[Color grayLineColor] forState:UIControlStateNormal];
    } else if (pageNumber == 1.0) {
        [_driveScoreButton setTitleColor:[Color grayLineColor] forState:UIControlStateNormal];
        [_pointsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_leaderboardButton setTitleColor:[Color grayLineColor] forState:UIControlStateNormal];
    } else if (pageNumber == 2.0) {
        [_driveScoreButton setTitleColor:[Color grayLineColor] forState:UIControlStateNormal];
        [_pointsButton setTitleColor:[Color grayLineColor] forState:UIControlStateNormal];
        [_leaderboardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

- (IBAction)settingsBtnAction:(id)sender {
    SettingsViewController *settingsVC = [[UIStoryboard storyboardWithName:@"Settings" bundle:nil] instantiateInitialViewController];
    [self presentViewController:settingsVC animated:YES completion:nil];
}

- (IBAction)driveScoreButtonTouchUp:(UIButton *)sender {
    [self.baseScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (IBAction)pointsButtonTouchUp:(UIButton *)sender {
    CGFloat width = self.baseScrollView.frame.size.width;
    [self.baseScrollView setContentOffset:CGPointMake(width, 0) animated:YES];
}

- (IBAction)leaderboardButtonTouchUp:(UIButton *)sender {
    CGFloat width = self.baseScrollView.frame.size.width;
    [self.baseScrollView setContentOffset:CGPointMake(width * 2, 0) animated:YES];
}


@end
