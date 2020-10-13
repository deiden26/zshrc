# zsh in a box

### Steps to Success
1. Install zsh if it isn't already installed in your terminal
    - Run `echo $SHELL` to confirm zsh is installed and set as the default shell
    - The expect result is `/usr/bin/zsh` or somethign similar
2. Clone this repository wherever you like
3. Remove the `.zshrc` file in your home directory, if there is one
4. Symbolically link the `.zshrc` file in this repo to your home directory
    - You must use the full path when creating the symbolic link
    - You can run the following from the this repo's directory to create the link
```bash
ln -s $PWD/.zshrc $HOME/.zshrc
```
5. Restart your terminal and watch the magic happen
