defmodule SquidGoatsWeb.PageController do
  use SquidGoatsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
