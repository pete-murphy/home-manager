{
  config,
  pkgs,
  lib,
  ...
}: let
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
  });
in {
  imports = [
    nixvim.homeManagerModules.nixvim
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "peter.murphy";
  home.homeDirectory = "/Users/peter.murphy";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.alejandra
    pkgs.awscli2
    pkgs.bat
    pkgs.bore-cli
    pkgs.coreutils
    pkgs.delta
    pkgs.du-dust
    pkgs.eza
    pkgs.fd
    pkgs.ffmpeg
    pkgs.gh
    pkgs.gource
    pkgs.gron
    # pkgs.haskellPackages.ghcup
    pkgs.hyperfine
    pkgs.icu
    pkgs.imagemagick
    pkgs.inkscape-with-extensions
    pkgs.jq
    pkgs.nerdfonts
    pkgs.nix-prefetch-git
    pkgs.nixfmt
    pkgs.nodejs_20
    pkgs.powerline-fonts
    # pkgs.python2
    pkgs.ripgrep
    pkgs.rustup
    pkgs.sd
    pkgs.shellcheck
    pkgs.tokei
    pkgs.tree
    pkgs.visidata
    pkgs.youtube-dl
    pkgs.zoxide
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    history = {
      size = 500000;
      ignoreSpace = true;
      ignoreDups = true;
    };
    oh-my-zsh = {
      enable = true;
    };
    shellAliases = {
      ls = "exa";
    };
    initExtraBeforeCompInit = ''
      eval "$(zoxide init zsh)"
    '';
    initExtra = ''
      export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$HOME/.local/bin"
      export EDITOR=nvim
      autoload edit-command-line; zle -N edit-command-line
      bindkey '^e' edit-command-line

      runChrome () {
        /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222 >&/dev/null &
      }
    '';
  };

  programs.nixvim = {
    enable = true;

    viAlias = true;
    vimAlias = true;

    options = {
      shiftwidth = 4;
      scrolloff = 8;
      smartcase = true;
      expandtab = true;
    };

    globals = {
      mapleader = ","; # Sets the leader key to comma
    };

    plugins = {
      which-key.enable = true;
      commentary.enable = true;
      surround.enable = true;
      lualine.enable = true;
      fugitive.enable = true;
      telescope.enable = true;
      telescope.keymaps = {
        "<leader>fp" = "git_files"; # [f]ind in [p]roject;
        "<leader>fg" = "live_grep"; # [f]ind with [g]rep
        "<leader>ff" = "find_files"; # [f]ind [f]iles
        "<leader>fb" = "buffers"; # [f]ind [b]uffer
      };

      harpoon = {
        enable = true;
        keymaps = {
          addFile = "<leader>ha"; # [h]arpoon [a]dd
          toggleQuickMenu = "<leader>ht"; # [h]arpoon [t]abs
        };
      };

      lsp.enable = true;
    };

    extraPlugins = with pkgs.vimPlugins; [
      ReplaceWithRegister
      ctrlp-vim
      fzf-vim
      fzfWrapper
      vim-airline-themes
      vim-colorschemes
      vim-cool
      vim-markdown
      vim-nix
      vim-polyglot
    ];
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.tmux = {
    enable = true;
    escapeTime = 0;
    keyMode = "vi";
    historyLimit = 5000;
    shell = "${pkgs.zsh}/bin/zsh";
    extraConfig = let
      gpakosz-tmux = pkgs.fetchFromGitHub {
        owner = "gpakosz";
        repo = ".tmux";
        rev = "master";
        sha256 = "sha256-LkoRWds7PHsteJCDvsBpZ80zvlLtFenLU3CPAxdEHYA=";
      };
    in
      builtins.concatStringsSep "\n" [
        (builtins.readFile (gpakosz-tmux + "/.tmux.conf"))
        (builtins.readFile (gpakosz-tmux + "/.tmux.conf.local"))
        ''
          tmux_conf_theme_left_separator_main='\uE0B0'  # /!\ you don't need to install Powerline
          tmux_conf_theme_left_separator_sub='\uE0B1'   #   you only need fonts patched with
          tmux_conf_theme_right_separator_main='\uE0B2' #   Powerline symbols or the standalone
          tmux_conf_theme_right_separator_sub='\uE0B3'  #   PowerlineSymbols.otf font, see README.md
        ''
      ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "${pkgs.ripgrep}/bin/rg --files";
  };

  programs.git = {
    enable = true;
    userName = "Peter Murphy";
    userEmail = "26548438+pete-murphy@users.noreply.github.com";

    extraConfig = {
      # core.editor = "code --wait --reuse-window";
      core.editor = "vi";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };

    includes = [
      {
        condition = "gitdir:~/Well/";
        contents = {
          # userEmail = "18291327-peter.murphy1@users.noreply.gitlab.com";
          user.email = "peter.murphy@well.co";
        };
      }
    ];

    delta.enable = true;

    ignores = [
      "*~"
      ".*.swn"
      ".*.swp"
      ".*.swo"
    ];
  };

  programs.bash.enable = true;

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/peter.murphy/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "vi";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
