//The MIT License (MIT)
//
//Copyright (c) 2018 INTUZ
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import "EnterMobieNumberViewController.h"
#import "MobileVerification.h"
#import "Firebase.h"


@interface EnterMobieNumberViewController ()

@end

@implementation EnterMobieNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(btnCancelTapped)];
    self.navigationItem.leftBarButtonItem = btnCancel;
    [btnCancel setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:[MobileVerification shared].theme.bodyFontName size:17], NSForegroundColorAttributeName : [MobileVerification shared].theme.topbarTextColor} forState:UIControlStateNormal];
    
    [imgViewFlag setUserInteractionEnabled:true];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnFlag)];
    [imgViewFlag addGestureRecognizer:tapGesture];
    
    [self setTheme];
    
    [btnSendCode setClipsToBounds:true];
    [btnSendCode.layer setCornerRadius:5];
    txtFieldMobileNumber.text = self.mobileNumber;
    NSData *data = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"country-codes" ofType:@"json"]];
    arrCountryCode = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    BOOL needToSetDefaultCode = true;
    for (NSDictionary *dict in arrCountryCode) {
        NSString *strCallingCode = [dict valueForKey:kCountryCallingCodeKey];
        if ([self.mobileNumber hasPrefix:strCallingCode]) {
            txtFieldCountryCode.text = strCallingCode;
            txtFieldMobileNumber.text = [self.mobileNumber substringFromIndex:strCallingCode.length];
            [self setCountryFlag:[dict valueForKey:kCountryISOCodeKey]];
            needToSetDefaultCode = false;
            break;
        }
    }
    
    
    if (needToSetDefaultCode) {
        NSString *strISOCode =  [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",kCountryISOCodeKey,strISOCode];
        NSDictionary *dictCountry = [[arrCountryCode filteredArrayUsingPredicate:predicate] firstObject];
        txtFieldCountryCode.text = [dictCountry valueForKey:kCountryCallingCodeKey];
        [self setCountryFlag:strISOCode];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [txtFieldMobileNumber becomeFirstResponder];
    [btnSendCode setEnabled:true];
    [btnSendCode setTitle:@"Send confirmation code" forState:UIControlStateNormal];
    
}


#pragma mark - Theme
// Methods to set current theme on layout
- (void)setTheme {
    
    self.view.backgroundColor = [MobileVerification shared].theme.backgroundColor;
    
    [btnSendCode setBackgroundColor:[MobileVerification shared].theme.textColor];
    [btnSendCode setTitleColor:[MobileVerification shared].theme.backgroundColor forState:UIControlStateNormal];
    
    txtFieldCountryCode.textColor = [MobileVerification shared].theme.textColor;
    txtFieldMobileNumber.textColor = [MobileVerification shared].theme.textColor;
    txtFieldCountryCode.tintColor = [MobileVerification shared].theme.textColor;
    
    [btnSendCode.titleLabel setFont:[UIFont fontWithName:[MobileVerification shared].theme.titleFontName size:20]];
    [lblWhatYourNumber setFont:[UIFont fontWithName:[MobileVerification shared].theme.bodyFontName size:28]];
    [txtFieldCountryCode setFont:[UIFont fontWithName:[MobileVerification shared].theme.bodyFontName size:18]];
    [txtFieldMobileNumber setFont:[UIFont fontWithName:[MobileVerification shared].theme.bodyFontName size:18]];
    
}

#pragma mark - UITextField
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == txtFieldCountryCode) {
        SearchCountryCodeViewController *searchCodeVC = [[SearchCountryCodeViewController alloc] init];
        searchCodeVC.arrCountryCode = arrCountryCode;
        searchCodeVC.delegate = self;
        [self.navigationController pushViewController:searchCodeVC animated:true];
        return  false;
    }
    return true;
}


- (void)handleTapOnFlag {
    [self textFieldShouldBeginEditing:txtFieldCountryCode];
}

- (void)setCountryFlag:(NSString *)imageName {
    [imgViewFlag setImage:[UIImage imageNamed:[imageName uppercaseString]]];
}

#pragma mark - Country code did select
// Delegate methods called when country code did select.
- (void)countryCodeDidSelect:(NSDictionary *)dictCountry {
    txtFieldCountryCode.text = [dictCountry valueForKey:kCountryCallingCodeKey];
    [self setCountryFlag:[dictCountry valueForKey:kCountryISOCodeKey]];
}

// IBAction for cancel or dismiss mobile verification.
-(IBAction)btnCancelTapped {
    
    [txtFieldMobileNumber resignFirstResponder];
    [self dismissViewControllerAnimated:true completion:nil];
    if ([MobileVerification shared].completionBlock) {
        NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey : @"User cancel operation"}];
        [MobileVerification shared].completionBlock(nil, error, NO);
    }
    
}

// IBAction for send conformation code.
-(IBAction)sendConformationCode:(id)sender {
    
    if (txtFieldCountryCode.text.length > 0 && txtFieldMobileNumber.text.length > 0) {
        [btnSendCode setEnabled:false];
        [btnSendCode setTitle:@"Sending confirmation code" forState:UIControlStateNormal];
        NSString *number = [NSString stringWithFormat:@"%@%@",txtFieldCountryCode.text,txtFieldMobileNumber.text];
        [[FIRPhoneAuthProvider provider] verifyPhoneNumber:number completion:^(NSString * _Nullable verificationID, NSError * _Nullable error) {
            if (error) {
                [MobileVerification showAlertController:self title:@"Error" message:error.localizedDescription];
                
                [btnSendCode setEnabled:true];
                [btnSendCode setTitle:@"Send confirmation code" forState:UIControlStateNormal];
                NSLog(@"Error while sending confirmation code = %@",error.localizedDescription);
                
            }else {
                NSLog(@"Confirmation code did sent  = %@",verificationID);
                EnterOTPViewController *enterOTPVC = [[EnterOTPViewController alloc]init];
                enterOTPVC.title = number;
                enterOTPVC.verificationID = verificationID;
                enterOTPVC.mobileNumber = number;
                [self.navigationController pushViewController:enterOTPVC animated:true];
                
            }
        }];
    }
}



@end
