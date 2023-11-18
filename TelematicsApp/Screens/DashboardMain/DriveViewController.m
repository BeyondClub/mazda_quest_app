//
//  DriveViewController.m
//  TelematicsApp
//
//  Created by Keshav Infotech on 10/11/23.
//  Copyright © 2023 DATA MOTION PTE. LTD. All rights reserved.
//

#import "DriveViewController.h"

@interface DriveViewController ()
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dotLabel;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger secondsPassed;
@end

@implementation DriveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITabBarItem *tabBarItem0 = [self.tabBarController.tabBar.items objectAtIndex:[[Configurator sharedInstance].dashboardTabBarNumber intValue]];
    [tabBarItem0 setImage:[[UIImage imageNamed:@"dashboard_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem0 setSelectedImage:[[UIImage imageNamed:@"dashboard_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem0 setTitle:localizeString(@"dashboard_title")];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.headerView.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(30.0, 30.0)];

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.headerView.bounds;
    maskLayer.path  = maskPath.CGPath;

    self.headerView.layer.mask = maskLayer;
    
    self.dotLabel.layer.cornerRadius = 6;
    self.dotLabel.clipsToBounds = TRUE;
    
    self.secondsPassed = 0;
    
    //[RPEntry instance].accuracyAuthorizationDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSDate *savedStartTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"startTime"];
    if (savedStartTime) {
        NSTimeInterval elapsed = [[NSDate date] timeIntervalSinceDate:savedStartTime];
        self.secondsPassed = (NSInteger)elapsed;
        [self updateLabel];
        [self startTimer];
    } else {
        self.secondsPassed = 0;
        self.durationLabel.text = @"00:00:00";
    }
}

// MARK: - Timer Methods
- (void)startTimer {
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    }
}

- (void)pauseTimer {
    [self.timer invalidate];
    self.timer = nil;
    // Save pause time
    NSDate *pauseTime = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:pauseTime forKey:@"pauseTime"];
}

- (void)resetTimer {
    [self.timer invalidate];
    self.timer = nil;
    self.secondsPassed = 0;
    self.durationLabel.text = @"00:00:00";
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"startTime"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pauseTime"];
}

- (void)updateTimer {
    self.secondsPassed++;
    [self updateLabel];
}

- (void)updateLabel {
    NSInteger hours = self.secondsPassed / 3600;
    NSInteger minutes = (self.secondsPassed % 3600) / 60;
    NSInteger seconds = self.secondsPassed % 60;
    self.durationLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
}

//MARK: - Button Actions

- (IBAction)startTripButtonTouchUp:(UIButton *)sender {
    NSDate *savedStartTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"startTime"];
    NSDate *savedPauseTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"pauseTime"];
    
    if (savedPauseTime) {
        NSTimeInterval pauseDuration = [[NSDate date] timeIntervalSinceDate:savedPauseTime];
        savedStartTime = [savedStartTime dateByAddingTimeInterval:pauseDuration];
        [[NSUserDefaults standardUserDefaults] setObject:savedStartTime forKey:@"startTime"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pauseTime"];
    } else if (!savedStartTime) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"startTime"];
    }
    
    [self startTimer];
   
//    [self.startButton setHidden:TRUE];
//    [self.stopButton setHidden:TRUE];
//    [self.pauseButton setHidden:FALSE];
    
    [[RPEntry instance] setEnableSdk:true];
    [RPEntry instance].disableTracking = NO;  //enable tracking
    [[RPTracker instance] startTracking];
}

- (IBAction)pauseTripButtonTouchUp:(UIButton *)sender {
    [self pauseTimer];

    [self.startButton setHidden:FALSE];
    [self.stopButton setHidden:FALSE];
    [self.pauseButton setHidden:TRUE];
}

- (IBAction)stopTripButtonTouchUp:(UIButton *)sender {
    
    [self resetTimer];
    
    [self.startButton setHidden:FALSE];
    [self.stopButton setHidden:FALSE];
    [self.pauseButton setHidden:TRUE];
    
    [[RPTracker instance] stopTracking];
    [RPEntry instance].disableTracking = YES; //disable tracking
    [[RPEntry instance] setDisableWithUpload];
    //[[RPEntry instance] setEnableSdk:false];
}

- (IBAction)backButtonTouchUp:(UIButton *)sender {
    if (@available(iOS 13.0, *)) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        CATransition *transition = [[CATransition alloc] init];
        transition.duration = 0.3;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
        [self.view.window.layer addAnimation:transition forKey:kCATransition];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}



@end
