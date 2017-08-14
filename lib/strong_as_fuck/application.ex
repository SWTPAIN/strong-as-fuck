defmodule StrongAsFuck.Application do
  use Application

  def start(_type, _args) do
    response = StrongAsFuck.Supervisor.start_link
    StrongAsFuck.Web.start_server
    response
  end
end
