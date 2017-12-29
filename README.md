# Materialize

This package install [materialize-css](http://materializecss.com/getting-started.html) to you project. 

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `materialize` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:materialize, "~> 0.1.1"}]
end
```

Next you need get deps:

```shell
$ mix deps.get
```

And run mix task:

```shell
$ mix materialize.install
```

### Result

Task **materialize.install** do next:

* npm - run npm install materialize-css --save-dev
* dist - copy js, css files to *web/static/vendor/materialize*
* fonts  - copy dir fonts to *web/static/assets*
* brunch - append instructions to brunch-config.js

After install you have next structure:

		project_dir
		...
		|--priv
		    |--static
		        |--css
		            |--materialize.css
		            |--materialize.min.css
		        |--js
		            |--materialize.js
		            |--materialize.min.js
		...
		
		|--assets
		    |--vendor
			|--materialize
			   |--css
			       |--materialize.css
			       |--materialize.min.css
			   |--fonts
			   |--js
			       |--materialize.js
			       |--materialize.min.js
		...
		
Use **materialize-css** in you template project:
 
```Elixir
	# web/templates/layout/app.html.eex
	
	<link rel="stylesheet" href="<%= static_path(@conn, "/css/materialize.css") %>">
	
	# Add it below the script tag for app.js
	<script src="<%= static_path(@conn, "/js/materialize.js") %>"></script>
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/materialize](https://hexdocs.pm/materialize).

