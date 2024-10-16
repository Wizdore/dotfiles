Most of the dotfiles are chezmoi, except the nixos configs. Im seperaing those out to $HOME/.config/nixos. After applying chezmoi from these repo those needs to be rsynced to /etc/nixos. This setup would then cover both the Home configs and System configs.

# Chezmoi Cheatsheet

## Installation

```bash
sh -c "$(curl -fsLS get.chezmoi.io)"
```

## Initialization

```bash
chezmoi init
```

## Adding Files

```bash
chezmoi add ~/.bashrc
chezmoi add ~/.config/git/config
```

## Editing Files

```bash
chezmoi edit ~/.bashrc
```

## Applying Changes

```bash
chezmoi apply
```

## Viewing Differences

```bash
chezmoi diff
```

## Managing Secrets

```bash
chezmoi add --encrypt ~/.secret_file
```

## Templates

Use in dotfiles:
```
{{ .chezmoi.hostname }}
{{ .chezmoi.os }}
{{ .chezmoi.arch }}
```

## Scripts

```bash
chezmoi add --autotemplate ~/.script.sh
```

## Version Control

```bash
chezmoi cd
git add .
git commit -m "Update dotfiles"
git push
```

## Updating from Source

```bash
chezmoi update
```

## Removing Files

```bash
chezmoi forget ~/.obsolete_file
```

## Dry Run

```bash
chezmoi apply --dry-run --verbose
```

For more details, visit the [Chezmoi Documentation](https://www.chezmoi.io/user-guide/command-overview/).
