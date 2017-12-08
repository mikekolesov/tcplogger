//
//  ViewController.m
//  TcpLogger
//
//  Created by MKolesov on 29/08/2017.
//  Copyright © 2017 Mikhail Kolesov. All rights reserved.
//

#import "ViewController.h"
#import "TcpLogger.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendTapped:(id)sender {
    if (self.textField.text.length == 0)
        return;
    
    // send log message to server
    [[TcpLogger shared] sendMessage:self.textField.text];
    
    self.textField.text = @"";
}

@end
