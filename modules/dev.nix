# Development specific configurations
# Additions to common.nix
{
  pkgs,
  globals,
  ...
}: {
  environment = {
    sessionVariables = {
      LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
    };
  };

  virtualisation.docker.enable = true;

  users.users.${globals.username} = {
    extraGroups = ["docker"];
  };

  programs.zsh.ohMyZsh.plugins = ["docker"];

  home-manager.users.${globals.username} = {
    home.packages = with pkgs; [
      devbox
    ];
    programs = {
      chromium.extensions = [
        "fmkadmapgofadopljbjfkapdkoienihi" # React dev tools
      ];
      vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
        rust-lang.rust-analyzer
        ms-azuretools.vscode-docker
        esbenp.prettier-vscode
        dbaeumer.vscode-eslint
        golang.go
        tamasfe.even-better-toml
        waderyan.gitblame
        mhutchie.git-graph
        prisma.prisma
        redhat.vscode-yaml
        humao.rest-client
        # vscodevim.vim # If I someday have energy to learn Vim
      ];
    };
  };
}
