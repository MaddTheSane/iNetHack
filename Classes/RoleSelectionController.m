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

#import "RoleSelectionController.h"
#import "MenuItem.h"
#import "MenuViewController.h"
#import "hack.h"

@interface RoleSelectionController ()
@property (strong) UINavigationController *navigationController;
- (instancetype)initWithNavigationController:(UINavigationController *)navController;
- (void)moveToNextStep:(id)sender;
@end

enum {
	RESET_ROLE,
	RESET_RACE,
	RESET_GENDER,
	RESET_ALIGNMENT,
};

static void reset_choices (int type)
{
	switch(type)
	{
		case RESET_ROLE:      flags.initrole  = -1;
		case RESET_RACE:      flags.initrace  = -1;
		case RESET_GENDER:    flags.initgend  = -1;
		case RESET_ALIGNMENT: flags.initalign = -1;
	}
}

@implementation RoleSelectionController
{
	UINavigationController *navigationController;
}
- (void)showChoices:(NSArray<MenuItem*> *)items withTitle:(NSString *)title {
	if (items.count > 1) {
		MenuViewController* controller = [MenuViewController new];
		controller.title     = title;
		controller.menuItems = items;

		[self.navigationController pushViewController:controller animated:self.navigationController.viewControllers.count > 1];
	} else {
		MenuItem *item = [items objectAtIndex:0];
		[self performSelector:item.action withObject:item];
	}
}

// ===================
// = Selection steps =
// ===================

- (void)didSelectAlignment:(id)sender
{
	NSAssert([sender respondsToSelector:@selector(tag)], @"sender has no tag");

	reset_choices(RESET_ALIGNMENT);
	flags.initalign = (int) [sender tag];

	[self moveToNextStep:nil];
}

- (void)selectAlignment
{
	NSMutableArray *items = [NSMutableArray new];
	for (int i = 0; i < ROLE_ALIGNS; i++) {
		if (validalign(flags.initrole, flags.initrace, i)) {
			MenuItem *item = [MenuItem new];
			item.title     = [[NSString stringWithCString:aligns[i].adj encoding:NSASCIIStringEncoding] capitalizedString];
			item.target    = self;
			item.action    = @selector(didSelectAlignment:);
			item.tag       = i;
			item.accessory = YES;
			[items addObject:item];
		}
	}
	[self showChoices:items withTitle:@"Your Alignment?"];
}

- (void)didSelectGender:(id)sender
{
	NSAssert([sender respondsToSelector:@selector(tag)], @"sender has no tag");

	reset_choices(RESET_GENDER);
	flags.initgend = (int) [sender tag];

	[self moveToNextStep:nil];
}

- (void)selectGender
{
	NSMutableArray *items = [NSMutableArray new];
	for (int i = 0; i < ROLE_GENDERS; i++) {
		if (validgend(flags.initrole, flags.initrace, i)) {
			MenuItem *item = [MenuItem new];
			item.title     = [[NSString stringWithCString:genders[i].adj encoding:NSASCIIStringEncoding] capitalizedString];
			item.target    = self;
			item.action    = @selector(didSelectGender:);
			item.tag       = i;
			item.accessory = YES;
			[items addObject:item];
		}
	}
	[self showChoices:items withTitle:@"Your Gender?"];
}

- (void)didSelectRace:(id)sender
{
	NSAssert([sender respondsToSelector:@selector(tag)], @"sender has no tag");

	reset_choices(RESET_RACE);
	pl_race = [sender tag];
	flags.initrace = (int) [sender tag];

	[self moveToNextStep:nil];
}

- (void)selectRace
{
	NSMutableArray *items = [NSMutableArray new];
	for (int i = 0; races[i].noun; i++) {
		if (validrace(flags.initrole, i)) {
			MenuItem *item = [MenuItem new];
			item.title     = [[NSString stringWithCString:races[i].noun encoding:NSASCIIStringEncoding] capitalizedString];
			item.target    = self;
			item.action    = @selector(didSelectRace:);
			item.tag       = i;
			item.accessory = YES;
			[items addObject:item];
		}
	}
	[self showChoices:items withTitle:@"Your Race?"];
}

- (void)didSelectRole:(id)sender
{
	NSAssert([sender respondsToSelector:@selector(tag)], @"sender has no tag");

	reset_choices(RESET_ROLE);
	flags.initrole = (int) [sender tag];
	strcpy(pl_character, roles[flags.initrole].filecode);

	[self moveToNextStep:nil];
}

- (void)selectRole
{
	NSMutableArray *items = [NSMutableArray new];
	for (int i = 0; roles[i].name.m; ++i) {
		MenuItem *item = [MenuItem new];
		item.title     = [NSString stringWithCString:roles[i].name.m encoding:NSASCIIStringEncoding];
		item.target    = self;
		item.action    = @selector(didSelectRole:);
		item.tag       = i;
		item.accessory = YES;
		[items addObject:item];
	}
	[self showChoices:items withTitle:@"Your Role?"];
	self.navigationController.navigationBar.topItem.hidesBackButton = YES;
}

// ==================
// = Setup/Teardown =
// ==================

@synthesize delegate, navigationController;

+ (id)roleSelectorWithNavigationController:(UINavigationController *)navController;
{
	// Object is self-retained until the process is completed
	return [[RoleSelectionController alloc] initWithNavigationController:navController];
}

- (id)initWithNavigationController:(UINavigationController *)navController
{
	if (self = [super init]) {
		self.navigationController = navController;
	}
	return self;
}

- (void)moveToNextStep:(id)sender
{
	if (flags.initrole == -1)  return [self selectRole];
	if (flags.initrace == -1)  return [self selectRace];
	if (flags.initgend == -1)  return [self selectGender];
	if (flags.initalign == -1) return [self selectAlignment];

	// Done
	[self.navigationController popToRootViewControllerAnimated:NO];
	[self.delegate didCompleteRoleSelection:self];
	//[self autorelease];
}

- (void)start
{
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self moveToNextStep:nil];
}
@end
