defmodule HanoiWeb.ErrorHTML do
  use HanoiWeb, :html
  @moduledoc false

  def render(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
