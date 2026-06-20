# PandaControllerExample

This repository contains a simple mc_rtc controller with Franka Emika robot

## Setup
### Running with Nix

```bash
# if cachix is setup correctly this should just pull binary dependencies. Otherwise
# it will build everything specified in the `mc-rtc-superbuild` derivation (and their depencencies)
nix develop .#panda-controller-example-full
# Run the gui in the background
(mc-rtc-magnum &)
# By default mc_rtc_ticker will use the configuration provided by `MC_RTC_CONTROLLER_CONFIG` env variable. This is set by the mc-rtc-superbuild derivation and devShell to contain all needed runtime depencencies and optionally a default controller's configuration
mc_rtc_ticker
```

### Developping with Nix

To get a development environment where you can work on the controller and build it locally:

```bash
# if cachix is setup correctly this should just pull binary dependencies. Otherwise
# it will build everything specified in the `mc-rtc-superbuild` derivation (and their depencencies)
nix develop .#panda-controller-example-full-devel
cmake -B build $cmakeFlags -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR -G Ninja
cmake --build build --target install
# Run the gui in the background
(mc-rtc-magnum &)
# By default mc_rtc_ticker will use the configuration provided by `MC_RTC_CONTROLLER_CONFIG` env variable. This is set by the mc-rtc-superbuild derivation and devShell to contain all needed runtime depencencies and optionally a default controller's configuration
mc_rtc_ticker
```
