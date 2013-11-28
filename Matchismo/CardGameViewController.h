//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Juan Posadas on 9/27/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"
#import "Grid.h"

@interface CardGameViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *cardViews;
@property (weak, nonatomic) IBOutlet UIView *gameView;
@property (strong, nonatomic) Grid *gameGrid;
@property (nonatomic, strong) CardMatchingGame *game;
@property (strong, nonatomic) Deck *playingDeck;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) NSString *firstLabel;
@property (nonatomic) NSUInteger startingNumberOfCells;

- (void)tap:(UITapGestureRecognizer *)gesture;
- (void)removeAllViewsFromSuperView: (UIView *)view;
- (void)setUpGrid;
- (void)populateGrid;
- (void)updateScore;
- (void)recreateAndPopulateGrid;

// abstract classes
- (Deck *)createDeck;
- (void)setMatchMode;

- (UIView *)createCardView;

- (void)updateCardView: (UIView *)cardView usingCard: (Card *)card animated:(BOOL) animated withDelayCounter: (NSUInteger)delayCounter;
- (void)updateCardsUIWithTouchIndex:(NSUInteger)index;




@end
