{
  description = "Example superbuild environment and controller with mc-panda and macos support";

  # 2. Tell mc-rtc-nix to use YOUR nix-ros-overlay PR instead of its default one
  inputs = {
    # 1. The PR with the macOS lttng fix
    #nix-ros-overlay.url = "github:lopsided98/nix-ros-overlay/pull/561/head";
    nix-ros-overlay.url = "github:arntanguy/nix-ros-overlay/fix_jazzy";
    # nix-ros-overlay.url = "path:/home/arnaud/devel/mc-rtc-nix/gepetto/nix-ros-overlay";

    # 2. Top-level flakoboros (forces it to use the PR)
    flakoboros = {
      url = "github:gepetto/flakoboros";
      inputs.nix-ros-overlay.follows = "nix-ros-overlay";
    };

    # 3. Top-level gazebros2nix (The missing link!)
    gazebros2nix = {
      url = "github:gepetto/gazebros2nix";
      inputs.flakoboros.follows = "flakoboros";
      inputs.nix-ros-overlay.follows = "nix-ros-overlay";
    };

    # 4. Top-level gepetto (forces it to use our modified gazebros2nix & flakoboros)
    gepetto = {
      url = "github:gepetto/nix";
      inputs.gazebros2nix.follows = "gazebros2nix";
      inputs.flakoboros.follows = "flakoboros";
      inputs.nix-ros-overlay.follows = "nix-ros-overlay";
    };

    # 5. Top-level mc-rtc-nix (forces it to use our modified gepetto)
    mc-rtc-nix = {
      url = "github:mc-rtc/nixpkgs";
      inputs.gepetto.follows = "gepetto";
      inputs.flakoboros.follows = "flakoboros";
    };

    flake-parts.follows = "mc-rtc-nix/flake-parts";
    systems.follows = "mc-rtc-nix/systems";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:
      {
        systems = import inputs.systems;
        imports = [
          inputs.mc-rtc-nix.flakeModule
          {
            # This mc-rtc-superbuild configuration will:
            # - Define named reusable configurations in `configurations`
            # - Use explicit runtime (Nix runtime components) vs devel (local/source overlays)
            # - Generate `${project.name}-<configuration>` and `${project.name}-<configuration>-devel` shells
            #
            # This will also generate a .superbuild/mc_rtc.yaml file containg the suitable mc_rtc configuration
            # Devel dependencies are expected to be installed manually in .superbuild/install
            #
            # As always, individual packages can be overridden using flakoboros
            mc-rtc-superbuild =
              { pkgs, ... }:
              {
                enable = true;
                project.pname = "";
                # TODO: replace this section with your own configuration presets for your project
                configurations = {
                  panda-controller-example-minimal = {
                    extends = [ "minimal" ];
                    runtime = {
                      robots = [
                        # pkgs.mc-panda-lirmm
                        pkgs.mc-panda
                      ];

                      apps = [
                        pkgs.mc-rtc-magnum
                      ];
                      config = "lib/mc_controller/etc/PandaControllerExample/mc_rtc.yaml";
                    };
                    devel = {
                      config = "lib64/mc_controller/etc/PandaControllerExample/mc_rtc.yaml";
                      controllers = [ pkgs.panda-controller-example ];
                    };
                  };
                  panda-controller-example-full = {
                    extends = [
                      "minimal"
                      "panda-controller-example-minimal"
                    ];
                    # FIXME: disable mc-franka, it does not build on macos
                    runtime = {
                      # FIXME can't access stdenv, lib here
                      # apps = lib.optionals (!stdenv.hostPlatform.isDarwin) [
                      #   pkgs.mc-franka
                      # ];
                    };
                  };
                };
              };

            flakoboros = {
              # # Override all dependencies
              # # They are locked in flake.lock to the latest commit available at the time
              # # To update to all inputs' latest commit, use
              # # nix flake update
              # overrideAttrs.your-repository = {
              #   src = inputs.your-repository;
              # };
              overrideAttrs.libfranka =
                { drv-prev, pkgs-final, ... }:
                {
                  meta.platforms = drv-prev.meta.platforms ++ pkgs-final.lib.platforms.darwin;
                };
              packages = {
                panda-controller-example =
                  {
                    stdenv,
                    lib,
                    cmake,
                    mc-rtc,
                    ...
                  }:
                  stdenv.mkDerivation {
                    name = "panda-controller-example";
                    src = lib.cleanSource ./.;
                    nativeBuildInputs = [ cmake ];
                    propagatedBuildInputs = [
                      mc-rtc
                    ];

                    cmakeFlags = [ ];

                    meta = with lib; {
                      description = "panda-controller-example";
                      homepage = "https://github.com/arntanguy/panda-controller-example";
                      license = licenses.bsd2;
                      platforms = platforms.all;
                    };
                  };
              };
            };
          }
        ];
      }
    );
}
