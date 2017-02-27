defmodule Materialize.Component do
  @moduledoc """
  Use materialize-css components

  ### [Navbar](https://hexdocs.pm/materialize/0.1.4-dev/Materialize.Components.Navbar.html#content)

  Add alias in **/web/views/layout_view.ex** with configuration navbar:

  ```Elixir
  use #{__MODULE__}

  def navbar(conn) do
    get_html([
      [:wrap, [class: "nav-wrapper"], [class: "col s12"]],
      [:logo, class: "brand-logo"],
      [:ul, [
        [:a, "list 1", [href: "#1"]],
        [:a, "list 2", [href: "#2"]]
      ], [id: "id-link"]] 
    ])
  end
  ```

  Use navbar in templates:
  
  ```Elixir
  <div class="row"><%= navbar(@conn) %></div>
  ```
  """

  import Materialize.Components.Navbar

  @doc false
  defmacro __using__(_) do
    quote do
      import Materialize.Components.Navbar
      # TODO import oyher components
    end
  end

  def bage do

  end

  def button do

  end

  def breadcrumbs do

  end

  def card do

  end

  def chip do

  end

  def collection do

  end

  def footer do

  end

  def form do

  end

  def icon do

  end

  def navbar(config) do
    Navbar.get_html(config)
  end

  def pagimation do

  end

  def preloader do

  end
end