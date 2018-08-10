include("./types.jl")

using DataStructures
using BenchmarkTools

input = "@_____\n______\n______\n______\n_____*"
open("world.input", "w") do io
    write(io, input)
end

function parse_input_world(input_file)::Main.Types.GridWorldState
    return Main.Types.GridWorldState(Main.Types.Location(1, 1),
                                     Main.Types.Location(1000, 1000), 1000, 1000)
    x_loc = 1
    y_loc = 1
    agent_loc = Main.Types.Location(x_loc, y_loc)
    goal_loc = Main.Types.Location(x_loc, y_loc)
    lines = readlines(input_file)
    for line in lines
        x_loc = 1
        for c in line
            if c == '@'
                agent_loc = Main.Types.Location(x_loc, y_loc)
            elseif c == '*'
                goal_loc = Main.Types.Location(x_loc, y_loc)
            end
            x_loc += 1
        end
        y_loc += 1
    end
    return Main.Types.GridWorldState(agent_loc, goal_loc, x_loc - 1, y_loc - 1)
end

function greedy_search()
    q = PriorityQueue()
    initial_state = parse_input_world("world.input")
    h = Main.Types.heuristic(initial_state)
    initial_node = Main.Types.Node(initial_state, h, Main.Types.GridWorldAction('!'), missing)
    q[initial_node] = initial_node
    top = dequeue!(q)
    while true
        if Main.Types.is_goal(top.state)
            break
        end
        successors = Main.Types.expand(top.state)
        for bundle in successors
            successor = bundle[1]
            action = bundle[2]
            h = Main.Types.heuristic(successor)
            node = Main.Types.Node(successor, h, action, top)
            q[node] = node
        end
        top = dequeue!(q)
    end
end

@btime greedy_search()

