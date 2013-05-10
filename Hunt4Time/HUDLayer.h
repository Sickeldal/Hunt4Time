//
//  HUDLayer.h
//  Hunt4Time
//
//  Created by admin on 4/24/13.
//  Copyright 2013 David. All rights reserved.
//

#import <Foundation/Foundation.h>
<<<<<<< HEAD
#import "cocos2d.h" // HEJ DENNIS LUKTAR KUNGLIGT
=======
#import "cocos2d.h" //Hej Adam 2 gånger om!
>>>>>>> adam_dev



@interface HUDLayer : CCLayerColor
{
    CCLabelTTF *scoreLabel;
    int score;
    
    //Min lives Array
    NSMutableArray * lives;
    
}

//Mitt property på min lives
@property (nonatomic,retain) NSMutableArray * lives;



-(void)addToScore:(int)number;



@end
