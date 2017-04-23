//
//  ViewController.m
//  DistanceCalculator
//
//  Created by Joseph Apps on 20/04/2017.
//  Copyright © 2017 Joseph Apps. All rights reserved.
//

#import "ViewController.h"
#import "DistanceGetter/DGDistanceRequest.h"


@interface ViewController ()

@property (nonatomic) DGDistanceRequest *request;

@property (weak, nonatomic) IBOutlet UITextField *sourceLocationField;

@property (weak, nonatomic) IBOutlet UITextField *destinationField1;
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel1;

@property (weak, nonatomic) IBOutlet UITextField *destinationField2;
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel2;

@property (weak, nonatomic) IBOutlet UITextField *destinationField3;
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel3;

@property (weak, nonatomic) IBOutlet UITextField *destinationField4;
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel4;


@property (weak, nonatomic) IBOutlet UISegmentedControl *distanceUnitSegment;
@property (weak, nonatomic) IBOutlet UIButton *calculateButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)calculateButtonTapped:(id)sender {
    
    self.calculateButton.enabled = NO;
    
    double distanceConversionFactor = 0.001; // meters to kilometers
    NSString *distanceUnit = @"km";
    
    if(self.distanceUnitSegment.selectedSegmentIndex == 1) {
        
        // kilometer to miles
        distanceConversionFactor = distanceConversionFactor * 0.62137;
        distanceUnit = @"mi";
        
    } else if(self.distanceUnitSegment.selectedSegmentIndex == 2) {
        
        // kilometers to yards
        distanceConversionFactor = distanceConversionFactor * 1093.6133;
        distanceUnit = @"yd";
    }
    
    NSString *source = self.sourceLocationField.text;
    NSString *dest1 = self.destinationField1.text;
    NSString *dest2 = self.destinationField2.text;
    NSString *dest3 = self.destinationField3.text;
    NSString *dest4 = self.destinationField4.text;
    NSArray *destinations = @[dest1, dest2, dest3, dest4];
    
    self.request = [DGDistanceRequest alloc];
    self.request = [self.request initWithLocationDescriptions:destinations sourceDescription:source];
    
    __weak ViewController *weakSelf = self;
    
    self.request.callback =^(NSArray *distances) {
        
        ViewController *strongSelf = weakSelf;
        
        if(!strongSelf) {
            return;
        }
        
        NSNull *badResult = [NSNull null];
        
        
        if(distances[0] != badResult) {
        
            double distance = [distances[0] doubleValue] * distanceConversionFactor;
            strongSelf.destinationLabel1.text = [NSString stringWithFormat:@"%.2f %@", distance, distanceUnit];
        }
        
        if(distances[1] != badResult) {
            
            double distance = [distances[1] doubleValue] * distanceConversionFactor;
            strongSelf.destinationLabel2.text = [NSString stringWithFormat:@"%.2f %@", distance, distanceUnit];
        }
        
        if(distances[2] != badResult) {
            
            double distance = [distances[2] doubleValue] * distanceConversionFactor;
            strongSelf.destinationLabel3.text = [NSString stringWithFormat:@"%.2f %@", distance, distanceUnit];
        }
        
        if(distances[3] != badResult) {
            
            double distance = [distances[3] doubleValue] * distanceConversionFactor;
            strongSelf.destinationLabel4.text = [NSString stringWithFormat:@"%.2f %@", distance, distanceUnit];
        }
        
        strongSelf.request = nil;
        strongSelf.calculateButton.enabled = YES;
    };
    
    [self.request start];
}


@end
