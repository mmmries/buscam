defmodule Buscam do
  @moduledoc """
  Grabs images from the picam and publishes them to a camweb channel
  """

  use GenServer

  def init(nil) do
    Picam.set_size(1350, 900)
    {:ok, nil, pause_time()}
  end

  def handle_info(:timeout, nil) do
    base64 = Picam.next_frame() |> Base.encode64()
    {:noreply, nil, pause_time()}
  end

  defp pause_time, do: Application.get_env(:buscam, :pause_time, 1000)
end
