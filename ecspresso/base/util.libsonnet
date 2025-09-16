local const = import './const.libsonnet';

{
  mainContainerCPU(cpu, enableLokiLogging, enableOtelcolSidecar)::
    local cpu1 = if enableLokiLogging then cpu - const.fluentBitLokiResources.cpu else cpu;
    local cpu2 = if enableOtelcolSidecar then cpu1 - const.otelcolSidecarResources.cpu else cpu1;
    cpu2,
  mainContainerMemory(memory, enableLokiLogging, enableOtelcolSidecar)::
    local memory1 = if enableLokiLogging then memory - const.fluentBitLokiResources.memory else memory;
    local memory2 = if enableOtelcolSidecar then memory1 - const.otelcolSidecarResources.memory else memory1;
    memory2,
  mainContainerMemoryReservation(memoryReservation, enableLokiLogging, enableOtelcolSidecar)::
    local memoryReservation1 = if enableLokiLogging then memoryReservation - const.fluentBitLokiResources.memory else memoryReservation;
    local memoryReservation2 = if enableOtelcolSidecar then memoryReservation1 - const.otelcolSidecarResources.memory else memoryReservation1;
    memoryReservation2,
}
