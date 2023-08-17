# dotfiles

My
[dotfiles](https://en.wikipedia.org/wiki/Hidden_file_and_hidden_directory#Unix_and_Unix-like_environments)
including management system.
Dotfiles or config folders are symlinked to their normal spot from this repository.
This allows choosing a subset of files to install.
Groups are also supported, allowing for quick installation of often used together configurations.

## Installation

```
./install.sh install [TARGET] [...]
```

`TARGET` can be either a specific target or a set.

## Configuration

### Adding a new file or folder

#### Automatically

```
./install add <PATH>
```

#### Manually

Add a new line in `config.csv`

```
<name>;<path relative to $HOME>
```

### Creating a file set

Add a new line in `sets.csv`

```
<NAME>;[TRAGET] [...]
```

Sets can be used recursively.

### Hooks

`install.sh` calls hook scripts for some actions.
they are stored in `hooks/`.
Hooks have to be named `<Name>.hook` and be executable.

Currently supported hooks:

| Name | Arguments | Called when | Notes
| --- | --- | --- |
| `housekeeping` | | before the script quits | Used to ensure everything is in order. |
| `installed.<target>` | Full target path | After successful install of <target> | For specific targets |
| `installed` | Full target path | After successful install of any config | For all targets |
| `post_add` | Name, Target path | After config was added to the database | |

Hooks can be manually called with `./install.sh hook <name>`

### Shell environment

If `.bashrc` and `.bash_profile` are managed, config is loaded from `bash/`.
`*.profile` is sourced after an interactive login, `*.bash` on ervery launch of a new shell.
An external configuration to allow host specific settings, without tainting the git repo, is created at `$HOME/.files.config`.
It is populated from `config.default` if it does not exist.
Scripts in `bash/` use its variables as configuration.
If the variables do not exist in `.files.config`, the default values from `config.default` are used.
