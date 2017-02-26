defmodule NavbarTest do
  use ExUnit.Case

  alias Materialize.Components.Navbar

  doctest Materialize.Components.Navbar

  test "check get html" do
		[
      [:logo, "Steam API", class: "qwerty"],
      [:ul, [
        [:a, "list 1", [href: "#1"]],
        [:a, "list 2", [href: "#2"]]
      ]]
    ]
    |> Navbar.get_html()
    |> IO.inspect()
  end

  # TODO write test
end