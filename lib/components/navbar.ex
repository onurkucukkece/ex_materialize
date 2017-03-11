defmodule Materialize.Components.Navbar do
  @moduledoc """
  Use module for generate HTML block navbar.

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

  Result

  ```Html
  <nav>
    <div class="nav-wrapper">
      <a href="#" class="brand-logo">Logo</a>
      <ul class="right hide-on-med-and-down" id="nav-mobile" >
        <li><a href="#1">list 1</a></li>
        <li><a href="#2">list 2</a></li>
      </ul>
    </div>
  </nav>
  ```

  ## Notice!

  All attributes of the element, the module *Phoenix.HTML* sorts in alphabetical order

  ```Elixir
  # set
  [:a, "link", [id: "example-id", class: "example-class", target: "_blank"]]
  # get
  <a class="example-class" id="example-id" target="_blank">link</a>
  ```

  ### Default attributes

  All default attributes are overwritten by the custom

  #### Wrapper

  ```Elixir
  [class: "nav-wrapper"] # set class if not set for first wrapper
  ```

  If you need some wrappers
  
  ```Elixir
  [:wrap, [class: "nav-wrapper"], [class: "col s12"]]
  ```

  Result

  ```Html
  <nav>
    <div class="nav-wrapper"> <!--- wrapper 1 -->
      <div class="col s12">   <!--- wrapper 2 -->
        <!--- other elements --->
      </div>
    </div>
  </nav>
```

  #### Logo

  **Attributes**

  ```Elixir
  [href: "#", class: "brand-logo"] # if href or class not set
  ```

  **Name**

  ```Elixir
  "Logo" # if not set
  ```

  #### List (**ul** elements for menu)
  ```Elixir
  [id: "nav-mobile", class: "right hide-on-med-and-down"] # in not set class or id
  ``` 
  """

  use Phoenix.HTML

  @wrap_options [class: "nav-wrapper"]
  @logo_options [href: "#", class: "brand-logo"]
  @logo_name "Logo"
  @list_options [id: "nav-mobile", class: "right hide-on-med-and-down"]

  # defstruct [wrapper: @wrapper_options, logo: @logo_options]

  @doc """
  Create tag **span** or etc.
  
  ### Parameters

    - options: keyword list

  ### Example

  ```Elixie
  #{__MODULE__}.get_html([
      [:wrap, [class: "nav-wrapper"], [class: "col s12"]],
      [:logo, class: "brand-logo"],
      [:ul, [
        [:a, "list 1", [href: "#1"]],
        [:a, "list 2", [href: "#2"]]
      ], [id: "id-link"]] 
    ])
  ```
  """
  @spec get_html(Keyword.t) :: {:safe, [String.t]}
  def get_html(opts) do
    {opts, wrap} = get_element(opts, :wrap)
    {opts, logo} = get_element(opts, :logo)
    wrap = get_wrapper(wrap)
    logo = get_logo(logo)

    list = for item <- opts do
      if (Enum.member?(item, :ul)) do
        {tag, content, attr} = parse_item(item, "", @list_options)
        content = get_item(tag, content, attr)
        content_tag(tag, content, attr)
      end
    end

    # result navbar block
    content_tag(:nav) do
      do_wrap(wrap, [safe: [elem(logo, 1), list[:safe]]])
    end
  end

	# region - common
  defp get_element(opts, member) do
    element = Enum.find(opts, [], fn(x) -> Enum.member?(x, member) end)
    {opts -- [element], element -- [member]}
  end

  defp get_attr(opts, default_attr) when length(opts) > 0 do
    Keyword.merge(default_attr, List.flatten(opts))
  end

  defp get_attr(opts, default_attr) when opts == [], do: default_attr
	# endregion

	# region - prepare wrappwer
  defp get_wrapper(wrap) when length(wrap) == 0 do
    [Keyword.merge(@wrap_options, wrap)]
    |> get_wrapper()
  end

  defp get_wrapper(wrap) when is_list(wrap) do
    first = Keyword.merge(@wrap_options, List.first(wrap))
    List.replace_at(wrap, 0, first)
  end

  defp do_wrap(wrap, content) do
    wrapper = List.last(wrap)
    wrap = wrap -- [wrapper]

    if (length(wrap) > 0) do
      content = content_tag(:div, content, wrapper)
      do_wrap(wrap, content)
    else
      content_tag(:div, content, wrapper)
    end
  end
  # endregion

	# region - prepare logo
  defp get_logo(logo) do
		name = Enum.find(logo, @logo_name, &is_binary/1)
		content_tag(:a, name, get_attr(logo -- [name], @logo_options))
  end
  # endregion

	# region - prepare items
  defp parse_item(opts, default_text \\ "", default_attr \\ []) do
    tag = get_tag(opts)
    content_ = opts -- [tag] |> List.first()
    content =  get_content(content_, default_text)
    {tag, content, get_attr(opts -- [tag, content_], default_attr)}
  end

  defp get_tag(opts) when is_list(opts) do
    List.first(opts)
    |> get_tag()
  end

  defp get_tag(opts) when is_atom(opts), do: opts
  defp get_tag(opts), do: raise(ArgumentError, "The tag must be at first element! #{inspect(opts)}")

  defp get_content(opts, _) when is_list(opts), do: get_item(nil, opts, nil)
  defp get_content(opts, _) when is_binary(opts), do: opts
	defp get_content(opts, default_text) when is_nil(opts), do: default_text
	defp get_content(_, default_text), do: default_text

  defp get_item(tag, content, attr) when is_binary(content), do: content_tag(tag, content, attr)

  defp get_item(_, list, _) when is_list(list) do
    for item <- list do
      if is_list(item) do
        {tag, content, attr} = parse_item(item)
        content_tag(:li, get_item(tag, content, attr))
      else
        item
      end
    end
  end
  # endregion
end