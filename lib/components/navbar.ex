defmodule Materialize.Components.Navbar do
  @moduledoc """
  Use module for generate HTML block navbar.

  Add alias in **/web/views/layout_view.ex** with configuration navbar:
  
  ```Elixir
  alias #{__MODULE__}

  def navbar do
    [
      [:wrap ,class: "wp-class"],
      [:logo, class: "l-class"]
      [:ul, [
        [:a, "list 1", [href: "#1"]],
        [:a, "list 2", [href: "#2"]]
      ], [id: "qqq"]]
    ]
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
  use Phoenix.HTML

  @wrap_options [class: "nav-wrapper"]
  @logo_options [href: "#", class: "brand-logo"]
  @list_options [id: "nav-mobile", class: "right hide-on-med-and-down"]

  # defstruct [wrapper: @wrapper_options, logo: @logo_options]

  @doc """
  Create tag **span** or etc.
  
  ### Parameters

    - options: keyword list

  ### Example

  ```Elixie
  #{__MODULE__}.get_html([
      [:wrap ,class: "wp-class"],
      [:logo, class: "l-class"]
      [:ul, [
        [:a, "list 1", [href: "#1"]],
        [:a, "list 2", [href: "#2"]]
      ], [id: "qqq"]] 
    ])
  ```
  """
  def get_html(opts) do
    {opts, wrap} = get_element(opts, :wrap, @wrap_options)
    {opts, logo} = get_element(opts, :logo, @logo_options)

    for item <- opts do
      if (Enum.member?(item, :ul)) do
        {tag, content, attr} = parse_item(item)
        content = get_item(tag, content, attr)
        content_tag(tag, content, attr)
      end
    end
  end

  defp get_element(opts, member, default) do
    element = Enum.find(opts, [], fn(x) -> Enum.member?(x, member) end)
    {opts -- [element], Keyword.merge(default, element -- [member])}
  end

  defp parse_item(opts) do
    tag = get_tag(opts)
    content = get_content(opts)
    attr = get_attr(opts)

    {tag, content, attr}
  end

  defp get_tag(item) do
    error = "Element #{inspect(item)} has not tag"

    with {:ok, tag} <- Enum.fetch(item, 0), true <- is_atom(tag) do
        tag
    else
      :error -> raise(ArgumentError, error)
      false -> raise(ArgumentError, error)
    end
  end

  defp get_content(item) do
    error = "Element #{inspect(item)} has not content"

    with {:ok, content} <- Enum.fetch(item, 1) do
        content
    else
      :error -> ""
      false -> raise(ArgumentError, error)
    end
  end

  defp get_attr(item) do
    error = "Error get attributes in element #{inspect(item)}"

    with {:ok, attr} <- Enum.fetch(item, 2), true <- is_list(attr) do
        Keyword.merge(@list_options, attr)
    else
      :error -> @list_options
      false -> raise(ArgumentError, error)
    end
  end

  defp get_item(tag, content, attr) when is_binary(content) do
    content_tag(tag, content, attr)
  end

  defp get_item(tag, content, attr) when is_list(content) do
    list = for item <- content do
      {tag, content, attr} = parse_item(item)
      get_item(tag, content, attr)
    end

    content_tag(tag, list, attr)
  end
end