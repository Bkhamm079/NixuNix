//
//  KBAAuthController.m
//  Kiba
//
//  Created by 1fasselt on 26.11.13.
//  Copyright (c) 2013 KiBa App. All rights reserved.
//

#import "KBAMasterViewController.h"
#import "KBAAuthController.h"
#import "SVProgressHUDViewController.h"
#import "SVProgressHUD.h"
#import "JVFloatLabeledTextField.h"
#import "KBAAuthAdvantagesController.h"
#import "KBADependencyInjector.h"
#import "KBAAuth.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface KBAAuthController ()

@property (strong) UIPopoverController *popController;
@property (nonatomic, weak) IBOutlet JVFloatLabeledTextField *authCodeField;
@property (nonatomic, weak) IBOutlet UIView *comicView;
@property (nonatomic, weak) IBOutlet KBAButton *validateButton;
@property (nonatomic, weak) IBOutlet KBAButton *advantagesButton;
@property (nonatomic, strong) KBAAuthAdvantagesController *advantagesController;
@property (atomic, strong) NSTimer *timer;
@property (nonatomic, retain) IBOutlet TPKeyboardAvoidingScrollView *scrollView;

- (IBAction)showAuthPopOver:(UIButton*)sender;
@end

@implementation KBAAuthController

- (void)viewDidLoad
{
    [super viewDidLoad];
    KBAAuth *auth = [KBADependencyInjector getByKey:@"auth"];
    Customer *customer = [auth identity];
    if (customer.authenticated) {
        [self setAuthenticated];
    }
    //init scrollview
    [self.scrollView contentSizeToFit];
    //set initial scroll position
    CGPoint bottomOffset = CGPointMake(0, [self.scrollView contentSize].height);
    [self.scrollView setContentOffset:bottomOffset animated:YES];
    //set textfield to secure/password type
    self.authCodeField.secureTextEntry = YES;
    
    self.advantagesController = [KBAAuthAdvantagesController new];
    //setup titlefield properties
    JVFloatLabeledTextField *titleField = self.authCodeField;
    titleField.placeholder = @"Authentifikationscode";
    titleField.floatingLabel.text = @"Authentifikationscode";
    [titleField setup];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    [self startUpAnimation];
}

-(void)startUpAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    if (self.advantagesButton.alpha == 1) {
        self.advantagesButton.alpha = 0.5;
//        self.advantagesButton.transform = CGAffineTransformScale(self.advantagesButton.transform, 0.98, 0.98);
//        self.advantagesButton.center = CGPointMake(0,0);
    }
    else{
        self.advantagesButton.alpha = 1;
//        self.advantagesButton.transform = CGAffineTransformScale(self.advantagesButton.transform, 1.02, 1.02);
//        self.advantagesButton.center = CGPointMake(0,0);
    }
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(startUpAnimation)];
    [UIView commitAnimations];
}

/**
 *  Validates the auth code. Starts a method chain 
 *  including authenticateStep1,2,3. Starts with
 *  authenticateStep1, ends with authenticateStep3.
 *
 *  @param sender
 */
- (IBAction)authenticateStep1:(id)sender {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    [self dismissKeyboard];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(authenticateStep2)];
    [UIView commitAnimations];
}

/**
 *  Gets called after keyboard disappeared.
 *  Starts timer which calls step3.
 */
-(void)authenticateStep2
{
    NSRunLoop *r = [NSRunLoop mainRunLoop];
    self.timer = [NSTimer timerWithTimeInterval:0.01
                                         target:self
                                       selector:@selector(authenticateStep3)
                                       userInfo:nil
                                        repeats:YES];
    [r addTimer: self.timer forMode:NSDefaultRunLoopMode];
}

/**
 *  Is executed when timer fires an event.
 */
-(void)authenticateStep3
{
    static float time = 0.00;
    if (time <= 1.5) {
        [SVProgressHUD showProgress:time
                             status:@"Bearbeiten..."
                           maskType:SVProgressHUDMaskTypeGradient];
        time += 0.01;
    }
    else{
        [SVProgressHUD dismiss];
        time = 0;
        [self.timer invalidate];
        
        if ([self.authCodeField.text isEqualToString: @"123"]){
            [SVProgressHUD showSuccessWithStatus:@"Erfolgreich" ];
            [self dismissKeyboard];
            
            KBAAuth *auth = [KBADependencyInjector getByKey:@"auth"];
            Customer *customer = [auth identity];
            customer.authenticated = true;
            [super setBackBarButton];
            [self setAuthenticated];
        }
        else{
            [SVProgressHUD showErrorWithStatus:@"Fehlgeschlagen!"];
            [self.authCodeField becomeFirstResponder];
        }
    }
}

/**
 *  Shows the auth info popover.
 *
 *  @param sender
 */
- (IBAction)showAuthPopOver:(UIButton*)sender
{
    [self showPopover:sender withPopoverController: self.advantagesController
            andDirection:UIPopoverArrowDirectionAny
            andOffset:CGPointMake(0, 15)];
}

/**
 *  Setup view regarding authentication.
 */
-(void)setAuthenticated
{
    [self.validateButton setTitle:@"Authentifiziert!" forState:UIControlStateDisabled];
    self.validateButton.enabled = NO;
    [self.validateButton setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    self.authCodeField.userInteractionEnabled = NO;
    self.authCodeField.text = @"supersecurelength";
    
    // change locked icon in navigation
    UINavigationController *navController = self.splitViewController.viewControllers[0];
    KBAMasterViewController *controller = (KBAMasterViewController *)navController.topViewController;
    [controller.tableView reloadData];
}



-(void)dismissKeyboard
{
    [self.authCodeField resignFirstResponder];
}

/**
 *  Show a Popover
 */
- (void)showPopover: (UIButton *)sender withPopoverController:(UIViewController *)popoverController
       andDirection: (UIPopoverArrowDirection) popoverDirection
          andOffset: (CGPoint) offset{

    self.popController = [[UIPopoverController alloc]
                          initWithContentViewController:popoverController];
    
    CGPoint buttonPosition = sender.frame.origin;
    buttonPosition.x += sender.superview.frame.origin.x;
    buttonPosition.y += sender.superview.frame.origin.y;
    
    buttonPosition.x += offset.x;
    buttonPosition.y += offset.y;
    
    //given size as arg. is irrelevant
    //size is defined through size of view in popover
    [self.popController presentPopoverFromRect:CGRectMake(buttonPosition.x, buttonPosition.y, 1, 1)
                                        inView:self.view
                      permittedArrowDirections:popoverDirection
                                      animated:YES];
}

@end
