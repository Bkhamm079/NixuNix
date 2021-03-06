//
//  KBADocumentController.m
//  Kiba
//
//  Created by Michael Schaarschmidt on 03.12.13.
//  Copyright (c) 2013 KiBa App. All rights reserved.
//

#import "KBADocContr.h"


@interface KBADocContr ()
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* topConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* leftConstraint;


@end

@implementation KBADocContr

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Bescheinigungen";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self respondToOrientation: UIApplication.sharedApplication.statusBarOrientation
        inAnimatedDurationTime: 0.0];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)respondToOrientation:(UIInterfaceOrientation)orientation
     inAnimatedDurationTime:(double)duration
{
    [UIView animateWithDuration:duration
                     animations:^{
                         //animations if switch to portrait-mode
                         if (orientation == UIInterfaceOrientationPortrait ||
                             orientation == UIInterfaceOrientationPortraitUpsideDown) {
                             
                             self.topConstraint.constant = 240;
                             self.leftConstraint.constant = 190;
                         }
                          //animations if switch to landscape-mode
                         else{
                             self.topConstraint.constant = 137;
                             self.leftConstraint.constant = 145;
                         }
                         [self.view setNeedsLayout];
                     }];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                               duration:(NSTimeInterval)duration
{
    [self respondToOrientation:toInterfaceOrientation
        inAnimatedDurationTime: 0.2];
}

-(IBAction)generatePDF:(id)sender{
   
    NSLog(@"pdf");
}


@end
