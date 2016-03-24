# Table + Search Issue

This project demonstrates the problems with trying to hide a search bar on initial load.

The conventional wisdom on the web is to set your `tableView`’s `contentOffset`:

```swift
self.tableView.contentOffset = CGPointMake(0, CGRectGetHeight(controller.searchBar.frame))
```

> See code [here](TableExample/BasicTableViewController.swift).

And in most cases, this works. But not in all cases. The issue has to do with what you set `self.tableView.estimatedRowHeight` to.

| Cell Type | Condition | estimatedRowHeight | work? |
|—————|———|——|
| UITableViewCell | Few cells | UITableViewAutomaticDimension | YES |
| UITableViewCell | Lots of cells | UITableViewAutomaticDimension | YES |
| UITableViewCell | Few cells | Fixed number | NO |
| UITableViewCell | Lots of cells | Fixed number | YES |
| CustomCell | Few cells | UITableViewAutomaticDimension | Kind of |
| CustomCell | Lots of cells | UITableViewAutomaticDimension | Kind of |
| CustomCell | Few cells | Fixed number | NO |
| CustomCell | Lots of cells | Fixed number | YES |

> “Few cells” means not enough to fill the entire screen

The default cell (`UITableViewCell`) works most of the time. The only case where it has an issue is when there aren’t enough cells to fill the screen and you set `estimatedRowHeight` to a fixed number. In that case, the scrollbar won’t let you slide the search bar up (i.e. hide it).

Obviously with the default cell, you can’t make the text in the cell wrap. That is where the custom cell comes in (and there are other times you might want to use a custom cell).

With the custom cell the search bar will hide if you set `estimatedRowHeight` to `UITableViewAutomaticDimension`, the problem is that the cell doesn’t allow for the text to wrap properly.

In order for the custom cell to wrap properly you need to set `estimatedRowHeight` to a fixed number. This then falls into the same problem that the default cell has. If there are enough cells to fill the screen, then it works properly. Otherwise the scrollview won’t let it slide the search bar up.

Based on all of this, there appears to be a bug between `estimatedRowHeight` and `tableView.contentOffset`.