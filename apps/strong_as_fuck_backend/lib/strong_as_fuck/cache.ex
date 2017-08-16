defmodule StrongAsFuckBackend.Cache do

  def server_process(username) do
    case StrongAsFuckBackend.Server.whereis(username) do
      :undefined ->
        create_server(username)
      pid ->
        pid
    end
  end

  defp create_server(username) do
    case StrongAsFuckBackend.ServerSupervisor.start_child(username) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end

end
