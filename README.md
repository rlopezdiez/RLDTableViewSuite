# RLDTableViewSuite

The ubiquitous `UITableView`, with its required data source and delegate, is one of the main sources of badly architected solutions in the iOS platform. SDK classes, as `UITableViewController`, enforce bad design practices, and lead you to the problem of the Massive View Controller, where the single responsibility principle is completely missed.

`RLDTableViewSuite` is a set of ready-to-use protocols and classes that will get you back in track, helping you to refine the shape of your app. They enforce the SOLID principles, with an adaptation of the Model-View-Presenter pattern.

## Foundations

### RLDTableViewDataSource and RLDTableViewDelegate

These classes are reusable components for the data source and delegate of all your table views. With them, you won't need to write the same boilerplate code again and again –they will just use your table view model and event handlers to be able to manage any `UITableView`. 

They fully implement the `UITableViewDataSource` and `UITableViewDelegate` protocols, and keep synchronized between themselves, giving you all the `UITableView` features with little effort from your side:
- Display customization
- Variable height support
- Sections, with headers and footers
- Sections index titles
- Cell accessories (disclosures)
- Highlighting and selection of cells
- Editing, moving and reordering cells
- Indentation
- Copy and Paste


### Table view model

The table view model defines the state, look and feel of the views in your table view, and the relationships between them. You can use your own classes, conforming to the corresponding model protocol, or the provided generic implementations, with the same names:

- `RLDTableViewCellModel`, for cells,
- `RLDTableViewSectionModel`, for table sections,
- `RLDTableViewSectionAccessoryViewModel`, for section headers and footers, and
- `RLDTableViewModel`, for the table view itself.

### Event handlers

Every view in your table view (like cells, section headers and section footers) should be managed by an event handler. It will receive all the view related actions from the table view delegate and react to user generated events on the view. 

Event handlers are short-lived objects that will be instantiated on demand and destroyed once the event that caused its creation has been handled or when the view they manage is deallocated. They should not store state *(because we have a model, right?)* and they can either configure the look of the view by themselves, or pass the view model to the view, so it can autoconfigure. The provided sample app uses the latest approach.

You have two event handlers protocols, and generic implementations of both:
- `RLDTableViewCellEventHandler`, for table view cells, and
- `RLDTableViewSectionAccessoryViewEventHandler`, for section headers and footers.

Although it is not mandatory, if the handled view conforms to the `RLDHandledViewProtocol` it will receive an event handler just before the view is displayed for the first time. The view can retain this event handler during all its lifecycle to be able to react to the user generated events on the view. 

If the view implements the optional method `eventHandler` to return the retained event handler, the delegate will try to reuse it together with the cell. Fully conformance to the `RLDHandledViewProtocol` in your views is recommended if you are concerned about performance.

### Event handler provider

In order to create the best suited event handler on demand, `RLDTableViewDelegate` will need an event handler provider conforming to the `RLDTableViewEventHandlerProvider` protocol. 

If you don't want to code your own provider, you can use the included generic implementation, named after the protocol. This class has a factory method that will iterate through all the classes registered with the provider, returning the first found event handler which supports a certain combination of table view, view and view model.

If no class has been registered with the provider, it will check all the runtime available classes looking for those conforming to the event handler protocols. This can be quite time consuming, as several thousand classes are usually loaded at runtime, so manual registering of classes with the event handler provider is highly advisable.

When using manual registering, the best way to make sure all your classes are ready when needed is registering them in their `load` method. The included sample app implements this approach:

```objectivec
#import "RLDTableViewEventHandlerProvider.h"
...

+ (void)load {
    [RLDTableViewEventHandlerProvider registerEventHandlerClass:self];
}
```

### RLDTableViewController 

This class is a drop-in replacement of `UITableViewController`. It just requires a table view model to be able to configure your table view. Internally, it uses the default implementations of `RLDTableViewDataSource`, `RLDTableViewDelegate` and `RLDTableViewEventHandlerProvider`, so it's the easiest way to use `RLDTableViewSuite` without worrying about its internals, while getting the most of having a proper architecture.

## Installing

### Using CocoaPods

To use the latest stable release of `RLDTableViewSuite`, just add the following to your project `Podfile`:

```
pod 'RLDTableViewSuite', '~> 0.1.0' 
```

If you like to live on the bleeding edge, you can use the `master` branch with:

```
pod 'RLDTableViewSuite', :git => 'https://github.com/rlopezdiez/RLDTableViewSuite'
```

### Manually

1. Clone, add as a submodule or [download.](https://github.com/rlopezdiez/RLDTableViewSuite/zipball/master)
2. Add all the files under `Classes` to your project.
3. Enjoy.

## License

`RLDTableViewSuite` is available under the Apache License, Version 2.0. See LICENSE file for more info.

This README has been made with [(GitHub-Flavored) Markdown Editor](http://jbt.github.io/markdown-editor)