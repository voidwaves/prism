defmodule LogRegistry do
    use Agent

    def register(name) do
        {:ok, registry} = start_registry()
        {:ok, log} = Agent.start_link(fn -> [] end, [name: name])

        :ok = Agent.update(registry, fn logs -> 
            if Enum.member?(logs, name), do: logs, else: [{name, log} | logs]
        end)
    end

    def unregister(name) do
        {:ok, registry} = start_registry()

        :ok = Agent.update(registry, fn logs -> 
            Enum.filter(logs, fn {log_name, log_pid} -> 
                deleted = name == log_name 
                if deleted, do: Agent.stop(log_pid)
                !deleted
            end)
        end)
    end

    def get_log(name) do
        {:ok, registry} = start_registry()

        Agent.get(registry, fn logs ->
            Enum.find(logs, fn {log_name, _} -> 
                name == log_name
            end)
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