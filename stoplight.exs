defmodule StoplightStateFunctions do
  @behaviour :gen_statem

  # Public API
  def start_link() do
    :gen_statem.start_link(__MODULE__, [], [])
  end

  def transition(stoplight_pid) do
    :gen_statem.call(stoplight_pid, :transition)
  end

  # API Callbacks
  def init(_) do
    {:ok, :green, 0}
  end

  def green({:call, from}, :transition, transitions) do
    {:next_state, :yellow, transitions + 1, [{:reply, from, {:yellow, transitions + 1}}]}
  end

  def yellow({:call, from}, :transition, transitions) do
    {:next_state, :red, transitions + 1, [{:reply, from, {:red, transitions + 1}}]}
  end

  def red({:call, from}, :transition, transitions) do
    {:next_state, :green, transitions + 1, [{:reply, from, {:green, transitions + 1}}]}
  end

  # :gen_statem callback
  def callback_mode(), do: :state_functions
end

defmodule StoplightHandleEventFunction do
  @behaviour :gen_statem

  # Public API
  def start_link() do
    :gen_statem.start_link(__MODULE__, [], [])
  end

  def transition(stoplight_pid) do
    :gen_statem.call(stoplight_pid, :transition)
  end

  # API Callbacks
  def init(_) do
    {:ok, :green, 0}
  end

  def handle_event({:call, from}, :transition, :green, transitions) do
    {:next_state, :yellow, transitions + 1, [{:reply, from, {:yellow, transitions + 1}}]}
  end

  def handle_event({:call, from}, :transition, :yellow, transitions) do
    {:next_state, :red, transitions + 1, [{:reply, from, {:red, transitions + 1}}]}
  end

  def handle_event({:call, from}, :transition, :red, transitions) do
    {:next_state, :green, transitions + 1, [{:reply, from, {:green, transitions + 1}}]}
  end

  # :gen_statem callback
  def callback_mode(), do: :handle_event_function
end

{:ok, state_pid} = StoplightStateFunctions.start_link()
{:ok, handle_event_pid} = StoplightHandleEventFunction.start_link()

Benchee.run(%{
  :state_functions => fn -> StoplightStateFunctions.transition(state_pid) end,
  :handle_event_functions => fn -> StoplightHandleEventFunction.transition(handle_event_pid) end
}, time: 60)