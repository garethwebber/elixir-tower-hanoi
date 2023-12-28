defmodule Hanoi.Board do
  alias Hanoi.Board
  defstruct [     
    left: [],    
    centre: [],  
    right: []
  ]
  
  def create_board(plates) do
    %Board{ left: create_loaded_stack(plates) }
  end

  def create_loaded_stack(plates) do
      create_stack_int([], plates, 1)
  end

  defp create_stack_int(stack, 0, _counter) do stack end
  defp create_stack_int(stack, platesleft, counter) do
    create_stack_int([counter|stack], (platesleft - 1) , (counter + 1))
  end

end
