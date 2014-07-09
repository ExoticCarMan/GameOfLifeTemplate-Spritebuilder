//
//  Grid.h
//  GameOfLife
//
//  Created by Carmine on 7/3/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Grid : CCSprite

@property (nonatomic, assign) int totalAlive;
@property (nonatomic, assign) int generation;

- (void)evolveStep;
- (int)countNeighbors;
- (void)updateCreatures;

@end
