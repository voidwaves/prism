defmodule Prism do
  require Log
  require LogRegistry

  def example do
    :ok = Log.start_link(:first)
    Log.all_entries(:first)
    |> inspect()
    |> IO.puts()
    Log.append(:first, "first hello first log")
    Log.append(:first, "second hello first log")
    Log.all_entries(:first)
    |> inspect()
    |> IO.puts()

    :ok = Log.start_link(:second)
    Log.all_entries(:second)
    |> inspect()
    |> IO.puts()
    Log.append(:second, "first hello second log")
    Log.all_entries(:second)
    |> inspect()
    |> IO.puts()

    Log.delete(:second)
    Log.all_entries(:second)
    |> inspect()
    |> IO.puts()
    LogRegistry.all_logs()
    |> inspect()
    |> IO.puts()
  end
end