//The MIT License (MIT)
//
//Copyright (c) 2018 INTUZ
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "MobileVerification.h"
#import "EnterMobieNumberViewController.h"

@implementation MVTheme

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor    = [UIColor whiteColor];
        self.topbarColor        = [UIColor whiteColor];
        
        self.topbarTextColor    = [UIColor blackColor];
        self.textColor          = [UIColor blackColor];
        
        self.titleFontName      = @"HelveticaNeue-Medium";
        self.bodyFontName       = @"HelveticaNeue";
    }
    return self;
}

@end


@implementation MobileVerification

// Get Shared Instance
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static MobileVerification *mobileVerification;
    dispatch_once(&onceToken, ^{
        mobileVerification = [[MobileVerification alloc] init];
    });
    return mobileVerification;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
       
        [self setDefaultTheme];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    }
    return self;
}

- (void) setDefaultTheme {
    
}


// Call this method to show firebase phone auth view.
+ (void)verifyNumber:(NSString *)number title :(NSString*)title withRootViewController:(UIViewController *)rootView completion:(CompletionBlock)block {
    [[MobileVerification shared] setCompletionBlock:block];
    EnterMobieNumberViewController *enterMobileNumberVC = [[EnterMobieNumberViewController alloc] init];
    enterMobileNumberVC.mobileNumber = number;
    enterMobileNumberVC.title = title;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:enterMobileNumberVC];
    
    
    [navController.navigationBar setBarTintColor:[MobileVerification shared].theme.topbarColor];
    [navController.navigationBar setTintColor:[MobileVerification shared].theme.topbarTextColor];
    [navController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:[MobileVerification shared].theme.titleFontName size:20], NSForegroundColorAttributeName : [MobileVerification shared].theme.topbarTextColor}];
    
    [rootView presentViewController:navController animated:true completion:nil];
}

// Call this method to show alert controller with default ok action.
+ (void) showAlertController:(UIViewController *)controller title:(NSString *)strTitle message:(NSString *)strMessage {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:strTitle message:strMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // Do Your Task.
    }];
    [alertController addAction:action];
    [controller presentViewController:alertController animated:true completion:nil];
}

@end
