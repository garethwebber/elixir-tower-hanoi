defmodule TowerWebViewTest do
  use ExUnit.Case

  import HanoiWeb.HanoiGameView
  import Phoenix.LiveViewTest

  test "test render_css" do
    assert render_component(&render_css/1, number_stones: 5) ==
      "<style>\n .stone {\n    margin:            0 auto;\n    height:            20px;\n    background-color:  --var(color2)\n    justify-content:   center;\n }\n .pile {\n    display:           inline;\n    width:             33%;\n    margin-top:        auto;\n }     \n .board {\n    display:          flex;\n    flex-direction:   row;\n    width:            100%;\n    height:           140px;\n    border-bottom:    solid;\n    padding:          0;\n }\n  :root {\n     --color1: #155263; \n     --color2: #ff6f3c; \n     --color3: #ff9a3c; \n     --color4: #ffc93c; \n  }\n </style>"
  end

  test "test render_board - initial state" do
  end

  test "test render_board - mid-play" do
  end

  test "test render_reset_block" do
  end

  test "test render_error_text no errors" do
  end

  test "test render_error_text" do
  end

  test "test render_move_count" do
  end

  test "test render_manual controls" do
  end

  test "test render automode controls" do
  end
end
