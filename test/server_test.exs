defmodule StrongAsFuck.ServerTest do
  use ExUnit.Case

  setup do
    server_pid = StrongAsFuck.Server.start()
    [server_pid: server_pid]
  end
  test "server should return correct pullup and pushup count", %{server_pid: server_pid} do
    StrongAsFuck.Server.add_training_record(
      server_pid, :pullup
    )
    StrongAsFuck.Server.add_training_record(
      server_pid, :pushup
    )
    StrongAsFuck.Server.add_training_record(
      server_pid, :pushup
    )
    {:ok, result } = StrongAsFuck.Server.get_stat(server_pid)
    assert result.pullup == 1
    assert result.pushup == 2
  end


  test "server should return error if caller try to remove movement to lower than 0", %{server_pid: server_pid} do
    StrongAsFuck.Server.add_training_record(
      server_pid, :pushup
    )
    StrongAsFuck.Server.remove_training_record(
      server_pid, :pushup
    )
    {result, _ } = StrongAsFuck.Server.remove_training_record(
      server_pid, :pushup
    )
    assert result == :error
  end

end
