//The MIT License (MIT)
//
//Copyright (c) 2018 INTUZ
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>

#define kCountryCallingCodeKey   @"e164_cc"
#define kCountryNameKey          @"name"
#define kCountryISOCodeKey       @"iso2_cc"

@protocol SearchCountryCodeDelegate <NSObject>

- (void)countryCodeDidSelect:(NSDictionary *)dictCountry;

@end

@interface SearchCountryCodeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    IBOutlet UITableView *tblView;
    IBOutlet UISearchBar *searchBar;
    NSMutableArray *arrFilteredCountryCode;
    NSMutableArray *arrFilteredIndexes;
    NSArray *arrIndexes;
}
@property (nonatomic, assign) id <SearchCountryCodeDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *arrCountryCode;
@end

