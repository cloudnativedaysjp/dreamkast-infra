local const = import './const.libsonnet';

{
  mainContainerCPU(cpu, enableLokiLogging, enableMackerelSidecar)::
    local cpu1 = if enableLokiLogging then cpu - const.fluentBitLokiResources.cpu else cpu;
    local cpu2 = if enableMackerelSidecar then cpu1 - const.mackerelSidecarResources.cpu else cpu1;
    cpu2,
  mainContainerMemory(memory, enableLokiLogging, enableMackerelSidecar)::
    local memory1 = if enableLokiLogging then memory - const.fluentBitLokiResources.memory else memory;
    local memory2 = if enableMackerelSidecar then memory1 - const.mackerelSidecarResources.memory else memory1;
    memory2,
  mainContainerMemoryReservation(memoryReservation, enableLokiLogging, enableMackerelSidecar)::
    local memoryReservation1 = if enableLokiLogging then memoryReservation - const.fluentBitLokiResources.memory else memoryReservation;
    local memoryReservation2 = if enableMackerelSidecar then memoryReservation1 - const.mackerelSidecarResources.memory else memoryReservation1;
    memoryReservation2,
}
