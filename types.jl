module Types

abstract type State end
abstract type Action end

struct Location
    x::Int64
    y::Int64
end

struct GridWorldAction <: Action
    action
end

struct GridWorldState <: State
   location::Location
   goal::Location
   width::Int64
   height::Int64
end

function legal_state(bundle)
    state = bundle[1]
    return state.location.x <= state.width &&
    state.location.y <= state.height &&
    state.location.x > 0 && state.location.y > 0
end

function is_goal(state::GridWorldState)
    return state.location.x == state.goal.x && state.location.y == state.goal.y
end

function expand(state::GridWorldState)
    successors = []
    move1 = Location(state.location.x + 1, state.location.y)
    move2 = Location(state.location.x, state.location.y + 1)
    move3 = Location(state.location.x - 1, state.location.y)
    move4 = Location(state.location.x, state.location.y - 1)
    push!(successors, (GridWorldState(move1, state.goal, state.width, state.height), GridWorldAction('E')))
    push!(successors, (GridWorldState(move2, state.goal, state.width, state.height), GridWorldAction('S')))
    push!(successors, (GridWorldState(move3, state.goal, state.width, state.height), GridWorldAction('N')))
    push!(successors, (GridWorldState(move4, state.goal, state.width, state.height), GridWorldAction('W')))
    filter!(legal_state, successors)
    return successors
end

function heuristic(state::GridWorldState)::Float64
    return abs(state.location.x - state.goal.x) + 
    abs(state.location.y - state.goal.y) 
end

struct Node
    state::State
    heuristic::Float64 
    action::Action
    parent::Union{Missing, Node}
end

function heuristic(node::Node)::Float64
    return heuristic(node.state)
end

import Base.isless
function isless(a::Node, b::Node)
    return a.heuristic < b.heuristic
end
    
end
