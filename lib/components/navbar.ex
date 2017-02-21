defmodule Materialize.Components.Navbar do
  @docmodule """
  Use module for generate HTML block navbar.

  Add alias in **/web/views/layout_view.ex** with configuration navbar:
  
  ```Elixir
  alias #{__MODULE__}

  def navbar do
    [items: [
      [tag: "a", text: "Logo", attr: [href: "#", class: "brand-logo"]],
      [tag: "ul", attr: [id: "nav-mobile", class: "right hide-on-med-and-down"], items: [
        [tag: "a", text: "list 1", attr: [href: "#1"]],
        [tag: "a", text: "list 2", attr: [href: "#2"]]
      ]]
    ]]
    |> Navbar.get_html()
  end
  ```

  Use navbar in templates:
  
  ```Elixir
  <%= navbar %>
  ```

  Result

  ```Html
  <div class="nav-wrapper">
    <a href="#" class="brand-logo">Logo</a>
    <ul id="nav-mobile" class="right hide-on-med-and-down">
      <li><a href="#1">list 1</a></li>
      <li><a href="#2">list 2</a></li>
    </ul>
  </div>
  ```
	"""

  alias Materialize.Html

  @wrapper_options [attr: [class: "nav-wrapper"]]
  @logo_options [attr: [href: "#", class: "brand-logo"]]
  @ul_options [attr: [id: "nav-mobile", class: "right hide-on-med-and-down"]]

  @doc """
  Create tag <span> or etc.
  
  ### Parameters

    - options: keyword list

  ### Example

  ```Elixie
  #{__MODULE__}.get_html([items: [
      [tag: "a", text: "Logo", attr: [href: "#", class: "brand-logo"]],
      [tag: "ul", attr: [id: "nav-mobile", class: "right hide-on-med-and-down"], items: [
        [tag: "a", text: "list 1", attr: [href: "#1"]],
        [tag: "a", text: "list 2", attr: [href: "#2"]]
      ]]
    ]])
  ```
  """
  @spec get_html(Keyword.t) :: List.t
	def get_html(options) do
    options = check_options options
    attr = Html.get_attribute options
    [start: "<div#{attr}>", end: "</div>"]
    |> get_items(options[:items])
  end

  defp get_items(html, options) when is_list options do
    for item <- options do 
      cond do
        Html.has_key?(item, :items) -> Html.get_list item 
        true -> Html.get_tag item
      end
    end
    |> Enum.join("")
    |> do_wrapp(html)
  end

  defp do_wrapp(body, html), do: "#{html[:start]}#{body}#{html[:end]}"

  defp check_options(options) do
    options
    |> Enum.into(%{})
    |> check_options_attr()
    |> check_options_logo()
    |> Map.to_list()
  end

  defp check_options_attr(options) do
    Map.put_new(options, :attr, @wrapper_options[:attr])
  end

  # TODO add default attributes to logo if need 
  defp check_options_logo(options) do
    options
  end
end