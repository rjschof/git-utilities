### Installation

clone the repository

```
mkdir -p ~/GitHub/rkiel
git clone git@github.com:rkiel/git-feature.git
```

add the bin to your path

```
export PATH=~/GitHub/rkiel/git-feature/bin:$PATH
```

### Usage

This utility is built around some standard branch names: `master`, `develop`, and `integration`.

Feature branches have specific format: USER-BASE-FEATURE.

* USER is the username as specificied by the USER environment variable
* BASE is the standard branch to base the feature branch on
* FEATURE is the name of the feature

#### Start

To start a new feature, go to one of the standard branches.

```
git checkout master
```

Use the `start` subcommand with a feature name.

```
feature start my-new-feature
```

For example, a new branch will be created called `rkiel-master-my-new-feature`

#### Rebase

Use the `rebase` subcommand to pull down any changes from the standard branch and then rebase with your feature branch changes.

```
feature rebase
```

#### Merge

Use the `merge` subcommand to merge your feature branch changes to the standard branch.

```
feature merge
```

You can also override the default standard branch by specifying another branch.

```
feature merge integration
```

#### End

Use the `end` subcommand to close out the feature.

```
feature end
```

For example, the feature branch `rkiel-master-my-new-feature` will be deleted and the `master` will be checked out.
