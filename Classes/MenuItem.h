//
//  MenuItem.h
//  iNetHack
//
//  Created by dirk on 6/29/09.
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

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface MenuItem : NSObject
@property (nonatomic, copy)     NSString *title;
@property (nonatomic, strong, nullable)   id target;
@property (nonatomic, assign, nullable)   SEL action;
@property (nonatomic, assign)   BOOL accessory;
@property (nonatomic, strong, nullable)   NSArray *children;
@property (nonatomic, readonly) char key;
@property (nonatomic, assign)   NSInteger tag;

+ (instancetype) menuItemWithTitle:(NSString *)n target:(nullable id)t action:(nullable SEL)s accessory:(BOOL)a;
+ (instancetype) menuItemWithTitle:(NSString *)n children:(NSArray *)ch;
+ (instancetype) menuItemWithTitle:(NSString *)n key:(char)k accessory:(BOOL)a;
+ (instancetype) menuItemWithTitle:(NSString *)n key:(char)k;
- (instancetype) initWithTitle:(NSString *)n target:(nullable id)t action:(nullable SEL)s accessory:(BOOL)a NS_DESIGNATED_INITIALIZER;
- (instancetype) initWithTitle:(NSString *)n children:(NSArray *)ch;
- (instancetype) initWithTitle:(NSString *)n key:(char)k accessory:(BOOL)a;
- (instancetype) initWithTitle:(NSString *)n key:(char)k;
- (void) invoke;

@end

NS_ASSUME_NONNULL_END
