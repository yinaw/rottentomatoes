//
//  MovieDetailController.m
//  RottenTomatteo
//
//  Created by Yina WU on 1/25/15.
//  Copyright (c) 2015 Yina WU. All rights reserved.
//

#import "MovieDetailController.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetailController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *oriImage;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (strong, nonatomic) IBOutlet UIView *rectBackground;

@end

@implementation MovieDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *urlString = [self.movie valueForKeyPath:@"posters.thumbnail"];
    
    NSString *oriUrl = [urlString stringByReplacingOccurrencesOfString:@"tmb" withString:@"det"];
    
    [self.oriImage setImageWithURL:[NSURL URLWithString:oriUrl]];
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"synopsis"];
    [self.synopsisLabel sizeToFit];
    //[self.rectBackground ]
    
    
    self.scrollView.contentSize = CGSizeMake(320, self.synopsisLabel.frame.size.height + 350);
    
    CGRect newFrame = self.rectBackground.frame;
    newFrame.size.height = self.synopsisLabel.frame.size.height + 70;
    [self.rectBackground setFrame:newFrame];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
