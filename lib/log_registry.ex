defmodule LogRegistry do
    use Agent

    # unfinished!
    def register(name) do
        {:ok, registry} = start_registry()
        {:ok, log} = Agent.start_link(fn -> [] end, [name: name])

        Agent.update(registry, fn logs -> 
            if Enum.member?(logs, name), do: logs, else: [{name, log} | logs]
        end)
    end

    # unfinished!
    def unregister(name) do
        {:ok, registry} = start_registry()
        Agent.update(registry, fn logs -> 
            if Enum.member?(logs, name), do: logs -- name, else: logs
        end)
    end

    def all_logs() do
        {:ok, registry} = start_registry()
        Agent.get(registry, fn logs -> logs end)
    end

    defp start_registry() do
        Agent.start_link(fn -> [] end, [name: LogRegistry])
        |> case do
            {:ok, pid} -> {:ok, pid}
            {:error, {:already_started, pid}} -> {:ok, pid}
        end
    end
end