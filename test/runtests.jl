using MetacommunityDynamics
using Test

test_list = [
"./parameter_tests.jl",
  "./landscapes/landscape_generator_tests.jl",
  "./landscapes/dispersal_potential_tests.jl",
  "./dynamics/constructor_tests.jl",
  "./dynamics/simulation_tests.jl"
]

global test_n
global error_bit
test_n = 1
error_bit = false

for this_test in test_list
  try
    include(this_test)
    println("[TEST $(lpad(test_n,2))] \033[1m\033[32mPASS\033[0m $(this_test)")
  catch e
    global error_bit = true
    println("[TEST $(lpad(test_n,2))] \033[1m\033[31mFAIL\033[0m $(this_test)")
    showerror(stdout, e, backtrace())
    println()
    throw("TEST FAILED")
  end
  global test_n += 1
end

if error_bit
  throw("Tests failed")
end
