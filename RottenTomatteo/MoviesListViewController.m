//
//  MoviesListViewController.m
//  RottenTomatteo
//
//  Created by Yina WU on 1/25/15.
//  Copyright (c) 2015 Yina WU. All rights reserved.
//

#import "MoviesListViewController.h"
#import "SVProgressHUD.h"

@interface MoviesListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshController;

@end

@implementation MoviesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.refreshController = [[UIRefreshControl alloc] init];
    [self.refreshController addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    UITableViewController *tvc = [[UITableViewController alloc] init];
    tvc.tableView = self.tableView;
    tvc.refreshControl = self.refreshController;
    [self addChildViewController:tvc];
    
    [self sendAPIrequest];
}

- (void) refresh:(id)sender{
    [self sendAPIrequest];
}

- (void)sendAPIrequest{
    NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us"];
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
        }
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;

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
