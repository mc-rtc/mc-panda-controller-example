#include "PandaControllerExample_Initial.h"

#include "../PandaControllerExample.h"

void PandaControllerExample_Initial::configure(const mc_rtc::Configuration & config)
{
}

void PandaControllerExample_Initial::start(mc_control::fsm::Controller & ctl_)
{
  auto & ctl = static_cast<PandaControllerExample &>(ctl_);
}

bool PandaControllerExample_Initial::run(mc_control::fsm::Controller & ctl_)
{
  auto & ctl = static_cast<PandaControllerExample &>(ctl_);
  output("OK");
  return true;
}

void PandaControllerExample_Initial::teardown(mc_control::fsm::Controller & ctl_)
{
  auto & ctl = static_cast<PandaControllerExample &>(ctl_);
}

EXPORT_SINGLE_STATE("PandaControllerExample_Initial", PandaControllerExample_Initial)
