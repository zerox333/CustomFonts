//
//  ViewController.m
//  CustomFonts
//
//  Created by zerox on 12-12-14.
//  Copyright (c) 2012年 zerox. All rights reserved.
//

#import "ViewController.h"
#import "ArabicConverter.h"

#define FONTSIZE CGRectGetWidth([UIScreen mainScreen].bounds) > 320 ? 20 : 14

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.delegate = self;
    
    _searchController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchController.delegate = self;
    _searchController.searchResultsDataSource = self;
    _searchController.searchResultsDelegate = self;
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableHeaderView = _searchBar;
    
    [_searchBar sizeToFit];
    
    NSArray *familyNamesArr = [UIFont familyNames];
    
    _fontsNameArr = [[NSMutableArray alloc] init];
    for (NSString *familyName in familyNamesArr)
    {
        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName])
        {
            [_fontsNameArr addObject:fontName];
        }
    }
    [_fontsNameArr sortUsingComparator:^(NSString *str1, NSString *str2){
        return [str1 compare:str2];
    }];
    
    _filteredArr = [[NSMutableArray alloc] init];
    
    [self.view addSubview:_tableView];
}

- (void)dealloc
{
    [_tableView release];
    [super dealloc];
}

#pragma mark - Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	[_filteredArr removeAllObjects];
    
	for (NSString *fontName in _fontsNameArr)
	{
        NSComparisonResult result = [fontName compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        if (result == NSOrderedSame)
        {
            [_filteredArr addObject:fontName];
        }
	}
}

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _searchController.searchResultsTableView)
	{
        return [_filteredArr count];
    }
	else
	{
        return [_fontsNameArr count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellTableIdentifier = @"CellTableIdentifier";
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier] autorelease];
	}
    if (tableView == _searchController.searchResultsTableView)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@: أي محتوى", [_filteredArr objectAtIndex:indexPath.row]];
        cell.textLabel.font = [UIFont fontWithName:[_filteredArr objectAtIndex:indexPath.row] size:FONTSIZE];
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@: أي محتوى", [_fontsNameArr objectAtIndex:indexPath.row]];
        cell.textLabel.font = [UIFont fontWithName:[_fontsNameArr objectAtIndex:indexPath.row] size:FONTSIZE];
    }
    
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UISearchDisplayController Delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Return YES to cause the search result table view to be reloaded.
    [self filterContentForSearchText:searchString scope:nil];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
	/*
     Because the searchResultsTableView will be released and allocated automatically, so each time we start to begin search, we set its delegate here.
     */
	[_searchController.searchResultsTableView setDelegate:self];
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [_searchBar resignFirstResponder];
}

@end
