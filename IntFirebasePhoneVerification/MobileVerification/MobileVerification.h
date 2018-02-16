//The MIT License (MIT)
//
//Copyright (c) 2018 INTUZ
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SVProgressHUD/SVProgressHUD.h>

// Theme class to modify mobile verification layout theme
@interface MVTheme : NSObject

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *topbarColor;
@property (nonatomic, strong) UIColor *topbarTextColor;
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) NSString *titleFontName;
@property (nonatomic, strong) NSString *bodyFontName;

@end

typedef void(^CompletionBlock)(NSString *number, NSError *error, BOOL isVerified);
@interface MobileVerification : NSObject {
    
}

@property (nonatomic, strong) MVTheme *theme;

@property (nonatomic, readwrite) CompletionBlock completionBlock;

// Get Shared Instance of Mobile Verification.
+ (instancetype)shared;

// Show Mobile Verification View.
+ (void)verifyNumber:(NSString *)number title :(NSString*)title withRootViewController:(UIViewController *)rootView completion:(CompletionBlock)block;

// Show Alert Controller with default OK action.
+ (void) showAlertController:(UIViewController *)controller title:(NSString *)strTitle message:(NSString *)strMessage;

@end
