//
//  ContactCell.h
//  KCBuinessKey
//
//  Created by eddy on 16/6/15.
//  Copyright © 2016年 luhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactCell : UITableViewCell

@property (nonatomic) IBOutlet UIImageView *headImageView;

@property (nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic) IBOutlet UIButton *telBtn;

@property (nonatomic) IBOutlet UIButton *messageBtn;
@end
