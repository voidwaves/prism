defmodule Log do
    use Agent
    require LogRegistry

    def start_link(name) do
        :ok = LogRegistry.register(name)
        # {^name, pid} = LogRegistry.get_log(name)
        # {:ok, pid}
    end

    def append(name, entry) do
        case LogRegistry.get_log(name) do
            {^name, pid} -> 
                :ok = Agent.update(pid, fn entries -> entries ++ [entry] end)
                {:ok, entry}
            _ -> {:error, :not_found}
        end
    end

    def all_entries(name) do
        case LogRegistry.get_log(name) do
            {^name, pid} -> Agent.get(pid, fn entries -> entries end)
            _ -> {:error, :not_found}
        end
    end

    def latest_entry(name) do
        case LogRegistry.get_log(name) do
            {^name, pid} -> Agent.get(pid, fn entries -> Enum.at(entries, -1) end)
            _ -> {:error, :not_found}
        end
    end

    def size(name) do
        case LogRegistry.get_log(name) do
            {^name, pid} -> Agent.get(pid, fn entries -> length(entries) end)
            _ -> {:error, :not_found}
        end
    end

    def delete(name) do
        :ok = LogRegistry.unregister(name)
    end
end