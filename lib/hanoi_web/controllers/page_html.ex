defmodule HanoiWeb.PageHTML do
  use Phoenix.Component 

  def home(assigns) do
    ~H"""
       <div class="lg:block">
        <pre>
          <%= Hanoi.Render.render_to_string(Hanoi.TowerGame.get_state(:hanoi)) %>
        </pre>
      </div>
    """
  end
end
