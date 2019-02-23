//
//  ViewController.h
//  http-example-ios
//
//  Created by Patrick Madden on 2/23/19.
//  Copyright © 2019 Binghamton University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Networker.h"
@interface ViewController : UIViewController

@property(nonatomic, strong) IBOutlet UITextField *textField;
@property(nonatomic, strong) IBOutlet UILabel *resultDisplay;
@property(nonatomic, strong) Networker *networker;

@end

