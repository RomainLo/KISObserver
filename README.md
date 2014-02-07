# KISObserver

KISObserver is an easy way to use the [**Key-Value Observing**](https://developer.apple.com/library/mac/documentation/cocoa/conceptual/KeyValueObserving/KeyValueObserving.html) (**KVO**) pattern.

You can observe objects for keypaths with **blocks**, **selectors** and the usual API.
Moreover, the observer removes automagically the observations when it is deallocated.

## How to use it

An observation with a block and the default options:
```objective-c
[self observeObject:ob forKeyPaths:@"property" withBlock:^(KISNotification *notification) {
	NSLog(@"New value:\t%@", notification.newValue);
	NSLog(@"Old value:\t%@", notification.oldValue);
}];
```

An observation with a selector on a one-to-many relation:
```objective-c
NSKeyValueObservingOptions opt = NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
[self observeObject:ob forKeyPaths:@"arr" options:opt withSelector:@selector(onChangeWithNotification:)];

// ...

- (void)onChangeWithNotification:(KISNotification *)notification
{
	NSLog(@"isSetting:\t%hhd", notification.isSetting);
	NSLog(@"Insertions:\t%@", notification.insertionIndexSet);
	NSLog(@"Removals:\t%@", notification.removalIndexSet);
	NSLog(@"Replacements:\t%@", notification.replacementIndexSet);
}
```

Your dealloc:
```
- (void)dealloc
{
	// Nothing to do. :-)
}
```

## How to install it

Use CocoaPods!

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which
automates and simplifies the process of using 3rd-party libraries in your projects.

1. Add the project inside your Podfile

        pod KISObserver, '~> 1.0.x'
    
2. Update your installation
        
        pod install


## License

KISObserver is available under the MIT license. See the LICENSE file for more info.
