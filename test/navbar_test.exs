defmodule NavbarTest do
  use ExUnit.Case

  alias Materialize.Components.Navbar

  doctest Materialize.Components.Navbar

  test "check get html" do
		[items: [
      [attr: [id: "qqq"], items: [
        [tag: "a", text: "list 1", attr: [href: "#1"]],
        [tag: "a", text: "list 2", attr: [href: "#2"]]]
      ] 
    ]]
    |> Navbar.get_html()
    |> IO.inspect()
  end

  # TODO write test
end