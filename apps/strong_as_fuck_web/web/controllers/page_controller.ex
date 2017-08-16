defmodule StrongAsFuckWeb.PageController do
  use StrongAsFuckWeb.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
