defmodule Hangman.Application do

  use Application

  def init() do

  end

  def start(_type, _args) do

    import Supervisor.Spec

    children = [
      worker(Hangman.Server, [])
    ]

    options = [
      name: Hangman.Supervisor,
      strategy: :simple_one_for_one,
    ]

    Supervisor.start_link(children, options)
  end

end
