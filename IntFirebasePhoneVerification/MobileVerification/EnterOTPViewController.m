//The MIT License (MIT)
//
//Copyright (c) 2018 INTUZ
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "EnterOTPViewController.h"
#import "MobileVerification.h"
@interface EnterOTPViewController ()

@end

@implementation EnterOTPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithTitle:@"‹ Edit number" style:UIBarButtonItemStylePlain target:self action:@selector(btnBackTapped)];
    [btnBack setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:[MobileVerification shared].theme.bodyFontName size:17],
                                      NSForegroundColorAttributeName : [MobileVerification shared].theme.topbarTextColor} forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = btnBack;
    
    [self setTheme];
    [btnContinue setClipsToBounds:true];
    [btnContinue.layer setCornerRadius:5];
    
    [txtFieldOTP becomeFirstResponder];
    [self enableDisableButton:btnContinue isEnable:false];
    [self enableDisableButton:btnResendCode isEnable:false];
    [self enableDisableButton:btnSkip isEnable:false];
    
    [self performSelector:@selector(enableResendButton) withObject:nil afterDelay:15];
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)btnBackTapped {
    [self.navigationController popViewControllerAnimated:true];
}
#pragma mark - Theme
// Methods to set current theme on layout
- (void)setTheme {
    self.view.backgroundColor = [MobileVerification shared].theme.backgroundColor;
    [btnContinue setBackgroundColor:[MobileVerification shared].theme.textColor];
    [btnContinue setTitleColor:[MobileVerification shared].theme.backgroundColor forState:UIControlStateNormal];
    [btnResendCode setTitleColor:[MobileVerification shared].theme.textColor forState:UIControlStateNormal];
    [btnSkip setTitleColor:[MobileVerification shared].theme.textColor forState:UIControlStateNormal];
    
    
    [btnContinue.titleLabel setFont:[UIFont fontWithName:[MobileVerification shared].theme.titleFontName size:20]];
    [btnResendCode.titleLabel setFont:[UIFont fontWithName:[MobileVerification shared].theme.titleFontName size:14]];
    [btnSkip.titleLabel setFont:[UIFont fontWithName:[MobileVerification shared].theme.titleFontName size:14]];
    
    // Setup Layout.
    [btnResendCode.layer setBorderColor:[[MobileVerification shared].theme.textColor CGColor]];
    [btnResendCode.layer setBorderWidth:1.0];
    [btnResendCode.layer setCornerRadius:5];
    [btnResendCode setClipsToBounds:true];
    
    [btnSkip.layer setBorderColor:[[MobileVerification shared].theme.textColor CGColor]];
    [btnSkip.layer setBorderWidth:1.0];
    [btnSkip.layer setCornerRadius:5];
    [btnSkip setClipsToBounds:true];
    
    
    [lblWeSentCode setFont:[UIFont fontWithName:[MobileVerification shared].theme.bodyFontName size:28]];
    
    [arrOTPLable enumerateObjectsUsingBlock:^(UILabel *lbl, NSUInteger idx, BOOL * _Nonnull stop) {
        [lbl setTextColor:[MobileVerification shared].theme.textColor];
        [lbl setFont:[UIFont fontWithName:[MobileVerification shared].theme.bodyFontName size:50]];
    }];
}

- (void)enableResendButton {
    [self enableDisableButton:btnResendCode isEnable:true];
    [self enableDisableButton:btnSkip isEnable:true];
}

- (void)enableDisableButton:(UIButton *)sender isEnable:(BOOL)isEnable {
    if (isEnable) {
        sender.enabled = true;
        sender.alpha = 1;
    }else {
        sender.enabled = false;
        sender.alpha = 0.5;
    }
}

#pragma mark - IBAction
// IBAction to press continue button and verify OTP.
- (IBAction)btnContinueTapped:(UIButton *)sender {
    [SVProgressHUD showWithStatus:@"Verifying..."];
    FIRPhoneAuthCredential *credential =  [[FIRPhoneAuthProvider provider]credentialWithVerificationID:self.verificationID verificationCode:txtFieldOTP.text];
    [[FIRAuth auth] signInWithCredential:credential completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (error) {
            [SVProgressHUD dismiss];
            [MobileVerification showAlertController:self title:@"Error" message:error.localizedDescription];

        }else {
            [self dismissViewControllerAnimated:true completion:^{
                if ([MobileVerification shared].completionBlock) {
                    [MobileVerification shared].completionBlock(user.phoneNumber, nil, YES);
                }
                [SVProgressHUD dismiss];
            }];
        }
    }];
    
}

// IBAction to press resend code button and get new OTP.
- (IBAction)btnResendCodeTapped:(UIButton *)sender {
    [self enableDisableButton:btnResendCode isEnable:false];
    [self enableDisableButton:btnSkip isEnable:false];
    
    [SVProgressHUD showWithStatus:@"Code sending again..."];
    [[FIRPhoneAuthProvider provider] verifyPhoneNumber:self.mobileNumber completion:^(NSString * _Nullable verificationID, NSError * _Nullable error) {
        if (error) {
            [SVProgressHUD dismiss];
            [MobileVerification showAlertController:self title:@"Error" message:error.localizedDescription];
            
            NSLog(@"Error while sending confirmation code = %@",error.localizedDescription);
            [self performSelector:@selector(enableResendButton) withObject:nil afterDelay:15];
        }else {
            [SVProgressHUD showSuccessWithStatus:@"Sent"];
            self.verificationID = verificationID;
            NSLog(@"Confirmation code did sent  = %@",verificationID);
        }
    }];
    [self performSelector:@selector(enableResendButton) withObject:nil afterDelay:15];
}

// IBAction to press skip button if you not receive OTP on your device.
- (IBAction)btnSkipTapped:(UIButton *)sender {
    __block NSString *strNumber = self.title;
    [self dismissViewControllerAnimated:true completion:^{
        if ([MobileVerification shared].completionBlock) {
            [MobileVerification shared].completionBlock(strNumber, nil, NO);
        }
    }];
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) {
        return true;
    }
    if ([txtFieldOTP.text stringByAppendingString:string].length <= 6) {
        return true;
    }
    return  false;
}

- (void)textFieldTextDidChange {
    [arrOTPLable enumerateObjectsUsingBlock:^(UILabel *lbl, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < txtFieldOTP.text.length) {
            NSString *str = [NSString stringWithFormat: @"%C", [txtFieldOTP.text characterAtIndex:idx]];
            lbl.text = str;
        }else {
            lbl.text = @"-";
        }
    }];
    
    if (txtFieldOTP.text.length == 6) {
        [self enableDisableButton:btnContinue isEnable:true];
    }else {
        [self enableDisableButton:btnContinue isEnable:false];
    }
}

@end
