{
  description = "Example superbuild environment and controller with mc-panda and macos support";

  inputs = {
    mc-rtc-nix.url = "github:mc-rtc/nixpkgs";
    flake-parts.follows = "mc-rtc-nix/flake-parts";
    systems.follows = "mc-rtc-nix/systems";

    # You can override dependencies from a commit/pull request by:
    # Adding it as input
    # your-repository.url = "github:username/repository/pull/ID/head";
    # your-repository.flake = true; # use false if the repository does not have a flake
  };

  nixConfig = {
    extra-substituters = [
      "https://mc-rtc-nix.cachix.org"
      "https://gepetto.cachix.org"
      "https://attic.iid.ciirc.cvut.cz/ros"
    ];
    extra-trusted-public-keys = [
      "mc-rtc-nix.cachix.org-1:5M3sLvHXJCep4wc1tQl7QuFWL2eH2I0jkuvWtqJDYQs="
      "gepetto.cachix.org-1:toswMl31VewC0jGkN6+gOelO2Yom0SOHzPwJMY2XiDY="
      "ros:JR95vUYsShSqfA1VTYoFt1Nz6uXasm5QrcOsGry9f6Q="
    ];
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
                      "default"
                      "panda-controller-example-minimal"
                    ];
                    runtime = {
                      apps = [
                        pkgs.mc-franka
                      ];
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
