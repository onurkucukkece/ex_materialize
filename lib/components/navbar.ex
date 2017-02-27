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
    wrap = prepare_wrapper(wrap)
    logo = content_logo(logo)

    list = for item <- opts do
      if (Enum.member?(item, :ul)) do
        {tag, content, attr} = parse_item(item, "", @list_options)
        content = get_item(tag, content, attr)
        content_tag(tag, content, attr)
      end
    end

    # result navbar block
    content_tag(:nav) do
      content = [logo] ++ list
      do_wrap(wrap, content)
    end
  end

  # apply all wrappers
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

  # prepare wrappers
  defp prepare_wrapper(wrap) do
    for item <- wrap do
      attr = get_attr(item)

      if (List.first(wrap) === item) do
        Keyword.merge(@wrap_options, attr)
      else 
        attr
      end
    end
  end

  # get element: wrap or logo
  defp get_element(opts, member) do
    element = Enum.find(opts, [], fn(x) -> Enum.member?(x, member) end)
    {opts -- [element], element -- [member]}
  end

  # get link
  defp content_logo(logo) do
    {tag, content, attr} = parse_item([:a] ++ logo, @logo_name, @logo_options)
    content_tag(tag, content, attr)
  end

  # parse element and get tag, text and attribute
  defp parse_item(opts, default_text \\ "", default_attr \\ []) do
    {opts, tag} = get_tag(opts)
    {opts, content} = get_content(opts, default_text)
    attr = Enum.reverse(get_attr(opts, default_attr))

    {tag, content, attr}
  end

  # get tag
  defp get_tag(item) do
    error = "Element #{inspect(item)} has not tag"

    tag = with {:ok, tag} <- Enum.fetch(item, 0), true <- is_atom(tag) do
        tag
    else
      :error -> raise(ArgumentError, error)
      false -> raise(ArgumentError, error)
    end

    {item -- [tag], tag}
  end

  # teg text or default text
  defp get_content(item, default_text \\ "") do
    error = "Element #{inspect(item)} has not content"

    # TODO неверно срабатывает поиск и вычитание контента
    # :error и соответственно default_text никогда не отрабатывают

    with {:ok, content} <- Enum.fetch(item, 0) do
        item = item -- [content]

        case content do
          content when is_binary(content) -> content 
          content when is_list(content) -> get_item(nil, content, nil)
          _ -> raise(ArgumentError, error)
        end

        {item, content}
    else
      :error -> {item, default_text}
    end
  end

  # get attribute from [class: "example"] or {:class, "example"}
  defp get_attr(item, default_attr \\ []) do
    error = "Error get attributes in element #{inspect(item)}"

    # if attributes set as keyword
    attr = with {:ok, attr} <- Enum.fetch(item, 0) do
        if (is_list(attr)) do
          attr
        else 
          for el <- item, is_tuple(el), do: el
        end
    # if attributes set as tuples
    else
      :error -> []
    end

    Keyword.merge(default_attr, attr) |> Enum.reverse()
  end

  # get one element, example <a>
  defp get_item(tag, content, attr) when is_binary(content) do
    content_tag(tag, content, attr)
  end

  # get list, example <ul>
  defp get_item(_, list, _) when is_list(list) do
    for item <- list do
      {tag, content, attr} = parse_item(item)
      content_tag(:li, get_item(tag, content, attr))
    end
  end
end