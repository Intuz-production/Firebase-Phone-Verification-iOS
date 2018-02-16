//The MIT License (MIT)
//
//Copyright (c) 2018 INTUZ
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

class ViewController: UIViewController {

    @IBOutlet var btnNext: UIButton!
    @IBOutlet var lblNotes: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set Firebase Auth Layout Theme.
        let theme = MVTheme()
        theme.backgroundColor = UIColor.white
        theme.textColor = UIColor.black
        theme.bodyFontName = "HelveticaNeue"
        
        theme.topbarColor = UIColor.black
        theme.topbarTextColor = UIColor.white
        theme.titleFontName = "HelveticaNeue-Medium"
        
        MobileVerification.shared().theme = theme
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnShowFilebasePhoneAuthView(_ sender: UIButton) {
        
        MobileVerification.verifyNumber("", title: "Firebase", withRootViewController: self) { (phoneNumber, error, isVerified) in
            if error == nil {
                self.lblNotes.text = "Status: \(isVerified ? "Verified" : "Not Verified")\n\nPhone Number: \(phoneNumber ?? "-")"
            }
            else {
                self.lblNotes.text = "Error: \(error?.localizedDescription ?? "-")"
            }
        }
        
    }


}

