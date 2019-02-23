defmodule CamwebWeb.PicturesChannel do
  use Phoenix.Channel

  def join("cam:pictures", _message, socket) do
    {:ok, socket}
  end
end
