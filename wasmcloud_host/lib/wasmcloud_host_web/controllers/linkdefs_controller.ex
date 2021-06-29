defmodule WasmcloudHostWeb.LinkdefsController do
  use WasmcloudHostWeb, :controller
  require HostCore

  def define_link(conn, params) do
    actor = params["actor_id"]
    contract_id = params["contract_id"]
    link_name = params["link_name"]
    provider_key = params["provider_id"]

    values =
      case params["values"] do
        "" ->
          %{}

        _ ->
          params["values"]
          |> String.split(",")
          |> Enum.flat_map(fn s -> String.split(s, "=") end)
          |> Enum.chunk_every(2)
          |> Enum.map(fn [a, b] -> {a, b} end)
          |> Map.new()
      end

    HostCore.Linkdefs.Manager.put_link_definition(
      actor,
      contract_id,
      link_name,
      provider_key,
      values
    )

    conn |> redirect(to: "/")
  end
end