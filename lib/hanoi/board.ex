defmodule Hanoi.Board do
  alias Hanoi.Board
  defstruct [     
    left: [],    
    centre: [],  
    right: []
  ]
  
  def create_board(stones) do
    %Board{ left: create_loaded_stack(stones) }
  end

  def create_loaded_stack(stones) do
      create_stack_int([], stones, 1)
  end

  defp create_stack_int(stack, 0, _counter) do stack end
  defp create_stack_int(stack, stonesleft, counter) do
    create_stack_int([counter|stack], (stonesleft - 1) , (counter + 1))
  end

end
