//
//  MoviesListViewController.m
//  RottenTomatteo
//
//  Created by Yina WU on 1/25/15.
//  Copyright (c) 2015 Yina WU. All rights reserved.
//

#import "MoviesListViewController.h"
#import "SVProgressHUD.h"
#import "MovieCellTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "MovieDetailController.h"

@interface MoviesListViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshController;
@property (strong, nonatomic) IBOutlet UISearchBar *searchMovies;

@end

@implementation MoviesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.searchMovies.delegate = self;
    
    self.refreshController = [[UIRefreshControl alloc] init];
    [self.refreshController addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    UITableViewController *tvc = [[UITableViewController alloc] init];
    tvc.tableView = self.tableView;
    tvc.refreshControl = self.refreshController;
    [self addChildViewController:tvc];
    
    //register Tabel Cell View;
    
    UINib *cellNib = [UINib nibWithNibName:@"MovieCellTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"CustomCell"];
    
    [self sendAPIrequest];
}

- (void) refresh:(id)sender{
    [self sendAPIrequest];
}

- (void)sendAPIrequest {
    NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us"];
    
    if([self.searchMovies.text length] > 0){
        
        NSString *query = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us&q=%@", self.searchMovies.text];
         url = [NSURL URLWithString:query];
    }
    self.tableView.rowHeight = 100;
    [SVProgressHUD show];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(connectionError){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Network Error" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            [alert show];
        }
        else{
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.movies = (NSArray *)[responseDictionary valueForKey:@"movies"];
            
            NSLog(@"movies %@", self.movies);
            
            [self.tableView reloadData];
            [self.refreshController endRefreshing];
            [SVProgressHUD dismiss];
            [self.view endEditing:YES];
        }
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieCellTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    cell.titleLable.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"synopsis"];
    NSString *urlString = [movie valueForKeyPath:@"posters.thumbnail"];
    [cell.movieImage setImageWithURL:[NSURL URLWithString:urlString]];
    
    return cell;

}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"row clicked");
    MovieDetailController *vc = [[MovieDetailController alloc] init];
    vc.movie = self.movies[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self sendAPIrequest];

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchBar.text isEqualToString:@""]) {
        [self.view endEditing:YES];
        [self sendAPIrequest];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
