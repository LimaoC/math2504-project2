"""
A discrete event simulation engine for Open Generalized Jackson Networks.
"""
module GeneralizedJacksonSim

using Parameters
using Accessors
using LinearAlgebra
using Random

include("network_parameters.jl")
include("state.jl")
include("event.jl")

export NetworkParameters, compute_ρ

"""
Runs a discrete event simulation of an Open Generalized Jackson Network `net`.

The simulation runs from time `0` to `max_time`.

Statistics about the total mean queue lengths are recorded from `warm_up_time` onwards
and the estimated value is returned.

This simulation does NOT keep individual customers' state, it only keeps the state which is
the number of items in each of the nodes.
"""
function sim_net(net::NetworkParameters; max_time = 10^6, warm_up_time = 10^4,
                 seed::Int64 = 42)::Float64
    Random.seed!(seed)

    # create priority queue and add standard events; initial event is an external arrival
    # at the first server
    priority_queue = BinaryMinHeap{TimedEvent}()
    push!(priority_queue, TimedEvent(ExternalArrivalEvent(), 0.0))
    push!(priority_queue, TimedEvent(EndSimEvent(), max_time))

    state = QueueNetworkState(zeros(Int64, net.L), L, net)
    time = 0.0

    # simulation loop
    while true
        timed_event = pop!(priority_queue)
        time = timed_event.time
        new_timed_events = process_event(time, state, timed_event)

        isa(timed_event.event, EndSimEvent) && break

        for nte in new_timed_events
            push!(priority_queue, nte)
        end
    end
end

end
