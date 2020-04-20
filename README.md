# zsh in a box

### Steps to Success
1. Install zsh and on-my-zsh
```
$ sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
2. Install external plugins
```bash
# autoswitch_virtualenv
git clone "https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv.git" "$ZSH_CUSTOM/plugins/autoswitch_virtualenv"
# autoupdate
git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins $ZSH_CUSTOM/plugins/autoupdate
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# zsh-nvm
git clone https://github.com/lukechilds/zsh-nvm ~/.oh-my-zsh/custom/plugins/zsh-nvm
# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
```
2. Clone this repo
3. `cd` into it
4. Run these commands
```bash
# 1.Link the .zshrc file
ln -s $PWD/.zshrc /Users/$USER/.zshrc
# 2. Link the powerlevel10k file
ln -s $PWD/.p10k.zsh /Users/$USER/.p10k.zsh
# 3. Source the .zshrc file and follow any instructions
source ~/.zshrc
```
