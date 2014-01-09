//
//  SongsListCell.h
//  TableViewInsertDeleteRow
//
//  Created by Alcaraz François-Julien on 1/8/2014.
//  Copyright (c) 2014 Alcaraz François-Julien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongsListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITableView *songsTableView;
@property (nonatomic, strong) NSMutableArray * songsArray;
@property (nonatomic) int indexRow;


@end
