//
//  NewDashboardViewController.m
//  TelematicsApp
//
//  Created by Keshav Infotech on 10/11/23.
//  Copyright © 2023 DATA MOTION PTE. LTD. All rights reserved.
//

#import "NewDashboardViewController.h"
#import "FeedViewController.h"
#import "SettingsViewController.h"
#import "UIViewController+Preloader.h"

@interface NewDashboardViewController ()
@property (weak, nonatomic) IBOutlet UIImageView                *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel                    *userNameLabel;
@property (strong, nonatomic) TelematicsAppModel                *appModel;
@property (weak, nonatomic) IBOutlet UILabel                    *mtPointLabel;
@end

@implementation NewDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appModel = [TelematicsAppModel MR_findFirstByAttribute:@"current_user" withValue:@1];
    
    if (!self.appModel.notFirstRunApp) {
        [TelematicsAppModel MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"current_user == 1"]];
        self.appModel = [TelematicsAppModel MR_createEntity];
        self.appModel.current_user = @1;
        self.appModel = [TelematicsAppModel MR_findFirstByAttribute:@"current_user" withValue:@1];
        
        [TelematicsLeaderboardModel MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"leaderboard_user == 1"]];
        
        self.appModel.notFirstRunApp = YES;
    }
    
    UITabBarItem *tabBarItem0 = [self.tabBarController.tabBar.items objectAtIndex:[[Configurator sharedInstance].dashboardTabBarNumber intValue]];
    [tabBarItem0 setImage:[[UIImage imageNamed:@"dashboard_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem0 setSelectedImage:[[UIImage imageNamed:@"dashboard_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem0 setTitle:localizeString(@"dashboard_title")];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfo:) name:@"updateUserInfo" object:nil];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self displayUserNavigationBarInfo];
    [self fetchPoints];
}

#pragma mark - Helper Methods

- (void)fetchPoints {
        
    [self showPreloader];
    
    //https://mazda.staging.beyondclub.xyz/api/integration/mazda_get_points?device_token=ba3554f2-5341-413d-8db2-84a134398a5a
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://mazda.staging.beyondclub.xyz/api/integration/mazda_get_points?device_token=%@",[GeneralService sharedService].device_token_number]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hidePreloader];
            });
        } else {
            NSError *jsonError;
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonError) {
                NSLog(@"JSON Error: %@", jsonError);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hidePreloader];
                });
            } else {
                BOOL status = [jsonResponse[@"status"] boolValue];
                //NSNumber *drivePoints = jsonResponse[@"drive_points"];
                //NSNumber *questPoints = jsonResponse[@"quest_points"];
                NSNumber *totalPoints = jsonResponse[@"total_points"];

                if (status) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.mtPointLabel.text = [NSString stringWithFormat:@"%@ MT", totalPoints];
                        [self hidePreloader];
                    });
                }
            }
        }
    }];
    
    [task resume];
}

- (void)displayUserNavigationBarInfo {
    self.userNameLabel.text = self.appModel.userFullName ? self.appModel.userFullName : @"";
    
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2.0;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    if (self.appModel.userPhotoData != nil) {
        self.avatarImageView.image = [UIImage imageWithData:self.appModel.userPhotoData];
    }
}

- (void)updateUserInfo:(NSNotification *)notification {
    if ([[notification name] isEqualToString:@"updateUserInfo"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.userNameLabel.text = self.appModel.userFullName ? self.appModel.userFullName : @"";
            if (self.appModel.userPhotoData != nil) {
                self.avatarImageView.image = [UIImage imageWithData:self.appModel.userPhotoData];
                self.avatarImageView.layer.masksToBounds = YES;
                self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
            }
        });
    }
}

- (IBAction)feedButtonTouchUp:(UIButton *)sender {
    FeedViewController *feed = [[UIStoryboard storyboardWithName:@"Feed" bundle:nil] instantiateInitialViewController];
    if (self.navigationController.presentingViewController) {
        [self.navigationController pushViewController:feed animated:YES];
    } else {
        [self presentViewController:feed animated:YES completion:nil];
    }
}

- (IBAction)settingButtonTouchUp:(UIButton *)sender {
    SettingsViewController *settingsVC = [[UIStoryboard storyboardWithName:@"Settings" bundle:nil] instantiateInitialViewController];
    [self presentViewController:settingsVC animated:YES completion:nil];
}

- (IBAction)collectTokenButtonTouchUp:(UIButton *)sender {
    
}

@end
