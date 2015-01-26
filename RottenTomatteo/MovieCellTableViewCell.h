//
//  MovieCellTableViewCell.h
//  RottenTomatteo
//
//  Created by Yina WU on 1/25/15.
//  Copyright (c) 2015 Yina WU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCellTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *movieImage;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UILabel *synopsisLabel;
@end
