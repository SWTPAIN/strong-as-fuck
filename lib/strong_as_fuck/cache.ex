defmodule StrongAsFuck.Cache do

  def server_process(username) do
    case StrongAsFuck.Server.whereis(username) do
      :undefined ->
        create_server(username)
      pid ->
        pid
    end
  end

  defp create_server(username) do
    case StrongAsFuck.ServerSupervisor.start_child(username) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end

end
