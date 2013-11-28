//
//  Deck.h
//  Matchismo
//
//  Created by Juan Posadas on 9/28/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard: (Card *)card;
- (Card *)drawRandomCard;

@end
