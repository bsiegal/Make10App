//
//  Make10AppLayer.h
//  Make10App
//
//  Created by Bess Siegal on 1/25/13.
//  Copyright Bess Siegal 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// Make10AppLayer
@interface Make10AppLayer : CCLayerColor <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
}

// returns a CCScene that contains the Make10AppLayer as the only child
+(CCScene *) scene;

@end
