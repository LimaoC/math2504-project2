using Pkg
Pkg.activate(".")

using Accessors, LinearAlgebra, Plots, Random
include("../src/GeneralizedJacksonSim.jl")
using .GeneralizedJacksonSim

include("scenarios.jl")
include("task3_test1.jl")
include("task3_test2.jl")

scenarios = [scenario1, scenario2, scenario3, scenario4]

task3_test1(scenarios, verbose=false, multithreaded=false)
task3_test2(scenarios)
