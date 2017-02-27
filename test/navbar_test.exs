defmodule NavbarTest do
  use ExUnit.Case

  import Materialize.Components.Navbar
  import Phoenix.HTML

  doctest Materialize.Components.Navbar

  # test "check get html" do
  #   [
  #     [:wrap, [class: "nav-wrapper"], [class: "col s12"]],
  #     [:logo, "Custom Logo", [class: "qwerty"]],
  #     [:ul, [
  #       [:a, "list 1", [href: "#1"]],
  #       [:a, "list 2", [href: "#2"]]
  #     ]]
  #   ]
  #   |> get_html()
  #   |> safe_to_string()
  #   |> IO.inspect()
  # end

  # TODO write test

  test "when set full options, attributes set as keywords" do
    opts = [
      [:wrap, [class: "nav-wrapper"], [class: "col s12"]],
      [:logo, "Custom Logo", [href: "#", class: "brand-logo"]],
      [:ul, [
        [:a, "list 1", [href: "#1"]],
        [:a, "list 2", [href: "#2"]]
      ], [id: "nav-mobile", class: "right hide-on-med-and-down"]]
    ]

    assert safe_to_string(get_html(opts)) == ~s(<nav>) <>
      ~s(<div class="nav-wrapper">) <>
      ~s(<div class="col s12">) <>
      ~s(<a class="brand-logo" href="#">Custom Logo</a>) <>
      ~s(<ul class="right hide-on-med-and-down" id="nav-mobile">) <>
      ~s(<li><a href="#1">list 1</a></li>) <>
      ~s(<li><a href="#2">list 2</a></li>) <>
      ~s(</ul>) <>
      ~s(</div>) <>
      ~s(</div>) <>
      ~s(</nav>)
  end

  test "when set minimum options, attributes set as keywords" do
    opts = [
      [:ul, [
        [:a, "list 1", [href: "#1"]],
        [:a, "list 2", [href: "#2"]]
      ]]
    ]

    assert safe_to_string(get_html(opts)) == ~s(<nav>) <>
      ~s(<div class="nav-wrapper">) <>
      ~s(<a class="brand-logo" href="#">Logo</a>) <>
      ~s(<ul class="right hide-on-med-and-down" id="nav-mobile">) <>
      ~s(<li><a href="#1">list 1</a></li>) <>
      ~s(<li><a href="#2">list 2</a></li>) <>
      ~s(</ul>) <>
      ~s(</div>) <>
      ~s(</nav>)
  end

  test "when set full options, attributes set as tuples, except wrapper" do
    opts = [
      [:wrap, [class: "nav-wrapper"], [class: "col s12"]],
      [:logo, "Custom Logo", class: "brand-logo"],
      [:ul, [
        [:a, "list 1", href: "#1"],
        [:a, "list 2", href: "#2"]
      ], id: "nav-mobile", class: "right hide-on-med-and-down"]
    ]

    assert safe_to_string(get_html(opts)) == ~s(<nav>) <>
      ~s(<div class="nav-wrapper">) <>
      ~s(<div class="col s12">) <>
      ~s(<a class="brand-logo" href="#">Custom Logo</a>) <>
      ~s(<ul class="right hide-on-med-and-down" id="nav-mobile">) <>
      ~s(<li><a href="#1">list 1</a></li>) <>
      ~s(<li><a href="#2">list 2</a></li>) <>
      ~s(</ul>) <>
      ~s(</div>) <>
      ~s(</div>) <>
      ~s(</nav>)
  end

  test "when set minimum options, attributes set as tuples" do
    opts = [
      [:ul, [
        [:a, "list 1", href: "#1"],
        [:a, "list 2", href: "#2"]
      ]]
    ]

    assert safe_to_string(get_html(opts)) == ~s(<nav>) <>
      ~s(<div class="nav-wrapper">) <>
      ~s(<a class="brand-logo" href="#">Logo</a>) <>
      ~s(<ul class="right hide-on-med-and-down" id="nav-mobile">) <>
      ~s(<li><a href="#1">list 1</a></li>) <>
      ~s(<li><a href="#2">list 2</a></li>) <>
      ~s(</ul>) <>
      ~s(</div>) <>
      ~s(</nav>)
  end

  test "when set options without logo, some wrappers" do
    opts = [
      [:wrap, [class: "nav-wrapper"], [class: "col s12"]],
      [:ul, [
        [:a, "list 1", [href: "#1"]],
        [:a, "list 2", [href: "#2"]]
      ], id: "nav-mobile", class: "right hide-on-med-and-down"]
    ]

    assert safe_to_string(get_html(opts)) == ~s(<nav>) <>
      ~s(<div class="nav-wrapper">) <>
      ~s(<div class="col s12">) <>
      ~s(<a class="brand-logo" href="#">Logo</a>) <>
      ~s(<ul class="right hide-on-med-and-down" id="nav-mobile">) <>
      ~s(<li><a href="#1">list 1</a></li>) <>
      ~s(<li><a href="#2">list 2</a></li>) <>
      ~s(</ul>) <>
      ~s(</div>) <>
      ~s(</div>) <>
      ~s(</nav>)
  end

  test "when set options without logo, one wrapper without default class" do
    opts = [
      [:wrap, [id: "nav-wrapper"]],
      [:ul, [
        [:a, "list 1", [href: "#1"]],
        [:a, "list 2", [href: "#2"]]
      ]]
    ]

    assert safe_to_string(get_html(opts)) == ~s(<nav>) <>
      ~s(<div class="nav-wrapper" id="nav-wrapper">) <>
      ~s(<a class="brand-logo" href="#">Logo</a>) <>
      ~s(<ul class="right hide-on-med-and-down" id="nav-mobile">) <>
      ~s(<li><a href="#1">list 1</a></li>) <>
      ~s(<li><a href="#2">list 2</a></li>) <>
      ~s(</ul>) <>
      ~s(</div>) <>
      ~s(</nav>)
  end

  test "when set options without wrapper and logo with custom class" do
    opts = [
      [:logo, class: "custom-logo-class"],
      [:ul, [
        [:a, "list 1", [href: "#1"]],
        [:a, "list 2", [href: "#2"]]
      ]]
    ]

    assert safe_to_string(get_html(opts)) == ~s(<nav>) <>
      ~s(<div class="nav-wrapper">) <>
      ~s(<a class="custom-logo-class" href="#">Logo</a>) <>
      ~s(<ul class="right hide-on-med-and-down" id="nav-mobile">) <>
      ~s(<li><a href="#1">list 1</a></li>) <>
      ~s(<li><a href="#2">list 2</a></li>) <>
      ~s(</ul>) <>
      ~s(</div>) <>
      ~s(</nav>)
  end
end