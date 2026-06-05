defmodule GraphicsWeb.PageController do
  use GraphicsWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
