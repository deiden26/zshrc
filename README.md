# zsh in a box

### Steps to Success
1. Install zsh if it isn't already installed in your terminal
    - Run `echo $SHELL` to confirm zsh is installed and set as the default shell
    - The expected result is `/usr/zsh` or something similar
2. Clone this repository wherever you like
3. Remove the `.zshrc` file in your home directory, if there is one
4. Symbolically link the `.zshrc` file in this repo to your home directory
    - You must use the full path when creating the symbolic link
    - You can run the following from the this repo's directory to create the link
```bash
ln -s $PWD/.zshrc $HOME/.zshrc
```
5. Symbolically link the `.p10k.zsh` file in this repo to your home directory
    - You must use the full path when creating the symbolic link
    - You can run the following from the this repo's directory to create the link
```bash
ln -s $PWD/.p10k.zsh $HOME/.p10k.zsh
```
6. Symbolically link the `p10k.mise.zsh` file in this repo to the `~/.config/shell` directory
    - You must use the full path when creating the symbolic link
    - If the `~/.config/shell` directory does not exist, create it first
    - You will need to install [`mise`](https://github.com/jdx/mise) for automatic tool management to work
    - You can run the following from the this repo's directory to create the link
```bash
mkdir -p $HOME/.config/shell
ln -s $PWD/p10k.mise.zsh $HOME/.config/shell/p10k.mise.zsh
```
6. Run `source ~/.zshrc` to apply the changes and watch the magic happen
