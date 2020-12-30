defmodule Prism do
  require Log

  def example do
    {:ok, pid1} = Log.start_link()
    Log.append(pid1, "first entry")
    IO.puts("pid1")
    Log.all_entries(pid1)
    |> inspect()
    |> IO.puts()
 
    {:ok, pid2} = Log.start_link()
    Log.append(pid2, "second entry")
    IO.puts("pid2")
    Log.all_entries(pid2)
    |> inspect()
    |> IO.puts()

    {:ok, _} = {Log.delete(pid2), "deleted log"}
  end
end