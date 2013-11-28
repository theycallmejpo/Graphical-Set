//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Juan Posadas on 10/13/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (instancetype) init
{
    self = [super init];
    
    if (self) {
        for (NSUInteger number = 1; number <= [SetCard maxNumber]; number++) {
            for (NSUInteger symbol = 1; symbol <= [SetCard maxSymbol]; symbol++) {
                for (NSUInteger shading = 1; shading <= [SetCard maxShading]; shading++) {
                    for (NSUInteger color = 1; color <= [SetCard maxColor]; color++) {
                        SetCard *card = [[SetCard alloc] init];
                        card.number = number;
                        card.symbol = symbol;
                        card.shading = shading;
                        card.color = color;
                        [self addCard:card];
                    }
                }
            }
        }
    }
    
    return self;
}


@end
