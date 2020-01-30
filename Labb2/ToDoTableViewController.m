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
@property (nonatomic) NSMutableArray *importantTask;
@property (nonatomic) NSMutableArray *completedTask;

@end

@implementation ToDoTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.todoTask = [[NSMutableArray alloc] init];
    self.importantTask = [[NSMutableArray alloc] init];
    self.completedTask = [[NSMutableArray alloc] init];
   
    [self loadData];
    
    UILongPressGestureRecognizer* longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    [self.tableView addGestureRecognizer:longPressRecognizer];
    

}

-(void)saveData{
    
        [[NSUserDefaults standardUserDefaults] setObject:self.completedTask forKey:@"completed"];
               [[NSUserDefaults standardUserDefaults] synchronize];
               
               NSLog(@"SAVE TO COMPLETED: %@", self.completedTask);
  
        [[NSUserDefaults standardUserDefaults] setObject:self.importantTask forKey:@"important"];
                   [[NSUserDefaults standardUserDefaults] synchronize];
                   
                   NSLog(@"SAVE TO IMPORTANT : %@", self.importantTask);
        
        [[NSUserDefaults standardUserDefaults] setObject:self.todoTask forKey:@"todo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSLog(@"SAVE TO TODO: %@", self.todoTask);

}
-(void)loadData{
    
        self.completedTask = [[[NSUserDefaults standardUserDefaults] objectForKey:@"completed"] mutableCopy];

           NSLog(@"LOAD: %@", self.completedTask);
    
    
        self.todoTask = [[[NSUserDefaults standardUserDefaults] objectForKey:@"important"] mutableCopy];

           NSLog(@"LOAD: %@", self.importantTask);
        

    self.todoTask = [[[NSUserDefaults standardUserDefaults] objectForKey:@"todo"] mutableCopy];

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
        
  
             NSMutableString *string = self.todoTask[selectedCell.row];
            
            
            [self.todoTask removeObjectAtIndex:selectedCell.row];
                [self.importantTask addObject:string];
            
            [self saveData];
            [self.tableView reloadData];
        
        }];
        
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Task done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
    
            
            NSMutableString *string = self.todoTask[selectedCell.row];
            
            [self.todoTask removeObjectAtIndex:selectedCell.row];
                   [self.completedTask addObject:string];
            
            [self saveData];
            [self.tableView reloadData];
            
            
        }];
        
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
    
            if(selectedCell.section == 0){
                [self.importantTask removeObjectAtIndex:selectedCell.row];
            }else if(selectedCell.section == 1){
                [self.todoTask removeObjectAtIndex:selectedCell.row];
            }else if(selectedCell.section == 2){
                [self.completedTask removeObjectAtIndex:selectedCell.row];
            }
            
            [self saveData];
            [self.tableView reloadData];
        
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            
            }];
        
        
        [alert addAction:prioAction];
                                       
        [alert addAction:doneAction];
        
        [alert addAction:deleteAction];
        
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.importantTask.count;
    }

     if (section == 1) {
        return self.todoTask.count;
    }

     if (section == 2) {
        return self.completedTask.count;
    }else {
        return 0;
    }
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todoCell"];
      
      if(!cell)
      {
          cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"todoCell"];
      }
    
    if(indexPath.section == 0){
        
         NSMutableString *prio = [[NSMutableString alloc]initWithString:self.importantTask[indexPath.row]];
           
        cell.textLabel.text = [NSString stringWithString:prio];
        
           NSLog(@"cellForRowIMPORTANT: %@", self.importantTask);
        
    } if(indexPath.section == 1){
    
                 NSMutableString *todo = [[NSMutableString alloc]initWithString:self.todoTask[indexPath.row]];
                    
                 cell.textLabel.text = [NSString stringWithString:todo];
              
            NSLog(@"cellForRowTODO: %@", self.todoTask);
        
    }if(indexPath.section == 2) {
    
         NSMutableString *comp = [[NSMutableString alloc]initWithString:self.completedTask[indexPath.row]];
           
        cell.textLabel.text = [NSString stringWithString:comp];
     

       NSLog(@"cellForRowCOMP: %@", self.completedTask);

    }
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    switch (section) {
    case 0:
        return @"Important";
        break;
    case 1:
        return @"Todos";
        break;
    case 2:
        return @"Completed";
        break;

    default:
        return nil;
        break;
        }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) {
        return 0;
    } else {
        return 50;
    }
}

@end
