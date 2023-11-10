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

@end

@implementation DriveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.headerView.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(30.0, 30.0)];

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.headerView.bounds;
    maskLayer.path  = maskPath.CGPath;

    self.headerView.layer.mask = maskLayer;
}

@end
