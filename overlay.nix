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

  doom-emacs = mk-doom-emacs {};

}
