# GenStatemStoplights

I wanted to see if there is a performance difference between the `:gen_statem`
callback modes of `:state_functions` and `:handle_event_function`.

I created two simple, nearly-identical modules implementing the `:gen_statem`
behaviour, modeling a stoplight as an FSM. Each FSM has only three states:
`:green`, `:yellow`, and `:red`. Additionally, each FSM has only a single event,
`transition`, which changes the state from `:green` to `:yellow`, `:yellow` to
`:red`, and `:red` to `:green`.

To run, retrieve the dependencies via `mix deps.get`, then run the test script
with:

`mix run stoplight.exs`
