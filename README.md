# Setting up

Clone as a bare repository:

```
git clone --bare https://github.com/acfohegi/dotfiles.git $HOME/.dotfiles
```

Add `alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'` to shell configs

Unpack dotfiles:

```
dotfiles checkout
```

