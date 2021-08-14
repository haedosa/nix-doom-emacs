{ self, ... }@inputs : final: prev: with final; {

  mk-doom-emacs = { extraPackages ? epkgs: []
                  , emacsPackage ? emacs
                  , doomPrivateDir ? ./doom.d
                  , extraConfig ? ""
                  , emacsPackagesOverlay ? self: super: { }
                  }: callPackage self {
    emacsPackages = emacsPackagesFor emacsPackage;
    inherit extraPackages doomPrivateDir extraConfig emacsPackagesOverlay;
    dependencyOverrides = inputs;
  };

  doom-emacs = mk-doom-emacs {

    extraPackages = epkgs: [ epkgs.evil-plugins ];

    emacsPackagesOverlay = (esuper: eself: {

    # *** evil-plugins
      evil-plugins = esuper.trivialBuild {
        pname = "evil-plugins";
        src = fetchFromGitHub {
          owner = "tarao";
          repo = "evil-plugins";
          rev = "d9094d238756300ac4ca1050d6a71d302e120ca1";
          sha256 = "03inaswz46p66f0f6j82x0hgr9jxcn41kyjf8qxrx97smijlb39w";
          # date 2015-04-06T21:33:10+09:00                                        |
        };
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          LISPDIR=$out/share/emacs/site-lisp
          install -d $LISPDIR
          install *.el *.elc $LISPDIR
        '';
      };

    });
  };

}
