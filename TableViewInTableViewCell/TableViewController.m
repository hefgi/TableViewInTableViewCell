//
//  TableViewController.m
//  TableViewInsertDeleteRow
//
//  Created by Alcaraz François-Julien on 1/8/2014.
//  Copyright (c) 2014 Alcaraz François-Julien. All rights reserved.
//

#import "TableViewController.h"
#import "SongsListCell.h"
#import "HeaderCell.h"

static NSString *HeaderIdentifier = @"HeaderCell";
static NSString *SongsListIdentifier = @"SongsListCell";

@interface TableViewController ()

@property (assign, nonatomic) BOOL isInsertingRow;


@end

@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.dataArray = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects:@"headercell", @"headercell", @"headercell", nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentSizeCategoryChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object:nil];
}

// This method is called when the Dynamic Type user setting changes (from the system Settings app)
- (void)contentSizeCategoryChanged:(NSNotification *)notification
{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{


    UITableViewCell *cell;
    
    if ([[self.dataArray objectAtIndex:indexPath.row] isEqualToString:@"headercell"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:HeaderIdentifier];
        cell.backgroundColor = [UIColor grayColor];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:SongsListIdentifier];
        [(SongsListCell *)cell setIndexRow:indexPath.row];

    }

    // Configure the cell for this indexPath
    
    // Make sure the constraints have been added to this cell, since it may have just been created from scratch
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if ([[self.dataArray objectAtIndex:indexPath.row] isEqualToString:@"headercell"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:HeaderIdentifier];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:SongsListIdentifier forIndexPath:indexPath];
        [(SongsListCell *)cell setIndexRow:indexPath.row];
    }
    // Configure the cell for this indexPath
    
    // Make sure the constraints have been added to this cell, since it may have just been created from scratch
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    // Set the width of the cell to match the width of the table view. This is important so that we'll get the
    // correct height for different table view widths, since our cell's height depends on its width due to
    // the multi-line UILabel word wrapping. Don't need to do this above in -[tableView:cellForRowAtIndexPath]
    // because it happens automatically when the cell is used in the table view.
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    
    // Do the layout pass on the cell, which will calculate the frames for all the views based on the constraints
    // (Note that the preferredMaxLayoutWidth is set on multi-line UILabels inside the -[layoutSubviews] method
    // in the UITableViewCell subclass
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    // Get the actual height required for the cell
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    // Add an extra point to the height to account for internal rounding errors that are occasionally observed in
    // the Auto Layout engine, which cause the returned height to be slightly too small in some cases.
    height += 1;
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isInsertingRow) {
        // A constraint exception will be thrown if the estimated row height for an inserted row is greater
        // than the actual height for that row. In order to work around this, we return the actual height
        // for the the row when inserting into the table view.
        // See: https://github.com/caoimghgin/TableViewCellWithAutoLayout/issues/6
        return [self tableView:tableView heightForRowAtIndexPath:indexPath];
    } else {
        return 500.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[self.dataArray objectAtIndex:indexPath.row] isEqualToString:@"headercell"]) {
        
        HeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:HeaderIdentifier forIndexPath:indexPath];
        
        if (cell.isListOpen) {
            [self removeListForIndexPath:indexPath];
            cell.isListOpen = NO;
        }
        else {
            [self addListForIndexPath:indexPath];
            cell.isListOpen = YES;
        }
        
    }
    
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (void)addListForIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexPath * newIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:0];
    
    [self.tableView beginUpdates];
    
    [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
    [self.dataArray insertObject:@"songsList" atIndex:newIndexPath.row];
    
    
    [self.tableView endUpdates];
    
}

- (void)removeListForIndexPath:(NSIndexPath *)indexPath {
    
    [self.dataArray removeObjectAtIndex:(indexPath.row + 1)];
    
    NSIndexPath * newIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:0];
    
    [self.tableView beginUpdates];
    
    [self.tableView deleteRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    
    [self.tableView endUpdates];
    
}









@end
