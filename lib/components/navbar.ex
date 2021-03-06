defmodule Materialize.Components.Navbar do
  @moduledoc """
  Use module for generate HTML block navbar.

  Add alias in **/web/views/layout_view.ex** with configuration navbar:
  
  ```Elixir
  alias #{__MODULE__}

  def navbar do
    [
      wrrape: [attr: [class: "nav-wrapper"]],
      logo: [href: "#", text: "Logo", attr: [class: "brand-logo"]],
      items: [
        [tag: "ul", attr: [id: "nav-mobile", class: "right hide-on-med-and-down"], items: [
          [tag: "a", text: "list 1", attr: [href: "#1"]],
          [tag: "a", text: "list 2", attr: [href: "#2"]]
        ]]
      ]
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

  @wrapper_options [attr: [class: "nav-wrapper"]]
  @logo_options [tag: "a", text: "Logo", attr: [href: "#", class: "brand-logo"]]
  @items_options [tag: "ul", attr: [id: "nav-mobile", class: "right hide-on-med-and-down"]]

  # defstruct [wrapper: @wrapper_options, logo: @logo_options]

  @doc """
  Create tag **span** or etc.
  
  ### Parameters

    - options: keyword list

  ### Example

  ```Elixie
  #{__MODULE__}.get_html([
      wrrape: [attr: [class: "nav-wrapper"]],
      logo: [href: "#", text: "Logo", attr: [class: "brand-logo"]],
      items: [
        [tag: "ul", attr: [id: "nav-mobile", class: "right hide-on-med-and-down"], items: [
          [tag: "a", text: "list 1", attr: [href: "#1"]],
          [tag: "a", text: "list 2", attr: [href: "#2"]]
        ]]
      ]
    ])
  ```
  """
  @spec get_html(Keyword.t) :: List.t
	def get_html(options) do
    options = check_options options
    attr = Html.get_attribute options[:wrapper]
    logo = Html.get_tag(options[:logo])
    [start: "<div#{attr}>#{logo}", end: "</div>"]
    |> get_items(options[:items])
  end

  defp get_items(html, options) when is_list options do
    for item <- options do 
      cond do
        Html.has_key?(item, :items) -> 
          item 
          |> check_list() 
          |> Html.get_list()
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
    |> check_wrapper()
    |> check_logo()
    |> Map.to_list()
  end

  defp check_wrapper(options) do
    wrapper = 
    cond do
      Map.has_key?(options, :wrapper) -> 
        options  
        |> Map.fetch!(:wrapper)
        |> Enum.into(%{})
        |> Map.put_new(:attr, @wrapper_options[:attr])
        |> Map.to_list()
      true -> @wrapper_options
    end
    Map.put_new(options, :wrapper, wrapper)
  end

  defp check_logo(options) do
    logo = 
    cond do
      Map.has_key?(options, :logo) -> 
        options  
        |> Map.fetch!(:logo)
        |> Enum.into(%{})
        |> Map.put_new(:tag, @logo_options[:tag])
        |> Map.put_new(:text, @logo_options[:text])
        |> Map.put_new(:attr, @logo_options[:attr])
        |> Map.to_list()
      true -> @logo_options
    end
    Map.put_new(options, :logo, logo)
  end

  defp check_list(item) do
    item = Enum.into(item, %{})
    
    attr = cond do 
      Map.has_key?(item, :attr) -> 
        item[:attr]
        |> Enum.into(%{})
        |> Map.put_new(:id, @items_options[:attr][:id])
        |> Map.put_new(:class, @items_options[:attr][:class])
        |> Map.to_list()
      true -> @items_options[:attr]
    end
    Map.put(item, :attr, attr)
    |> Map.put_new(:tag, @items_options[:tag])
    |> Map.to_list()
  end
end