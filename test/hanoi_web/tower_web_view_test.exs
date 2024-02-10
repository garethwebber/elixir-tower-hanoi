defmodule TowerWebViewTest do
  use ExUnit.Case

  import HanoiWeb.HanoiGameView
  import Phoenix.LiveViewTest

  test "test render_css" do
    assert render_component(&render_css/1, number_stones: 5) ==
      "<style>\n .stone {\n    margin:            0 auto;\n    height:            20px;\n    background-color:  --var(color2)\n    justify-content:   center;\n }\n .pile {\n    display:           inline;\n    width:             33%;\n    margin-top:        auto;\n }     \n .board {\n    display:          flex;\n    flex-direction:   row;\n    width:            100%;\n    height:           140px;\n    border-bottom:    solid;\n    padding:          0;\n }\n  :root {\n     --color1: #155263; \n     --color2: #ff6f3c; \n     --color3: #ff9a3c; \n     --color4: #ffc93c; \n  }\n </style>"
  end

  test "test render_board - initial state" do
    name = :test_tower
    stones = 3
    {:ok, _pid} = Hanoi.TowerGame.start_link(%{name: name, stones: stones})
    board = Hanoi.TowerGame.get_state(name)

    assert render_component(&render_board/1, board: board, number_stones: stones) ==
     "  <!--33-->\n  <div name=\"board\" class=\"board\">\n  \n  <div name=\"left\" class=\"pile\">   \n  <div name=\"st1\" class=\"stone\" \n              style=\"width:33%; background: var(--color2)\"></div><div name=\"st2\" class=\"stone\" \n              style=\"width:66%; background: var(--color3)\"></div><div name=\"st3\" class=\"stone\" \n              style=\"width:99%; background: var(--color4)\"></div>\n       \n  </div>                               \n\n  <div name=\"left\" class=\"pile\">   \n  \n       \n  </div>                               \n\n  <div name=\"left\" class=\"pile\">   \n  \n       \n  </div>                               \n\n  </div>" 
  end

  test "test render_board - mid-play" do
    name = :test_tower
    stones = 5
    {:ok, _pid} = Hanoi.TowerGame.start_link(%{name: name, stones: stones})
    Hanoi.TowerGame.move_stone(name, :left, :centre)
    Hanoi.TowerGame.move_stone(name, :left, :right)
    board = Hanoi.TowerGame.get_state(name)

    assert render_component(&render_board/1, board: board, number_stones: stones) ==
    "  <!--20-->\n  <div name=\"board\" class=\"board\">\n  \n  <div name=\"left\" class=\"pile\">   \n  <div name=\"st3\" class=\"stone\" \n              style=\"width:60%; background: var(--color4)\"></div><div name=\"st4\" class=\"stone\" \n              style=\"width:80%; background: var(--color1)\"></div><div name=\"st5\" class=\"stone\" \n              style=\"width:100%; background: var(--color2)\"></div>\n       \n  </div>                               \n\n  <div name=\"left\" class=\"pile\">   \n  <div name=\"st1\" class=\"stone\" \n              style=\"width:20%; background: var(--color2)\"></div>\n       \n  </div>                               \n\n  <div name=\"left\" class=\"pile\">   \n  <div name=\"st2\" class=\"stone\" \n              style=\"width:40%; background: var(--color3)\"></div>\n       \n  </div>                               \n\n  </div>" 
  end

  test "test render_reset_block" do
      assert render_component(&render_reset_block/1) ==
      "<form phx-submit=\"reset\" phx-update=\"ignore\">\n  \n  \n  \n   <div class=\"flex items-end items-center\">\n     <span>Stones:&nbsp;</span>\n     <div phx-feedback-for=\"stone\">\n  <label for=\"stone\" class=\"block text-sm font-semibold leading-6 text-zinc-800\">\n  \n</label>\n  <select id=\"stone\" name=\"stone\" class=\"mt-2 block w-full rounded-md border border-gray-300 bg-white shadow-sm focus:border-zinc-400 focus:ring-0 sm:text-sm\">\n    \n    <option selected value=\"3\">3</option><option value=\"4\">4</option><option value=\"5\">5</option><option value=\"6\">6</option><option value=\"7\">7</option><option value=\"8\">8</option>\n  </select>\n  \n</div> \n    <button class=\"phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80 \">\n  Reset\n</button>\n    </div>\n  \n</form>"
  end

  test "test render_error_text no errors" do
    assert render_component(&render_error_text/1, error_text: nil) ==
    "<p>&nbsp</p>"
  end

  test "test render_error_text" do
    assert render_component(&render_error_text/1, error_text: "bad move") ==
    "<p class=\"text-center\">\n    <span class=\"prose border border-red-500\"> \n      &nbsp; \n      <span class=\"hero-exclamation-circle-mini py-2.5 h-4 w-4 text-red-500\"></span>\n      bad move\n      &nbsp;\n    </span>\n  </p>"
  end

  test "test render_move_count" do
    assert render_component(&render_number_moves/1, number_moves: 5) ==  
    "<span class=\"prose py-4\">\n       Number of moves: 5\n     </span>"
  end

  test "test render_manual controls" do
   assert render_component(&render_game_controls/1, number_moves: 5) ==
   "<hr class=\"h-px my-2 bg-gray-200 border-0 dark:bg-gray-700\">\n\n <div class=\"flex py-1 gap-x-2 justify-between\">\n   <button class=\"phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80 \" phx-click=\"move_stone\" phx-value-from=\"left\" phx-value-to=\"centre\">\n  Left to centre\n</button>\n   <button class=\"phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80 \" phx-click=\"move_stone\" phx-value-from=\"centre\" phx-value-to=\"left\">\n  Centre to left\n</button>\n   <button class=\"phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80 \" phx-click=\"move_stone\" phx-value-from=\"centre\" phx-value-to=\"right\">\n  Centre to right\n</button>\n   <button class=\"phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80 \" phx-click=\"move_stone\" phx-value-from=\"right\" phx-value-to=\"centre\">\n  Right to centre\n</button>\n   </div>\n   <div class=\"flex py-1 justify-between\">\n   <button class=\"phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80 \" phx-click=\"move_stone\" phx-value-from=\"left\" phx-value-to=\"right\">\n  Left to right\n</button>\n   <button class=\"phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80 \" phx-click=\"move_stone\" phx-value-from=\"right\" phx-value-to=\"left\">\n  Right to Left\n</button>\n </div>"
  end

  test "test render automode control" do
   assert render_component(&render_automode_control/1, number_moves: 5) ==
   "<hr class=\"h-px my-2 bg-gray-200 border-0 dark:bg-gray-700\">\n  <button class=\"phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80 \" phx-click=\"auto_mode\">\n  Auto mode\n</button>"
  end
end
