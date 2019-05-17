My dotfiles.  
And my cross-system shell setup really.

## Installing

### Ubuntu and bash on Ubuntu on Windows
1. Install "Bash on Ubuntu on Windows"
2. Install needed dependencies
    ```shell
    sudo apt-get get install --yes --no-install-recommends \
        git \
        ruby \
        ruby-dev
    ```
3. Install the `config_curator` gem
    ```shell
    sudo gem install config_curator
4. Clone this repo in the `~/dotfiles` folder
    ```shell
    git clone https://github.com/lucatume/dotfiles.git dotfiles
5. Change directory to `dotfiles` and run Config Curator
    ```shell
    (cd dotfiles; curate -v)
6. From the home folder run the setup script
    ```shell
    sh ./setup-my-shell.sh && rm setup-my-shell.sh
7. Advanced zsh themes *might* require a Powerline font; install [Adobe Source Code Pro](https://github.com/powerline/fonts/blob/master/SourceCodePro/Source%20Code%20Pro%20Medium%20for%20Powerline.otf) if needed

### MacOs

1. Install [Homebrew](https://brew.sh/)
    ```shell
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

2. Install `ruby` using Homebrew
    ```shell
    brew install ruby
3. Install the `config_curator` gem using Homebrew provided `gem` bin
    ```shell
    export PATH=$(brew --prefix ruby)/bin:$PATH \
    && gem install config_curator
4. Clone this repo in the `~/dotfiles` folder
    ```shell
    git clone https://github.com/lucatume/dotfiles.git dotfiles
5. Change directory to `dotfiles` and run Config Curator
    ```shell
    (cd dotfiles; curate -v)
6. From the home folder run the setup script
    ```shell
    sh ./setup-my-shell.sh && rm setup-my-shell.sh
7. Depending on the machine either install [Docker for Mac](https://docs.docker.com/docker-for-mac/install/) or use [Docker Toolbox](https://docs.docker.com/toolbox/overview)
8. Advanced zsh themes *might* require a Powerline font; install [Adobe Source Code Pro](https://github.com/powerline/fonts/blob/master/SourceCodePro/Source%20Code%20Pro%20Medium%20for%20Powerline.otf) if needed

### Usefule one-liners

Portable .vimrc file:
```bash
curl https://raw.githubusercontent.com/lucatume/dotfiles/master/portable-vimrc > ~/.vimrc
```


## References
* [Github does dotfiles](https://dotfiles.github.io/)
* [Config Curator](https://github.com/razor-x/config_curator)


