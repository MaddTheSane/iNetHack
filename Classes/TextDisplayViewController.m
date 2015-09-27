//
//  TextDisplayViewController.m
//  iNetHack
//
//  Created by dirk on 7/10/09.
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

#import "TextDisplayViewController.h"
#import "MainViewController.h"

@implementation TextDisplayViewController
{
	UIWebView *webView;
	UITextView *textView;
	NSCondition *condition;
	NSString *text;
	BOOL isHTML;
	BOOL isLog;
}

@synthesize text, condition;
@synthesize HTML = isHTML;
@synthesize log = isLog;

- (void)updateText {
	if (textView) {
		textView.text = self.text;
		if (isLog && self.text && self.text.length > 0) {
			NSRange r = NSMakeRange(self.text.length-1, 1);
			[textView scrollRangeToVisible:r];
		}
	} else if (webView) {
		[webView loadHTMLString:self.text baseURL:nil];
	}
}

- (void)setText:(NSString *)newText {
	if (newText != text) {
		text = [newText copy];
		[self updateText];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
	if ([[NSArray arrayWithObjects:@"http", @"https", nil] containsObject:request.URL.scheme]
		&& navigationType == UIWebViewNavigationTypeLinkClicked) {
		// Open clicked http links in Safari
		[[UIApplication sharedApplication] openURL:request.URL];
		return NO;
	}
	return YES;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if (self.isHTML) {
		webView = [[UIWebView alloc] initWithFrame:self.view.frame];
		webView.backgroundColor = [UIColor blackColor];
		webView.delegate = self;
		self.view = webView;
	} else {
        textView = [[UITextView alloc] initWithFrame:self.view.frame];
		textView.backgroundColor = [UIColor blackColor];
		textView.textColor = [UIColor whiteColor];
		textView.editable = NO;
        textView.scrollEnabled = NO;    //iOS9 fix: disable then enable scrolling so initial scrolling works
        textView.scrollEnabled = YES;   //...
		self.view = textView;
	}
	[self updateText];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	if (condition) {
		[[MainViewController instance] broadcastCondition:condition];
	}
}
@end
