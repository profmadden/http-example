//
//  ViewController.m
//  http-example-ios
//
//  Created by Patrick Madden on 2/23/19.
//  Copyright © 2019 Binghamton University. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize textField, resultDisplay;
@synthesize networker;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    networker = [[Networker alloc] init];
    [networker setBaseURL:@"https://cs.binghamton.edu/~pmadden/php/double.php"];
}

-(void)updateDisplay:(NSDictionary *)data
{
    NSLog(@"Object is %@", data);
    
    NSArray *obj = [data valueForKey:@"result"];
    if (obj)
    {
        NSNumber *number = (NSNumber *)[obj objectAtIndex:0];
        [resultDisplay setText:[NSString stringWithFormat:@"%@", number]];
    }
}

-(IBAction)networkQuery
{
    NSDictionary *query = @{@"value":[textField text]};
    [networker push:nil keys:query file:nil completionHandler:^(NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
        NSLog(@"Got the result back.");
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSASCIIStringEncoding error:&jsonError];
        
        NSLog(@"JSON result is %@", json);
        [self performSelectorOnMainThread:@selector(updateDisplay:) withObject:json waitUntilDone:NO];
        
    }];
}


@end
