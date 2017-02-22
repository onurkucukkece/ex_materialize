defmodule Materialize.Html do
  @moduledoc """
  Helper for create HTML blocks

  Before add module 

  ```Elixir
  alias #{__MODULE__}
  ```

  ### Example

  Create link **a**:

  ```Elixie
  #{__MODULE__}.get_a("Link", "#", [class: "example"])
  #{__MODULE__}.get_a [text: "Link", attr: [href: "#", class: "example"]]
  ```

  result

  ```Html
  <a href="#" class="example">Link</a>
  ```

  Create tag **span**:

  ```Elixie
  #{__MODULE__}.get_tag("span", "Text", [class: "example"])
  #{__MODULE__}.get_tag [tag: "span", text: "Text", attr: [class: "example"]]
  ```

  result

  ```Html
  <span class="example">Text</span>
  ```

  Create list **ul**:

  ```Elixie
  #{__MODULE__}.get_list [tag: "ul", attr: [class: "example"], items: [
    [text: "text"],
    [tag: "a", text: "link", attr: [href: "#"]]
  ]]
  ```

  result

  ```Html
  <ul>
    <li>text</li>
    <li><a href="#">link</a></li>
  </ul>
  ```
  """

  @default_list [tag: "ul"]

  @doc """
  Create link **a**
  
  ### Parameters

    - text: text link
    - href: ulr link
    - attr: keyword list

  ### Example

  ```Elixie
  #{__MODULE__}.get_a("Link", "#", [class: "example"])
  ```
  """
  @spec get_a(String.t, String.t, Keyword.t) :: List.t
  def get_a(text, href, attr \\ []) do
    ~s(<#a href="#{}"#{render_attribute(attr)}>#{text}</#a>)
  end

  @doc """
  Create link **a**
  
  ### Parameters
    - item: keyword list
  ### Example
  ```Elixie
  #{__MODULE__}.get_a [text: "Link", attr: [href: "#", class: "example"]]
  ```
  """
  @spec get_a(Keyword.t) :: List.t
  def get_a(item) when is_list item do
    attr = get_attribute item
    "<#a#{attr}>#{item[:text]}</#a>"
  end

  @doc """
  Create tag **span** or etc.
  
  ### Parameters

    - tag: tag, *span, i, p* ... etc.
    - text: text into tag
    - attr: keyword list html attributes 

  ### Example

  ```Elixie
  #{__MODULE__}.get_tag("span", "Text", [class: "example"])
  ```
  """
  @spec get_tag(String.t, String.t, Keyword.t) :: List.t
  def get_tag(tag, text, attr \\ []) do
    ~s(<#{tag}#{render_attribute(attr)}>#{text}</#{tag}>)
  end

  @doc """
  Create tag **span** or etc.
  
  ### Parameters
    - item: keyword list
  ### Example
  ```Elixie
  #{__MODULE__}.get_tag [tag: "span", text: "Text", attr: [class: "example"]]
  ```
  """
  @spec get_tag(Keyword.t) :: List.t
  def get_tag(item) when is_list item do
    attr = get_attribute item
    cond do
      has_key?(item, :tag) -> "<#{item[:tag]}#{attr}>#{item[:text]}</#{item[:tag]}>"
      true -> "#{item[:text]}"
    end
  end

  @doc """
  Create list **ul**
  
  ### Parameters

    - item: keyword list

  ### Example

  ```Elixie
  #{__MODULE__}.get_list [tag: "ul", attr: [class: "example"], items: [
    [text: "text"],
    [tag: "a", text: "link", attr: [href: "#"]]
  ]]
  ```
  """
  @spec get_list(Keyword.t) :: List.t
  def get_list(item) do
    item = check_list item
    attr = get_attribute item
    for item <- item[:items] do get_tag(item) end
    |> Enum.map(&("<li>#{&1}</li>"))
    |> Enum.join("")
    |> do_wrapp([start: "<#{item[:tag]}#{attr}>", end: "</#{item[:tag]}>"])
  end

  defp check_list(item) do
    item
    |> Keyword.put_new(:tag, @default_list[:tag])
  end

  @doc """
  Get html attributes

  ### Parameters

    - item: keyword list

  ### Example

  ```Elixie
  #{__MODULE__}.get_attribute [tag: "span", text: "Text", attr: [id: "abc", class: "example"]]
  ```

  ### Result

  ```
  id="abc" class="example"
  ```
  """
  @spec get_attribute(Keyword.t) :: List.t
  def get_attribute(item) do
    cond do
      has_key?(item, :attr) -> " " <> render_attribute item[:attr]
      true -> ""
    end
  end

  defp render_attribute(value) when is_list value do
    for ({k, v}) <- value do render_attribute(v, k) end
    |> Enum.join(" ")
  end

  defp render_attribute(value, attr) when is_binary value do
    ~s(#{attr}="#{value}")
  end

  defp do_wrapp(body, html), do: "#{html[:start]}#{body}#{html[:end]}"

  @doc """
  Check if key exists and value is not empty

  ### Parameters 

   - item: keyword list
   - attr: atom

  ### Example
  
  ```Elixir
  #{__MODULE__}.has_key?([tag: "span", text: "Text", attr: [class: "example"]], :attr)
  ```
  """
  @spec has_key?(Keyword.t, Atom.t) :: boolean
  def has_key?(item, attr) do
    Keyword.has_key?(item, attr) && cond do
      is_list item[attr] -> length(item[attr]) > 0
      is_binary item[attr] -> String.length(item[attr]) > 0
      true -> false
    end
  end
end