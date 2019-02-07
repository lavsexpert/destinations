//
//  ViewController.m
//  PeerReview04
//
//  Created by Sergey Lavrov on 07.02.2019.
//  Copyright © 2019 +1. All rights reserved.
//

#import "ViewController.h"
#import "DistanceGetter/DGDistanceRequest.h"

@interface ViewController ()

@property (nonatomic) DGDistanceRequest *req;

@property (weak, nonatomic) IBOutlet UITextField *startLocation;
@property (weak, nonatomic) IBOutlet UISegmentedControl *unitController;

@property (weak, nonatomic) IBOutlet UITextField *endLocationA;
@property (weak, nonatomic) IBOutlet UILabel *distanceA;
@property (weak, nonatomic) IBOutlet UITextField *endLocationB;
@property (weak, nonatomic) IBOutlet UILabel *distanceB;
@property (weak, nonatomic) IBOutlet UITextField *endLocationC;
@property (weak, nonatomic) IBOutlet UILabel *distanceC;
@property (weak, nonatomic) IBOutlet UITextField *endLocationD;
@property (weak, nonatomic) IBOutlet UILabel *distanceD;

@property (weak, nonatomic) IBOutlet UIButton *calculateButton;

@end

@implementation ViewController

- (IBAction)calculateButtonTapped:(id)sender {
    self.calculateButton.enabled = NO;
    self.req = [DGDistanceRequest alloc];
    NSString *start = self.startLocation.text;
    NSString *destA = self.endLocationA.text;
    NSString *destB = self.endLocationB.text;
    NSString *destC = self.endLocationC.text;
    NSString *destD = self.endLocationD.text;
    NSArray *dests = @[destA, destB, destC, destD];
    
    self.req = [self.req initWithLocationDescriptions:dests sourceDescription:start];
    
    __weak ViewController *weakSelf = self;
    
    self.req.callback = ^(NSArray *responses){
        ViewController *strongSelf = weakSelf;
        if(!strongSelf)return;
        NSNull *badResult = [NSNull null];
        if(responses[0] != badResult){
            NSInteger unitSegment = strongSelf.unitController.selectedSegmentIndex;
            strongSelf.distanceA.text = [strongSelf getDistance :unitSegment :responses[0]];
            strongSelf.distanceB.text = [strongSelf getDistance :unitSegment :responses[1]];
            strongSelf.distanceC.text = [strongSelf getDistance :unitSegment :responses[2]];
            strongSelf.distanceD.text = [strongSelf getDistance :unitSegment :responses[3]];
        } else {
            strongSelf.distanceA.text = @"Error";
        }
        
        strongSelf.req = nil;
        strongSelf.calculateButton.enabled = YES;
    };
    
    [self.req start];
    
}

- (NSString*) getDistance :(NSInteger)index :(id)distance {
    if(index == 0){
        return [NSString stringWithFormat:@"%.0f m",([distance floatValue]/1.0)];
    } else if(index == 1) {
        return [NSString stringWithFormat:@"%.2f km",([distance floatValue]/1000.0)];
    } else {
        return [NSString stringWithFormat:@"%.2f miles",([distance floatValue]/525)];
    }
}

@end
