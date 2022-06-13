{
  description = "nix-doom-emacs home-manager module";

  inputs = {
    doom-emacs.url = "github:hlissner/doom-emacs/develop";
    doom-emacs.flake = false;
    doom-snippets.url = "github:hlissner/doom-snippets";
    doom-snippets.flake = false;
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.flake = false;
    emacs-so-long.url = "github:hlissner/emacs-so-long";
    emacs-so-long.flake = false;
    evil-markdown.url = "github:Somelauw/evil-markdown";
    evil-markdown.flake = false;
    evil-org-mode.url = "github:hlissner/evil-org-mode";
    evil-org-mode.flake = false;
    evil-quick-diff.url = "github:rgrinberg/evil-quick-diff";
    evil-quick-diff.flake = false;
    explain-pause-mode.url = "github:lastquestion/explain-pause-mode";
    explain-pause-mode.flake = false;
    nix-straight.url = "github:vlaci/nix-straight.el";
    nix-straight.flake = false;
    nose.url= "github:emacsattic/nose";
    nose.flake = false;
    ob-racket.url = "github:xchrishawk/ob-racket";
    ob-racket.flake = false;
    org-mode.url = "github:emacs-straight/org-mode";
    org-mode.flake = false;
    org-yt.url = "github:TobiasZawada/org-yt";
    org-yt.flake = false;
    php-extras.url = "github:arnested/php-extras";
    php-extras.flake = false;
    revealjs.url = "github:hakimel/reveal.js";
    revealjs.flake = false;
    rotate-text.url = "github:debug-ito/rotate-text.el";
    rotate-text.flake = false;

    # extraPackages
    evil-plugins.url = "github:tarao/evil-plugins";
    evil-plugins.flake = false;

    git-modes.url = "github:magit/git-modes";
    git-modes.flake = false;

    straight.url = "github:radian-software/straight.el";
    straight.flake = false;

    haedosa.url = "github:haedosa/flakes/22.05";
    nixpkgs.follows = "haedosa/nixpkgs";
    flake-utils.follows = "haedosa/flake-utils";
    # nixpkgs.url = "github:nixos/nixpkgs";
    # flake-utils.url = "github:numtide/flake-utils/master";

  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    let
      inherit (flake-utils.lib) eachDefaultSystem eachSystem;
    in
    eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlay ];
          };
        in
        with pkgs; {
          defaultPackage = doom-emacs;
          devShell = mkShell { buildInputs = [ (python3.withPackages (ps: with ps; [ PyGithub ])) ]; };
        }) //
    eachSystem [ "x86_64-linux" ]
      (system: {
        checks = {
          init-example-el = nixpkgs.legacyPackages.${system}.callPackage ./. { doomPrivateDir = ./test/doom.d; dependencyOverrides = inputs; };
        };
      }) //
    {
      hmModule = import ./modules/home-manager.nix inputs;
      overlay = import ./overlay.nix inputs;
    };
}
