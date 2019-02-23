defmodule Buscam do
  @moduledoc """
  Grabs images from the picam and publishes them to a camweb channel
  """

  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, nil, opts)
  end

  def init(nil) do
    Picam.set_size(1280, 720)
    {:ok, nil, pause_time()}
  end

  def handle_info(:timeout, nil) do
    base64 = Picam.next_frame() |> Base.encode64()
    timestamp = DateTime.utc_now() |> DateTime.to_unix(:millisecond)
    CamwebWeb.Endpoint.broadcast("cam:pictures", "picture", %{
      "base64" => base64,
      "timestamp" => timestamp
    })
    {:noreply, nil, pause_time()}
  end

  defp pause_time, do: Application.get_env(:buscam, :pause_time, 1000)
end
