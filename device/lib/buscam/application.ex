defmodule Buscam.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @target Mix.target()

  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Buscam.Supervisor, max_restarts: 100, max_seconds: 1]
    Supervisor.start_link(children(@target), opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      Picam.FakeCamera,
      Buscam
    ]
  end

  def children(_target) do
    [
      Picam.Camera,
      Buscam
    ]
  end
end
