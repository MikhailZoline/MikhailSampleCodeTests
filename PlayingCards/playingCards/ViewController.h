//
//  ViewController.h
//  playingCards
//
//  Created by Mikhail Zoline on 03/16/16.
//  Copyright (c) 2016 Mikhail. All rights reserved.
//

#import <UIKit/UIKit.h>

#include <stdlib.h>


@interface ViewController : UIViewController

//Arrays to hold deck of cards, and cards dealt respectively.
@property NSMutableArray *arrDeck;
@property NSMutableArray *arrDealtCards;

//Textviews where deck and dealt cards can be seen.
@property (weak, nonatomic) IBOutlet UITextView *txtCurrentDeck;
@property (weak, nonatomic) IBOutlet UITextView *txtCurrentDealt;

//All the buttons a user can press.
@property (weak, nonatomic) IBOutlet UIButton *btnShuffleDeck;
@property (weak, nonatomic) IBOutlet UIButton *btnDealCard;
@property (weak, nonatomic) IBOutlet UIButton *btnReturnLastDealtCard;
@property (weak, nonatomic) IBOutlet UIButton *btnResetDeck;


//Actions that shuffle, deal from, and reset the deck.
- (IBAction)btnShuffleDeck:(id)sender;
- (IBAction)btnDealCard:(id)sender;
- (IBAction)btnReturnLastDealtCard:(id)sender;
- (IBAction)btnResetDeck:(id)sender;

@end
