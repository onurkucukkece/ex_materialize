defmodule NavbarTest do
  use ExUnit.Case

  alias Materialize.Components.Navbar

  doctest Materialize.Components.Navbar

  test "check get html" do
		[
      [:wrap ,id: "wp-class"],
      [:logo, class: "l-class"],
      [:ul, [
        [:a, "list 1", [href: "#1"]],
        [:a, "list 2", [href: "#2"]]
      ], [id: "qqq"]]
    ]
    |> Navbar.get_html()
    |> IO.inspect()
  end

  # TODO write test
end