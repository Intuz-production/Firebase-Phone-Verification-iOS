//The MIT License (MIT)
//
//Copyright (c) 2018 INTUZ
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "SearchCountryCodeViewController.h"
#import "SearchCountryCell.h"
#import "MobileVerification.h"
@interface SearchCountryCodeViewController ()

@end

@implementation SearchCountryCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTheme];
    [self alwaysEnableSearch];
    
    [searchBar setBarTintColor:[MobileVerification shared].theme.topbarColor];

    [searchBar setPlaceholder:@"Search"];
    
    arrIndexes = [@"A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,Y,Z" componentsSeparatedByString:@","];
    [tblView registerNib:[UINib nibWithNibName:@"SearchCountryCell" bundle:nil] forCellReuseIdentifier:@"SearchCountryCell"];
    arrFilteredCountryCode = [[NSMutableArray alloc] init];
    arrFilteredIndexes = [[NSMutableArray alloc] init];
    [self groupArray:self.arrCountryCode];
}


#pragma mark - Theme
- (void)setTheme {
    [tblView setSectionIndexColor:[MobileVerification shared].theme.textColor];
}

- (void)groupArray:(NSMutableArray *)arrCode {
    [arrFilteredCountryCode removeAllObjects];
    [arrFilteredIndexes removeAllObjects];
    [arrIndexes enumerateObjectsUsingBlock:^(NSString *character, NSUInteger idx, BOOL * _Nonnull stop) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[c] %@",kCountryNameKey,character];
        NSArray *arrResult = [arrCode filteredArrayUsingPredicate:predicate];
        if (arrResult.count > 0) {
            [arrFilteredIndexes addObject:character];
            [arrFilteredCountryCode  addObject:[[NSMutableArray alloc] initWithArray:arrResult]];
        }
        
    }];
    [tblView reloadData];
   
}

#pragma mark - UISearchBar Delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[c] %@",kCountryNameKey,searchText];
        [self groupArray:[[NSMutableArray alloc] initWithArray:[self.arrCountryCode filteredArrayUsingPredicate:predicate]]];
    }else {
        [self groupArray:self.arrCountryCode];
    }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1 {
    [searchBar resignFirstResponder];
}

#pragma mark - alwaysEnableSearch

- (void) alwaysEnableSearch {
    // loop around subviews of UISearchBar
    NSMutableSet *viewsToCheck = [NSMutableSet setWithArray:[searchBar subviews]];
    while ([viewsToCheck count] > 0) {
        UIView *searchBarSubview = [viewsToCheck anyObject];
        [viewsToCheck addObjectsFromArray:searchBarSubview.subviews];
        [viewsToCheck removeObject:searchBarSubview];
        if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)]) {
            @try {
                // always force return key to be enabled
                [(UITextField *)searchBarSubview setEnablesReturnKeyAutomatically:NO];
            }
            @catch (NSException * e) {
                // ignore exception
            }
        }
    }
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return arrFilteredCountryCode.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[arrFilteredCountryCode objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchCountryCell *cell = [tblView dequeueReusableCellWithIdentifier:@"SearchCountryCell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSDictionary *dictCountry = [[arrFilteredCountryCode objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    cell.imgViewFlag.image = [UIImage imageNamed:[dictCountry valueForKey:kCountryISOCodeKey]];
    cell.lblName.text = [dictCountry valueForKey:kCountryNameKey];
    cell.lblCode.text = [[dictCountry valueForKey:kCountryCallingCodeKey] stringByReplacingOccurrencesOfString:@"+" withString:@""];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [arrFilteredIndexes objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return  arrFilteredIndexes;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(countryCodeDidSelect:)]) {
         NSDictionary *dictCountry = [[arrFilteredCountryCode objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];;
        [self.delegate countryCodeDidSelect:dictCountry];
    }
    [self.navigationController popViewControllerAnimated:true];
}

@end
