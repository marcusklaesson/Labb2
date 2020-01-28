//
//  ToDoTableViewController.m
//  Labb2
//
//  Created by Marcus Klaesson on 2020-01-20.
//  Copyright © 2020 Marcus Klaesson. All rights reserved.
//

#import "ToDoTableViewController.h"


@interface ToDoTableViewController ()
@property (nonatomic) NSMutableArray *todoTask;
@property (nonatomic) int selectedRow;
@end

@implementation ToDoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.todoTask = [[NSMutableArray alloc] init];
   
   
    [self loadData];
    
    
    
    
    UILongPressGestureRecognizer* longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    [self.tableView addGestureRecognizer:longPressRecognizer];
    
    
    
}

-(void)saveData{
    
    [[NSUserDefaults standardUserDefaults] setObject:self.todoTask forKey:@"TheKey"];
      [[NSUserDefaults standardUserDefaults] synchronize];
      
      NSLog(@"SAVE: %@", self.todoTask);
    


}
-(void)loadData{
    
    self.todoTask = [[[NSUserDefaults standardUserDefaults] objectForKey:@"TheKey"] mutableCopy];

       NSLog(@"LOAD: %@", self.todoTask);
    

        
}
- (IBAction)addTodo:(id)sender {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Your task" message:@"" preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        UITextField *textField = alert.textFields[0];
        
        if(textField.text.length > 0){
            
            
            NSMutableString *todo = [NSMutableString stringWithFormat:@"%@", textField.text];
            
            
            [self.todoTask addObject:todo];
            
            
            NSLog(@"todo clicks: %lu", (unsigned long)self.todoTask.count);
            
            [self.tableView reloadData];
            [self saveData];
        }

    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:defaultAction];
                                   
                                   [alert addAction:cancelAction];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Task";
        textField.keyboardType = UIKeyboardTypeDefault;
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)onLongPress:(UILongPressGestureRecognizer*)pGesture {

if (pGesture.state == UIGestureRecognizerStateEnded)
{
    UITableView* tableView = (UITableView*)self.view;
    CGPoint touchPoint = [pGesture locationInView:self.view];
    NSIndexPath* selectedCell = [tableView indexPathForRowAtPoint:touchPoint];
    
    
    if (selectedCell != nil) {
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Task options" message:@"" preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *prioAction = [UIAlertAction actionWithTitle:@"Prioritize" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
            NSMutableString *d = self.todoTask[selectedCell.row];
            
        
            [self.todoTask removeObjectAtIndex:selectedCell.row];
            [self.todoTask insertObject:d atIndex:0];
            [tableView reloadData];
            [self saveData];
            

        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Task done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            
            
            
            NSMutableString *d = self.todoTask[selectedCell.row];
                              
                     [self.todoTask removeObjectAtIndex:selectedCell.row];
                     [self.todoTask insertObject:d atIndex:self.todoTask.count];
                    
                     [tableView reloadData];
            
            
            NSLog(@"Task done");
            
            [self saveData];
            
        }];
        
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            NSLog(@"Task done");
            
            if(selectedCell.row == UITableViewCellAccessoryCheckmark){
                [tableView cellForRowAtIndexPath:selectedCell].accessoryType = UITableViewCellAccessoryNone;
            }
            
            [self.todoTask removeObjectAtIndex:selectedCell.row];
            [self.tableView reloadData];
            [self saveData];
            
        
        }];
        
        [alert addAction:prioAction];
                                       
        [alert addAction:cancelAction];
        
        [alert addAction:deleteAction];
        
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

   
    return self.todoTask.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todoCell" forIndexPath:indexPath];
    

    
        NSMutableArray *todos = self.todoTask[indexPath.row];
       
       cell.textLabel.text = [NSString stringWithFormat:@"%@", todos];
    
       
       NSLog(@"%@", todos);
    

    

    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
