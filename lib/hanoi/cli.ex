defmodule Hanoi.CLI do
  
  def parse_args(argv) do
    parse = OptionParser.parse(argv,
                               switches: [ help: :boolean],
                               aliases:  [h:     :help])

    case parse do
      { [help: true ], _ , _} -> :help
      { _, [stones], _ }      -> String.to_integer(stones) 
      _                       -> :help
    end
  end
end
