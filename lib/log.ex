defmodule Log do
    use Agent

    # todo: make this into start_registry, add push_registry, add start_link with name argument
    def start_link() do
        Agent.start_link(fn -> [] end, [name: :global_log])
        |> case do
            {:ok, pid} -> {:ok, pid}
            {:error, {:already_started, pid}} -> {:ok, pid}
            {:error, reason} -> {:error, reason}
            other -> {:error, other}
        end
    end

    def append(log, entry) do
        Agent.update(log, fn entries -> entries ++ [entry] end)
    end

    def all_entries(log) do
        Agent.get(log, fn entries -> entries end)
    end

    def latest_entry(log) do
        Agent.get(log, fn entries -> Enum.at(entries, -1) end)
    end

    def size(log) do
        Agent.get(log, fn entries -> length(entries) end)
    end

    def delete(log) do
        Agent.stop(log)
    end
end