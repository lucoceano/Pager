![](https://lh4.googleusercontent.com/oCGIPXlqsYTFDjgWAJ7Oejqt16fFTk07mKAyDR4uzdCC_yTU-3neXVWU8sNCe9TojRhXCGoW2v_-JOM=w2560-h1234)

Pager is the simplest and best way to implement sliding view controllers.

## Example
![](https://lh5.googleusercontent.com/_xghIQbcIaHcLTiJb4PaJ9TDPLwcCKkrPBDlVmhCz6foB63b4WAbBimhMyWtoHvi6eFbBKeZRhiv4JY=w2560-h1234)
![](https://lh4.googleusercontent.com/WBY43y8Uf7E0-nNiPsX2G2brQBlrSdbTldX3TvXZGUR_og3-F0HXh3V98nZvZESRRTOEWdEDxMIhQAY=w2560-h1234)


## Installation
Drop in the Spring folder to your Xcode project.

Or via CocoaPods pre-release:
```CocoaPods
platform :ios, '8.0'
pod 'Pager'
use_frameworks!
```

## Usage

Subclass PagerController (as it's a `UIViewController` subclass) and implement data source methods in the subclass.

#### Usage with Code

```Swift
override func viewDidLoad() {
	super.viewDidLoad()
	self.dataSource = self
}
```
## Data Source

```Swift
func numberOfTabs(pager: PagerController) -> Int
func tabViewForIndex(index: Int, pager: PagerController) -> UIView
optional func viewForTabAtIndex(index: Int, pager: PagerController) -> UIView
optional func controllerForTabAtIndex(index: Int, pager: PagerController) -> UIViewController
```

## Delegate
```Swift
optional func didChangeTabToIndex(pager: PagerController, index: Int)
optional func didChangeTabToIndex(pager: PagerController, index: Int, previousIndex: Int)
optional func didChangeTabToIndex(pager: PagerController, index: Int, previousIndex: Int, swipe: Bool)
```

## Contact

[Lucas Martins](mailto:lucoceano@ckl.io) - [ckl.io](http://www.ckl.io)

Pager is a port from [CKViewPager](https://github.com/lucoceano/CKViewPager) to swift.

## Licence
Pager is MIT licensed. See the LICENCE file for more info.
