# Table + Search Issue

This project demonstrates the problems with trying to hide a search bar on initial load.

The conventional wisdom on the web is to set your `tableView`’s `contentOffset`:

```swift
self.tableView.contentOffset = CGPointMake(0, CGRectGetHeight(controller.searchBar.frame))
```

> See code [here](TableExample/BasicTableViewController.swift).

And in most cases, this works. But not in all cases. The issue has to do with what you set `self.tableView.estimatedRowHeight` to.

| Cell Type | Cells | estimatedRowHeight | Hide Search | Formated Properly? |
|-----------|-----------|----------------|-------|---------|
| UITableViewCell | Few  | UITableViewAutomaticDimension | :+1: | :x: |
| UITableViewCell | Many | UITableViewAutomaticDimension | :+1: | :x: |
| UITableViewCell | Few | Fixed number | :x: | :x: |
| UITableViewCell | Many | Fixed number | :+1: | :x: |
| CustomCell | Few  | UITableViewAutomaticDimension | :+1: | :x: |
| CustomCell | Many | UITableViewAutomaticDimension | :+1: | :x: |
| CustomCell | Few | Fixed number | :x: | :+1: |
| CustomCell | Many | Fixed number | :+1: | :+1: |

> “Few cells” means not enough to fill the entire screen

The default cell (`UITableViewCell`) hides the search bar most of the time. The only case where it has an issue is when there aren’t enough cells to fill the screen and you set `estimatedRowHeight` to a fixed number. In that case, the scrollbar won’t let you slide the search bar up (i.e. hide it).

The problem with the default cell is that the text doesn't wrap properly. That is where the custom cell comes in (obviously, there are other times you might want to use a custom cell as well).

With the custom cell the search bar will hide if you set `estimatedRowHeight` to `UITableViewAutomaticDimension`, but then the cell isn't presented properly.

In order for the custom cell to wrap properly you need to set `estimatedRowHeight` to a fixed number. This then falls into the same problem that the default cell has. If there are enough cells to fill the screen, then it works properly. Otherwise the scrollview won’t let it slide the search bar up.

Based on all of this, there appears to be a bug between `estimatedRowHeight` and `tableView.contentOffset`. Or with custom cells being able to expand properly when using `UITableViewAutomaticDimension`.
