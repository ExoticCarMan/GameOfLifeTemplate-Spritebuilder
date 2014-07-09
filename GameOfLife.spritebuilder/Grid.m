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

- (void)evolveStep {
    //update each Creature's neighbor count
    [self countNeighbors];
     
    //update each Creature's current state
    [self updateCreatures];
    
    //update generation label
    _generation++;
}

- (int)countNeighbors {
    //iterate through rows
    //NSArray has method 'count' that returns # of elements in array
    for (int i = 0; i < [_gridArray count]; i++) {
        //iterate through columns in row
        for (int j = 0; j < [_gridArray[i] count]; j++) {
            //access creature in cell that corresponds to row/column
            Creature *currentCreature = _gridArray[i][j];
            
            //every Creature has 'livingNeighbors' property created earlier
            currentCreature.livingNeighbors = 0;
            
            //examine every cell around current one
            // go through the row on top of current cell, the row cell is in, and the row past current cell
            for (int x = (i-1); x <= i+1; x++) {
                // go through the column to the left of the current cell, the column the cell is in, and the column to the right of the current cell
                for (int y = (j-1); x <= j+1; y++) {
                    //check that cell we're checking off isn't on screen
                    BOOL isIndexValid = [self isIndexValidForX:x andY:y];
                    
                    // skip over all cells that are off screen AND the cell that contains the creature we are currently updating
                    if (!((x == i) && (y == j)) && isIndexValid) {
                        Creature *neighbor = _gridArray[x][y];
                        if (neighbor.isAlive) {currentCreature.livingNeighbors++;}
                    }
                }
            }
        }
    }
}

- (BOOL)isIndexValidForX:(int)x andY:(int)y
{
    BOOL isIndexValid = YES;
    if(x < 0 || y < 0 || x >= GRID_ROWS || y >= GRID_COLUMNS)
    {
        isIndexValid = NO;
    }
    return isIndexValid;
}

- (BOOL)updateCreatures {
    // iterate through the rows
    // note that NSArray has a method 'count' that will return the number of elements in the array
    for (int i = 0; i < [_gridArray count]; i++)
    {
        // iterate through all the columns for a given row
        for (int j = 0; j < [_gridArray[i] count]; j++)
        {
            // access the creature in the cell that corresponds to the current row/column
            Creature *currentCreature = _gridArray[i][j];
            
            // remember that every creature has a 'livingNeighbors' property that we created earlier
            currentCreature.livingNeighbors = 0;
            
            // now examine every cell around the current one
            
            // go through the row on top of the current cell, the row the cell is in, and the row past the current cell
            for (int x = (i-1); x <= (i+1); x++)
            {
                // go through the column to the left of the current cell, the column the cell is in, and the column to the right of the current cell
                for (int y = (j-1); y <= (j+1); y++)
                {
                    // check that the cell we're checking isn't off the screen
                    BOOL isIndexValid = [self isIndexValidForX:x andY:y];
                    
                    // skip over all cells that are off screen AND the cell that contains the creature we are currently updating
                    if (!((x == i) && (y == j)) && isIndexValid) {
                        if (currentCreature.livingNeighbors == 3) {
                            currentCreature.isAlive = true;
                        }
                        else if (currentCreature.livingNeighbors <= 1 || currentCreature.livingNeighbors >= 4) {
                            currentCreature.isAlive = false;
                        }
                    }
                }
            }
        }
    }
}

@end
