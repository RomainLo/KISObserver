## 1.1.0
### Enhancements

* The observeObject: methods don't raise an exception anymore when the given observable is nil.
* The KISNotifier has the description method for a better debugging.
* The KISNotifier returns empty indexSet instead of nil value for removals, insertions and replacements.
* Improvement of the 'How to use' and 'How to install' section of the README.

### Fix

* Solve an issue with the initial options and many keypaths at the same time. Now each property have it own initial notification with its old and new values.
