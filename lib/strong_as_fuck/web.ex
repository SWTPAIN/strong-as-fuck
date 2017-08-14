defmodule StrongAsFuck.Web do
  use Plug.Router

  plug :match
  plug :dispatch

  def start_server do
    Plug.Adapters.Cowboy.http(__MODULE__, nil, port: 4000)
  end

  # curl http://localhost:4000/training_log_books/alice
  get "/training_log_books/:username" do
    conn
    |> Plug.Conn.fetch_query_params
    |> fetch_notebook
    |> respond
  end

  # curl -d '' 'http://localhost:4000/training_log_books/alice/training_logs?movement_name=snatch&rep=10&weight=100'
  post "/training_log_books/:username/training_logs" do
    conn
    |> Plug.Conn.fetch_query_params
    |> add_training_log
    |> respond
  end

  defp fetch_notebook(conn) do
    Plug.Conn.assign(
      conn,
      :response,
      notebook(conn.path_params["username"])
    )
  end

  defp add_training_log(conn) do
    conn.path_params["username"]
    |> StrongAsFuck.Cache.server_process
    |> StrongAsFuck.Server.add_training_log(
      %{
        movement_name: conn.params["movement_name"],
        weight: conn.params["weight"],
        rep: conn.params["rep"],
      }
    )
    Plug.Conn.assign(conn, :response, "OK")
  end

  defp notebook(username) do
    result = username
    |> StrongAsFuck.Cache.server_process
    |> StrongAsFuck.Server.get_notebook
    case result do
      {:error, err_msg} -> err_msg
      {:ok, notebook} -> serialize_notebook(notebook)
    end
  end

  defp serialize_notebook(notebook) do
    Poison.encode!(notebook)
  end

  defp respond(conn) do
    conn
    |> Plug.Conn.put_resp_content_type("text/plain")
    |> Plug.Conn.send_resp(200, conn.assigns[:response])
  end

end
