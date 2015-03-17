![](http://i24.photobucket.com/albums/c50/KKS-KKS/Screen%20Shot%202015-03-17%20at%2010.18.44%20AM_1.png)

Pager is the simplest and best way to implement sliding view controllers.

<img src="https://raw.githubusercontent.com/lucoceano/CKViewPager/master/Resources/screen1.png"  alt="CKViewPager" title="CKViewPager">
![Demo](https://raw.githubusercontent.com/lucoceano/CKViewPager/master/Resources/CKViewPager.gif)


## Installation

#### CocoaPods (*soon*)

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

CocoaPods 0.36 adds supports for Swift and embedded frameworks. You can install the Pager with the following command:

 `pod 'Pager'`

#### Copying files

Just copy PagerController.swift files to your project.

## Usage

Subclass PagerController (as it's a `UIViewController` subclass) and implement dataSource methods in the subclass.

In the subclass assign self as dataSource, 

```Swift
override func viewDidLoad() {
        super.viewDidLoad()
		self.dataSource = self
	}
```

## Contact

[Lucas Martins](mailto:lucoceano@ckl.io) - [ckl.io](http://www.ckl.io)

Pager is a port from [CKViewPager](https://github.com/lucoceano/CKViewPager) to swift.

## Licence
Pager is MIT licensed. See the LICENCE file for more info.
