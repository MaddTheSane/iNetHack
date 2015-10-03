//
//  MainView.h
//  iNetHack
//
//  Created by dirk on 6/26/09.
//  Copyright 2009 Dirk Zimmermann. All rights reserved.
//

//  This file is part of iNetHack.
//
//  iNetHack is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 2 of the License only.
//
//  iNetHack is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with iNetHack.  If not, see <http://www.gnu.org/licenses/>.

#import <UIKit/UIKit.h>

#import "hack.h"

NS_ASSUME_NONNULL_BEGIN

#define kKeyTileSize (@"tileSize")

@class MainViewController, TilePosition, Window, TileSet, ShortcutView;

@interface MainView : UIView {

	MainViewController *mainViewController;
	UIFont *statusFont;
	CGSize maxTileSize;
	CGSize minTileSize;
	IBOutlet UITextField *__weak dummyTextField;

	BOOL tiled;
	TileSet *tileSet;
	TileSet *tileSets[2];
	
	CGPoint offset;
	ShortcutView *shortcutView;
	
	UIImage *petMark;
	
	CGSize tilesetTileSize;
	BOOL asciiTileset;
	
	UIButton *moreButton;
	
	NSString *bundleVersionString;
    
    NSCache * cache; //iNethack2: glyph cache for faster rendering
}

@property (nonatomic, readonly) CGPoint start;
@property (nonatomic, readonly) CGSize tileSize;
@property (weak, nonatomic, readonly, nullable) IBOutlet UITextField *dummyTextField;
@property (nonatomic, readonly, getter=isMoved) BOOL moved;
@property (nonatomic, readonly, strong) TileSet *tileSet;
@property (nonatomic, strong) Window *map;
@property (nonatomic, strong) Window *status;
@property (nonatomic, strong) Window *message;
@property (nonatomic, readonly) CGPoint subViewedCenter;
@property (nonatomic, readonly, retain) NSCache *cache; //iNethack2: glyph cache

- (void) drawTiledMap:(Window *)m clipRect:(CGRect)clipRect;
- (void) checkForRogueLevel;
- (UIFont *) fontAndSize:(nullable CGSize *)size forStrings:(NSArray<NSString*> *)strings withFont:(UIFont *)font;
- (UIFont *) fontAndSize:(nullable CGSize *)size forString:(NSString *)s withFont:(UIFont *)font;
- (TilePosition *) tilePositionFromPoint:(CGPoint)p;
- (void) moveAlongVector:(CGPoint)d;
- (void) resetOffset;
- (void) zoom:(CGFloat)d;
- (void) resetGlyphCache; //iNethack2: reset cache each time level change to ensure walls are correct set
@end

NS_ASSUME_NONNULL_END
