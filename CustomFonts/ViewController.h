//
//  ViewController.h
//  CustomFonts
//
//  Created by zerox on 12-12-14.
//  Copyright (c) 2012年 zerox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
{
    UITableView *_tableView;
    UISearchBar *_searchBar;
    UISearchDisplayController *_searchController;
    
    NSMutableArray *_fontsNameArr;
	NSMutableArray *_filteredArr;
}

@end
