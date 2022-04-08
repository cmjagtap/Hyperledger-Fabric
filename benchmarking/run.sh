export CALIPER_BENCHCONFIG=benchmarks/scenario/simple/fabcar/config.yaml
export CALIPER_NETWORKCONFIG=networks/fabric/v2.1/network-config_2.1.yaml
  
caliper  launch manager  --caliper-fabric-gateway-enabled --calper-flow-only-test --caliper-fabric-gateway-discovery=false 

