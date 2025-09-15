{
  config,
  pkgs,
  lib,
  nixpkgs,
  system,
  ...
}: let
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
  });
  unstable = import <unstable> {};
  health-engine-development-tools =
    (import (builtins.fetchGit {
      url = "git+ssh://git@gitlab.com/welllabs/health-engine/development-tools.git";
      ref = "main";
      shallow = true;
    }) {}).health-engine-development-tools;
  # elm-nixpkgs-src = builtins.fetchGit {
  #   url = "https://github.com/NixOS/nixpkgs";
  #   rev = "7e2fb8e0eb807e139d42b05bf8e28da122396bed";
  # };
  pkgs-2405 = import <nixpkgs-2405> {};
in {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
  # imports = [
  #   nixvim.homeManagerModules.nixvim
  # ];
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
    health-engine-development-tools
    # pkgs.texlive.combined.scheme-full
    pkgs.caddy
    # unstable.elmPackages.elm
    # unstable.elmPackages.elm-format
    # unstable.elmPackages.elm-json
    # unstable.elmPackages.elm-land
    # unstable.elmPackages.elm-language-server
    # unstable.elmPackages.elm-live
    # unstable.elmPackages.elm-review
    # unstable.elmPackages.elm-test
    # pkgs.elmPackages.elm
    # unstable.elmPackages.elm-format
    # pkgs.elmPackages.elm-json
    # pkgs.elmPackages.elm-land
    # pkgs.elmPackages.elm-language-server
    # pkgs.elmPackages.elm-live
    # pkgs.elmPackages.elm-review
    # pkgs.elmPackages.elm-test
    pkgs-2405.elmPackages.elm
    pkgs-2405.elmPackages.elm-format
    pkgs-2405.elmPackages.elm-json
    pkgs-2405.elmPackages.elm-test
    pkgs-2405.elmPackages.elm-language-server
    pkgs-2405.elm2nix

    # pkgs.nerd-fonts.fira-code
    pkgs.alejandra
    # pkgs.android-studio
    pkgs.awscli2
    pkgs.bat
    pkgs.bore-cli
    pkgs.bun
    pkgs.coreutils
    pkgs.delta
    pkgs.du-dust
    pkgs.eza
    pkgs.fd
    pkgs.ffmpeg
    pkgs.gh
    pkgs.gitlab-runner
    pkgs.gource
    pkgs.gron
    # pkgs.haskellPackages.ghcup
    pkgs.hyperfine
    pkgs.icu
    pkgs.imagemagick
    pkgs.inkscape-with-extensions
    pkgs.jnv
    pkgs.jq
    pkgs.just
    pkgs.llm
    # pkgs.nerd-fonts.fira-code
    # (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DejaVuSansMono" ]; })
    pkgs.nix-prefetch-git
    pkgs.nixfmt
    pkgs.nodejs_24
    pkgs.pandoc
    pkgs.pnpm
    pkgs.postgresql
    pkgs.powerline-fonts
    pkgs.ripgrep
    pkgs.rustup
    pkgs.sd
    pkgs.shellcheck
    pkgs.tokei
    pkgs.tree
    pkgs.typescript
    # pkgs.unison-ucm
    pkgs.visidata
    pkgs.xan
    pkgs.yarn
    pkgs.yt-dlp
    pkgs.yq
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

  programs.neovim = {
    enable = true;
    # defaultEditor = true;
    viAlias = true;
    vimAlias = true;
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
    # TODO: stopped working
    # zsh-abbr = {
    #   enable = true;
    #   abbreviations = {
    #     ".j" = "just --justfile $HOME/.user.justfile --working-directory .";
    #   };
    # };
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

      jj() {
        just --justfile $HOME/.just/justfile --working-directory . "$@"
      }
    '';
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
  };

  # programs.nixvim = {
  #   enable = true;

  #   viAlias = true;
  #   vimAlias = true;

  #   options = {
  #     shiftwidth = 4;
  #     scrolloff = 8;
  #     smartcase = true;
  #     expandtab = true;
  #   };

  #   globals = {
  #     mapleader = ","; # Sets the leader key to comma
  #   };

  #   plugins = {
  #     which-key.enable = true;
  #     commentary.enable = true;
  #     surround.enable = true;
  #     lualine.enable = true;
  #     fugitive.enable = true;
  #     telescope.enable = true;
  #     telescope.keymaps = {
  #       "<leader>fp" = "git_files"; # [f]ind in [p]roject;
  #       "<leader>fg" = "live_grep"; # [f]ind with [g]rep
  #       "<leader>ff" = "find_files"; # [f]ind [f]iles
  #       "<leader>fb" = "buffers"; # [f]ind [b]uffer
  #     };

  #     harpoon = {
  #       enable = true;
  #       keymaps = {
  #         addFile = "<leader>ha"; # [h]arpoon [a]dd
  #         toggleQuickMenu = "<leader>ht"; # [h]arpoon [t]abs
  #       };
  #     };

  #     lsp.enable = true;
  #   };

  #   extraPlugins = with pkgs.vimPlugins; [
  #     ReplaceWithRegister
  #     ctrlp-vim
  #     fzf-vim
  #     fzfWrapper
  #     vim-airline-themes
  #     vim-colorschemes
  #     vim-cool
  #     vim-markdown
  #     vim-nix
  #     vim-polyglot
  #   ];
  # };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      simplified_ui = true;
      pane_frames = false;
      theme = "flexoki-dark";
      themes = {
        flexoki-light = {
          text_unselected = {
            base = [28 27 26];
            background = [255 252 240];
            emphasis_0 = [218 112 44];
            emphasis_1 = [36 131 123];
            emphasis_2 = [102 128 11];
            emphasis_3 = [206 93 151];
          };
          text_selected = {
            base = [28 27 26];
            background = [206 205 195];
            emphasis_0 = [218 112 44];
            emphasis_1 = [36 131 123];
            emphasis_2 = [102 128 11];
            emphasis_3 = [206 93 151];
          };
          ribbon_selected = {
            base = [255 252 240];
            background = [102 128 11];
            emphasis_0 = [209 77 65];
            emphasis_1 = [218 112 44];
            emphasis_2 = [160 47 111];
            emphasis_3 = [58 169 159];
          };
          ribbon_unselected = {
            base = [87 86 83];
            background = [230 228 217];
            emphasis_0 = [218 112 44];
            emphasis_1 = [183 181 172];
            emphasis_2 = [102 128 11];
            emphasis_3 = [206 93 151];
          };
          table_title = {
            base = [102 128 11];
            background = [52 51 49];
            emphasis_0 = [218 112 44];
            emphasis_1 = [36 131 123];
            emphasis_2 = [102 128 11];
            emphasis_3 = [206 93 151];
          };
          table_cell_selected = {
            base = [28 27 26];
            background = [206 205 195];
            emphasis_0 = [218 112 44];
            emphasis_1 = [36 131 123];
            emphasis_2 = [102 128 11];
            emphasis_3 = [206 93 151];
          };
          table_cell_unselected = {
            base = [28 27 26];
            background = [255 252 240];
            emphasis_0 = [218 112 44];
            emphasis_1 = [36 131 123];
            emphasis_2 = [102 128 11];
            emphasis_3 = [206 93 151];
          };
          list_selected = {
            base = [28 27 26];
            background = [206 205 195];
            emphasis_0 = [175 48 41];
            emphasis_1 = [188 82 21];
            emphasis_2 = [36 131 123];
            emphasis_3 = [160 47 111];
          };
          list_unselected = {
            base = [28 27 26];
            background = [255 252 240];
            emphasis_0 = [175 48 41];
            emphasis_1 = [188 82 21];
            emphasis_2 = [36 131 123];
            emphasis_3 = [160 47 111];
          };
          frame_selected = {
            base = [102 128 11];
            background = [255 252 240];
            emphasis_0 = [175 48 41];
            emphasis_1 = [188 82 21];
            emphasis_2 = [36 131 123];
            emphasis_3 = [0 0 0];
          };
          frame_highlight = {
            base = [188 82 21];
            background = [255 252 240];
            emphasis_0 = [175 48 41];
            emphasis_1 = [160 47 111];
            emphasis_2 = [36 131 123];
            emphasis_3 = [32 94 166];
          };
          frame_unselected = {
            base = [183 181 172];
            background = [0];
            emphasis_0 = [239 159 118];
            emphasis_1 = [153 209 219];
            emphasis_2 = [244 184 228];
            emphasis_3 = [0];
          };
          exit_code_success = {
            base = [102 128 11];
            background = [255 252 240];
            emphasis_0 = [36 131 123];
            emphasis_1 = [255 252 240];
            emphasis_2 = [160 47 111];
            emphasis_3 = [32 94 166];
          };
          exit_code_error = {
            base = [175 48 41];
            background = [255 252 240];
            emphasis_0 = [188 82 21];
            emphasis_1 = [0 0 0];
            emphasis_2 = [0 0 0];
            emphasis_3 = [0 0 0];
          };
          multiplayer_user_colors = {
            player_1 = [160 47 111];
            player_2 = [32 94 166];
            player_3 = [36 131 123];
            player_4 = [188 82 21];
            player_5 = [102 128 11];
            player_6 = [94 64 157];
            player_7 = [175 48 41];
            player_8 = [173 131 1];
            player_9 = [0 0 0];
            player_10 = [0 0 0];
          };
        };
        flexoki-dark = {
          text_unselected = {
            base = [206 205 195];
            background = [28 27 26];
            emphasis_0 = [218 112 44];
            emphasis_1 = [58 169 159];
            emphasis_2 = [135 154 57];
            emphasis_3 = [206 93 151];
          };
          text_selected = {
            base = [255 252 240];
            background = [52 51 49];
            emphasis_0 = [218 112 44];
            emphasis_1 = [58 169 159];
            emphasis_2 = [135 154 57];
            emphasis_3 = [206 93 151];
          };
          ribbon_selected = {
            base = [28 27 26];
            background = [135 154 57];
            emphasis_0 = [175 48 41];
            emphasis_1 = [32 94 166];
            emphasis_2 = [160 47 111];
            emphasis_3 = [16 15 15];
          };
          ribbon_unselected = {
            base = [183 181 172];
            background = [52 51 49];
            emphasis_0 = [218 112 44];
            emphasis_1 = [87 86 83];
            emphasis_2 = [67 133 190];
            emphasis_3 = [206 93 151];
          };
          table_title = {
            base = [135 154 57];
            background = [64 62 60];
            emphasis_0 = [218 112 44];
            emphasis_1 = [58 169 159];
            emphasis_2 = [135 154 57];
            emphasis_3 = [206 93 151];
          };
          table_cell_selected = {
            base = [255 252 240];
            background = [52 51 49];
            emphasis_0 = [218 112 44];
            emphasis_1 = [58 169 159];
            emphasis_2 = [135 154 57];
            emphasis_3 = [206 93 151];
          };
          table_cell_unselected = {
            base = [206 205 195];
            background = [28 27 26];
            emphasis_0 = [218 112 44];
            emphasis_1 = [58 169 159];
            emphasis_2 = [135 154 57];
            emphasis_3 = [206 93 151];
          };
          list_selected = {
            base = [255 252 240];
            background = [52 51 49];
            emphasis_0 = [218 112 44];
            emphasis_1 = [58 169 159];
            emphasis_2 = [135 154 57];
            emphasis_3 = [206 93 151];
          };
          list_unselected = {
            base = [206 205 195];
            background = [28 27 26];
            emphasis_0 = [218 112 44];
            emphasis_1 = [58 169 159];
            emphasis_2 = [135 154 57];
            emphasis_3 = [206 93 151];
          };
          frame_selected = {
            base = [135 154 57];
            background = [28 27 26];
            emphasis_0 = [218 112 44];
            emphasis_1 = [173 131 1];
            emphasis_2 = [58 169 159];
            emphasis_3 = [0 0 0];
          };
          frame_unselected = {
            base = [87 86 83];
            background = [28 27 26];
            emphasis_0 = [209 77 65];
            emphasis_1 = [218 112 44];
            emphasis_2 = [58 169 159];
            emphasis_3 = [206 93 151];
          };
          frame_highlight = {
            base = [218 112 44];
            background = [28 27 26];
            emphasis_0 = [206 93 151];
            emphasis_1 = [218 112 44];
            emphasis_2 = [58 169 159];
            emphasis_3 = [67 133 190];
          };
          exit_code_success = {
            base = [135 154 57];
            background = [28 27 26];
            emphasis_0 = [58 169 159];
            emphasis_1 = [28 27 26];
            emphasis_2 = [206 93 151];
            emphasis_3 = [67 133 190];
          };
          exit_code_error = {
            base = [209 77 65];
            background = [28 27 26];
            emphasis_0 = [218 112 44];
            emphasis_1 = [0 0 0];
            emphasis_2 = [0 0 0];
            emphasis_3 = [0 0 0];
          };
          multiplayer_user_colors = {
            player_1 = [206 93 151];
            player_2 = [67 133 190];
            player_3 = [58 169 159];
            player_4 = [218 112 44];
            player_5 = [135 154 57];
            player_6 = [139 126 200];
            player_7 = [209 77 65];
            player_8 = [208 162 21];
            player_9 = [0 0 0];
            player_10 = [0 0 0];
          };
        };
      };
    };
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };

  # programs.tmux = {
  #   enable = true;
  #   escapeTime = 0;
  #   keyMode = "vi";
  #   historyLimit = 5000;
  #   shell = "${pkgs.zsh}/bin/zsh";
  #   extraConfig = let
  #     gpakosz-tmux = pkgs.fetchFromGitHub {
  #       owner = "gpakosz";
  #       repo = ".tmux";
  #       rev = "master";
  #       sha256 = "sha256-+7tg3qV+TdeF5Vfgf1GazZcFaO7OVsJ/Vul8fDVDNng=";
  #     };
  #   in
  #     builtins.concatStringsSep "\n" [
  #       (builtins.readFile (gpakosz-tmux + "/.tmux.conf"))
  #       (builtins.readFile (gpakosz-tmux + "/.tmux.conf.local"))
  #       ''
  #         tmux_conf_theme_left_separator_main='\uE0B0'  # /!\ you don't need to install Powerline
  #         tmux_conf_theme_left_separator_sub='\uE0B1'   #   you only need fonts patched with
  #         tmux_conf_theme_right_separator_main='\uE0B2' #   Powerline symbols or the standalone
  #         tmux_conf_theme_right_separator_sub='\uE0B3'  #   PowerlineSymbols.otf font, see README.md
  #       ''
  #     ];
  # };

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
      "*.ignore.*"
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
