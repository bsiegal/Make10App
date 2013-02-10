/*******************************************************************************
 *
 * Copyright 2013 Bess Siegal
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 ******************************************************************************/

#import "AboutLayer.h"
#import "IntroLayer.h"

@implementation AboutLayer

UIWebView* _webView;

+(CCScene*) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	AboutLayer *layer = [AboutLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init {
    if (self = [super init]) {
    
        // ask director for the window size
        CGSize winSize = [[CCDirector sharedDirector] winSize];
                
        /*
         * UIView to which UIKit components can be added
         */
        UIView* view = [[CCDirector sharedDirector] view];
        view.frame = CGRectMake(0, 0, winSize.width, winSize.height);
        
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, winSize.width, winSize.height - 24)];
        _webView.delegate = self;
        _webView.hidden = YES;
        
//        NSURL *url = [[NSBundle mainBundle] URLForResource:@"about" withExtension:@".html"];
//        [webView loadRequest:[NSURLRequest requestWithURL:url]];

        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
        
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [_webView loadHTMLString:htmlString baseURL:nil];
        [view addSubview:_webView];
                
        
        /*
         * Back button
         */
        CCMenuItemFont* back = [CCMenuItemFont itemWithString:@"Back" target:self selector:@selector(backAction)];
        [Make10Util styleMenuButton:back];
        
        /*
         * Create the menu
         */
        CCMenu* menu = [CCMenu menuWithItems:back, nil];
        menu.position = ccp(winSize.width / 2, 12);
        [self addChild:menu];
        
    }
    return self;
}

#pragma mark UIWebViewDelegate

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    
    /*
     * This will cause links to be opened in Safari instead of in the app
     */
    if (inType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}
 
-(void) backAction {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:LAYER_TRANS_TIME scene:[IntroLayer scene]]];
}

-(void) onEnterTransitionDidFinish {
    /*
     * Since the UIKit components do not respond to cocos scene changes, just using this as a workaround
     */
    _webView.hidden = NO;
    [super onEnterTransitionDidFinish];
}

-(void) onExitTransitionDidStart {
    /*
     * Since the UIKit components do not respond to cocos transitions, just using this as a workaround
     */
    _webView.hidden = YES;
    [super onExitTransitionDidStart];
}

-(void) dealloc {
    
    [_webView release];
    _webView = nil;
        
    [super dealloc];
}

@end
