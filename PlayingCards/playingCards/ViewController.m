//
//  ViewController.m
//  playingCards
//
//  Created by Mikhail Zoline on 03/16/16.
//  Copyright (c) 2016 Mikhail. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.arrDealtCards = [[NSMutableArray alloc] initWithCapacity:52];
    
    ////Initialize cards array
     self.arrDeck = [[NSMutableArray alloc]initWithCapacity:52];
    
    //Create the 13 cards of each suit, and add to deck array.
    for (int i = 0; i < 4; i++)
    {
        NSString *suit;
        
        switch (i)
        {
            case 0:
                suit = @"♦";
                break;
            case 1:
                suit = @"♣";
                break;
            case 2:
                suit = @"♥";
                break;
            case 3:
                suit = @"♠";
                break;
            default:
                break;
        }
        
        for (int j= 1; j<=13; j++)
        {
            NSString *value;
            switch (j)
            {
                case 1:
                    value = @"A";
                    break;
                case 11:
                    value = @"J";
                    break;
                case 12:
                    value = @"Q";
                    break;
                case 13:
                    value = @"K";
                    break;
                    
                default:
                    value = [NSString stringWithFormat:@"%d",j];
                    break;
            }
            
            NSString *card = [NSString stringWithFormat:@"%@%@",value, suit];
            [self.arrDeck addObject:card];
        }
    }
    
    //Shuffle the deck.
    [self btnShuffleDeck:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Shuffle the deck via one of three methods, and then display the result.
- (IBAction)btnShuffleDeck:(id)sender
{
    if( [self.arrDeck count] > 1  )
    {
        int r = arc4random() % 3;
        
        //Pick a random shuffle method.
        switch (r) {
            case 0:
                [self shuffleByRemovingRandomCards];
                break;
            case 1:
                [self shuffleBySwappingCardPositions];
                break;
            case 2:
                [self shuffleBySimulatingHuman];
                break;
                
            default:
                break;
        }
        
        [self.txtCurrentDeck setText:@""];
        //Display result of shuffle.
        for (NSString *card in self.arrDeck) {
            self.txtCurrentDeck.text = [self.txtCurrentDeck.text stringByAppendingString:[NSString stringWithFormat:@" %@",card]];
    }
    }
    else
    {
        //No specifications whether or not alerts are desired. Will simply display alerts once when/where needed then disable buttons. Will follow this paradigm throughout for all buttons.
        UIAlertView *alertCantShuffle = [[UIAlertView alloc] initWithTitle:@"Insufficient Cards" message:@"Need atleast two cards to perform a shuffle!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertCantShuffle show];
        
        [self.btnShuffleDeck setEnabled:false];
    }
}

////Shuffle methods start*
//
-(void)shuffleByRemovingRandomCards
{
    NSMutableArray * arrCardHolder = [[NSMutableArray alloc]initWithCapacity:52];
    
    //Algorithm: Remove a random card from the deck and place in holder array. When no cards are left in the deck, the holder array yields a shuffled deck.
    while ([self.arrDeck count] > 0)
    {
        int r = arc4random() %[self.arrDeck count];
        
        [arrCardHolder addObject:[self.arrDeck objectAtIndex:r]];
        
        [self.arrDeck removeObjectAtIndex:r];
    }
    
    self.arrDeck = arrCardHolder;
}
-(void)shuffleBySwappingCardPositions
{
    //Algorithm: Swap card objects at two random indexes a set ammount of times. The more swaps performed the greater the shuffle.
    for(int i =0; i < 1000; i++)
    {
        int iFirstRandomCard = arc4random() % [self.arrDeck count];
        int iSecondRandomCard = arc4random() % [self.arrDeck count];
        
        //To prevent collisions
        while (iSecondRandomCard == iFirstRandomCard)
            iSecondRandomCard = arc4random() % [self.arrDeck count];
        
        [self.arrDeck exchangeObjectAtIndex:iFirstRandomCard withObjectAtIndex:iSecondRandomCard];
    }
}
-(void)shuffleBySimulatingHuman
{
    //-Cut the deck-
    //Algorithm: Select a random point in the deck. Remove the cards above that point and place the cards from that point onwards above the removed cards.
    if( [self.arrDeck count] > 1 ) //Possible to cut deck - Typically done atleast once.
    {
        int iCutPosition = arc4random() % [self.arrDeck count];
        
        //Ensure cut position allows for a modification to order of the deck.
        while ( iCutPosition == 0 )
            iCutPosition = arc4random() % [self.arrDeck count];
        
        //Get ranges for the top and lower half, then swap them.
        NSRange rangeTopHalf = {0, iCutPosition};
        NSRange rangeBottomHalf = {iCutPosition, [self.arrDeck count] - iCutPosition };
        
        NSMutableArray *arrCutDeck = [[NSMutableArray alloc]initWithArray:[self.arrDeck subarrayWithRange:rangeBottomHalf]];
        [arrCutDeck addObjectsFromArray:[self.arrDeck subarrayWithRange:rangeTopHalf]];
        
        self.arrDeck = arrCutDeck;
    }
    //-Cut the deck-
    
    //-Ruffle
    //Algorithm: Split deck in half, and intersperse the cards at "like" indexes.
    if( [self.arrDeck count] > 1 ) //Possible to ruffle deck - Typically done at least once.
    {
        //Get ranges of two "equal" halfs of the deck.
        NSRange rangeLeftSide = {0, ([self.arrDeck count]/2 ) };
        NSRange rangeRightSide = { [self.arrDeck count]/2 , [self.arrDeck count] - [self.arrDeck count]/2 };
        
        NSMutableArray *arrLeftSide = [[NSMutableArray alloc] initWithArray:[self.arrDeck subarrayWithRange:rangeLeftSide]];
        NSMutableArray *arrRightSide = [[NSMutableArray alloc] initWithArray:[self.arrDeck subarrayWithRange:rangeRightSide]];
        
        //Interperse the two halfs of the deck.
        NSMutableArray *arrRuffledDeck = [NSMutableArray new];
        while (arrLeftSide.count > 0 || arrRightSide.count > 0)
        {
            if( arrRightSide.count > 0)
            {
                [arrRuffledDeck addObject:[arrRightSide objectAtIndex:0]];
                [arrRightSide removeObjectAtIndex:0];
            }
            if( arrLeftSide.count > 0)
            {
                [arrRuffledDeck addObject:[arrLeftSide objectAtIndex:0]];
                [arrLeftSide removeObjectAtIndex:0];
            }
        }
        
        self.arrDeck = arrRuffledDeck;
    }
    //-Ruffle-
    
    
    //-Hindu shuffle-
    //Algorithm: Get an upper and lower bound index for the deck. There should be cards leftover on both sides of the bounds. Remove the cards within the bounds, collapse the the remaining cards, place removed cards on top.
    if( [self.arrDeck count] > 2) //Possible to Hindu shuffle deck - Typically done several times straight when performed.
    {
        for( int i = 7; i > 0; i--) //Typically done several times (seven for good luck here)
        {
            //Get lower and upper bounds that meet the criteria for algorithm.
            int iLowerBound = arc4random() % [self.arrDeck count];
            int iUpperBound = arc4random() % [self.arrDeck count];
            while (iLowerBound == 0 || iUpperBound == [self.arrDeck count] - 1 || iLowerBound > iUpperBound)
            {
                iLowerBound = arc4random() % [self.arrDeck count];
                iUpperBound = arc4random() % [self.arrDeck count];
            }
            
            //Get the ranges for three segments; the top segment, the segment between bounds, and the bottom segment. Then arrange accordingly.
            NSRange rangeBeforeLowerBound = {0, iLowerBound };
            NSRange rangeAfterUpperBound = {iUpperBound, [self.arrDeck count] - iUpperBound};
            NSRange rangeBetweenBounds = {iLowerBound, iUpperBound-iLowerBound};
            
            NSMutableArray *arrHinduShuffled = [[NSMutableArray alloc] initWithArray:[self.arrDeck subarrayWithRange:rangeBetweenBounds]];
            [arrHinduShuffled addObjectsFromArray:[self.arrDeck subarrayWithRange:rangeBeforeLowerBound]];
            [arrHinduShuffled addObjectsFromArray:[self.arrDeck subarrayWithRange:rangeAfterUpperBound]];
            
            self.arrDeck = arrHinduShuffled;
        }
    }
    //-Hindu shuffle-
    
    
    /* There are many more techniques, the above are just a few basics ones */
    //Note - - - Ideally every human simulating tecnique above would be in its own seperate function/method. For this simple coding test I opted to group the above three common techniques as there where no set requirements for this implementation.
}
//
////Shuffle methods end*


//Deal a random card from remaining cards in the deck
- (IBAction)btnDealCard:(id)sender
{
    //Throw alert and return if no cards to deal
    if (self.arrDeck.count == 0)
    {
        //No specifications whether or not alerts are desired. Will simply display alerts once when/where needed then disable buttons. Will follow this paradigm throughout for all buttons.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Deck" message:@"Can't deal from an empty deck!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        //Set appropriate buttons to disabled.
        [self.btnDealCard setEnabled:false];
        [self.btnShuffleDeck setEnabled:false];
        
        return;
    }
    
    //Get random card, from deck, add to dealt textview and dealt cards array. Lastly remove from the deck, and update deck textview.
    int r = arc4random() % self.arrDeck.count;
    
    NSString *chosenCard = [self.arrDeck objectAtIndex:r];
    
    self.txtCurrentDealt.text = [self.txtCurrentDealt.text stringByAppendingString:[NSString stringWithFormat:@" %@",chosenCard]];
    
    [self.arrDealtCards addObject:[self.arrDeck objectAtIndex:r]];
    [self.arrDeck removeObjectAtIndex:r];
    
    self.txtCurrentDeck.text = [self.txtCurrentDeck.text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@" %@",chosenCard] withString:@""];
    
    //Set appropriate buttons to enabled.
    [self.btnResetDeck setEnabled:true];
    [self.btnReturnLastDealtCard setEnabled:true];
}


//Return to the deck the last given card.
- (IBAction)btnReturnLastDealtCard:(id)sender
{
    //Throw alert and return if no cards to return
    if (self.arrDealtCards.count == 0)
    {
        //No specifications whether or not alerts are desired. Will simply display alerts once when/where needed then disable buttons. Will follow this paradigm throughout for all buttons.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nothing Dealt" message:@"Can't return a card from an empty hand!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        //Set appropriate buttons to disabled.
        [self.btnResetDeck setEnabled:false];
        [self.btnReturnLastDealtCard setEnabled:false];
        
        return;
    }
    
    //Get random card, from deck, add to dealt textview and dealt cards array. Lastly remove from the deck, and update deck textview.
    NSString *chosenCard = [self.arrDealtCards lastObject];
    
    self.txtCurrentDealt.text = [self.txtCurrentDealt.text substringToIndex:self.txtCurrentDealt.text.length- (chosenCard.length+1) ];
    
    [self.arrDeck addObject:chosenCard];
    [self.arrDealtCards removeObject:chosenCard];
    
    self.txtCurrentDeck.text = [self.txtCurrentDeck.text stringByAppendingString:[NSString stringWithFormat:@" %@", chosenCard]];

    //Set appropriate buttons to enabled.
    [self.btnDealCard setEnabled:true];
    if( [self.arrDeck count] > 1)
        [self.btnShuffleDeck setEnabled:true];
}

//Reset the deck.
- (IBAction)btnResetDeck:(id)sender
{
    //Throw alert and return if no cards to return
    if (self.arrDealtCards.count == 0)
    {
        //No specifications whether or not alerts are desired. Will simply display alerts once when/where needed then disable buttons. Will follow this paradigm throughout for all buttons.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nothing Dealt" message:@"There is nothing to return!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        //Set appropriate buttons to disabled.
        [self.btnResetDeck setEnabled:false];
        [self.btnReturnLastDealtCard setEnabled:false];
        
        return;
    }
    
    //Combine all cards into the deck, empty current dealt text along with dealt cards array, and shuffle the deck.
    [self.arrDeck addObjectsFromArray:self.arrDealtCards];
    [self.arrDealtCards removeAllObjects];
    [self.txtCurrentDealt setText:@""];
    [self btnShuffleDeck:self];
    
    //Set appropriate buttons to enabled.
    [self.btnShuffleDeck setEnabled:true];
    [self.btnDealCard setEnabled:true];
}

@end
