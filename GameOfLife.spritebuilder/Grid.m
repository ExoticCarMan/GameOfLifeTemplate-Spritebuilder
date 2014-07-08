//
//  Grid.m
//  GameOfLife
//
//  Created by Carmine on 7/3/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Grid.h"
#import "Creature.h"

//these variable cannot be changed
static const int GRID_ROWS = 8;
static const int GRID_COLUMNS = 10;

@implementation Grid {
    
    NSMutableArray *_gridArray;
    float _cellWidth;
    float _cellHeight;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    //get x,y coord of touch
    CGPoint touchLocation = [touch locationInNode:self];
    
    //get Creature at touch location
    Creature *creature = [self creatureForTouchPosition:touchLocation];
    
    //invert its state - kill if alive, ressurect if dead
    creature.isAlive = !creature.isAlive;
}

- (Creature *)creatureForTouchPosition:(CGPoint)touchPosition {
    //get row and column that was touched, return Creature inside the corresponding cell
    int row = touchPosition.y/_cellHeight;
    int column = touchPosition.x/_cellWidth;
    
    return _gridArray[row][column];
}

- (void)onEnter {
    [super onEnter];
    [self setupGrid];
    
    //accept touches on grid
    self.userInteractionEnabled = true;
}

- (void)setupGrid {
    //divide grid size by # of columns/rows to determine correct cell width/height
    _cellWidth = self.contentSize.width / GRID_COLUMNS;
    _cellHeight = self.contentSize.height / GRID_ROWS;
    
    float x = 0;
    float y = 0;
    
    //initialize array using empty NSMUtableArray
    _gridArray = [NSMutableArray array];
    
    for (int i = 0; i < GRID_ROWS; i++) {
        _gridArray[i] = [NSMutableArray array];
        x = 0;
        
        //put array in array to create 2D array in Obj-C
        for (int j = 0; j < GRID_COLUMNS; j++) {
            Creature *creature = [[Creature alloc] initCreature];
            creature.anchorPoint = ccp(0, 0);
            creature.position = ccp(x, y);
            [self addChild:creature];
            
            //shorthand for accessing array within array
            _gridArray[i][j] = creature;
            
            //make creature visible to test method
            //set to false after visibility test
            //creature.isAlive = true;
            
            x+=_cellWidth;
        }
        
        y+=_cellHeight;
    }
}

@end
