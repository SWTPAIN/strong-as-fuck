defmodule StrongAsFuckBackend.Application do
  use Application

  def start(_type, _args) do
    response = StrongAsFuckBackend.Supervisor.start_link
    StrongAsFuckBackend.Web.start_server
    response
  end
end
