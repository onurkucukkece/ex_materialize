defmodule Mix.Tasks.Materialize.Install do
	@moduledoc """
	Install materialize package

				mix materialize.install

	"""

	# @shortdoc "Install materialize-css"

	use Mix.Task

	@doc "start task"
	def run(_) do
		IO.puts "Install materialize-css"
		do_run()
	end

	defp do_run do
		npm_install()
		|> do_assets

		do_brunch()
	end

	defp npm_install do
		System.cmd "npm", ["install", "materialize-css", "--save-dev"], into: IO.stream(:stdio, :line), cd: "assets"
		
		npm_dist_path = Path.join(~w(assets node_modules materialize-css dist))
		
		chek_path(npm_dist_path, "\nTray run npm install materialize-css --save-dev")

    npm_dist_path
	end

	defp do_assets(npm_dist_path) do
		web_assets_path = Path.join(~w(priv static))

		File.mkdir_p web_assets_path

		copy_dir_r(npm_dist_path, web_assets_path, "css")
		copy_dir_r(npm_dist_path, web_assets_path, "js")
		copy_dir_r(npm_dist_path, web_assets_path, "fonts")
	end

	defp do_brunch do
		case File.read "assets/brunch-config.js" do
      {:ok, file} ->
        File.write! "assets/brunch-config.js", file <> brunch_instructions()
      error ->
        Mix.raise """
        Could not open brunch-config.js file. #{inspect error}
        """
    end
	end

	def brunch_instructions do
    """
    // To add the materialize generated assets to your brunch build, do the following:
    //
    // Replace
    //
    //     javascripts: {
    //       joinTo: "js/app.js"
    //     },
    //
    // With
    //
    //     javascripts: {
    //       joinTo: {
    //         "js/app.js": /^(web\\/static\\/js)|(node_modules)/,
    //				 "js/materialize.js": ["web/static/vendor/materialize/js/materialize.js"],
    //         "js/materialize.min.js": ["web/static/vendor/materialize/js/materialize.min.js"],
    //       }
    //     },
    //
    // Replace
    //
    //     stylesheets: {
    //       joinTo: "css/app.css",
    //       order: {
    //         after: ["web/static/css/app.css"] // concat app.css last
    //       }
    //     },
    //
    // With
    //
    //     stylesheets: {
    //       joinTo: {
    //         "css/app.css": /^(web\\/static\\/css)/,
    //  			 "css/materialize.css": ["web/static/vendor/materialize/css/materialize.css"],
    //         "css/materialize.min.css": ["web/static/vendor/materialize/css/materialize.min.css"],
    //       },
    //       order: {
    //         after: ["web/static/css/app.css"] // concat app.css last
    //       }
    //     },
    //
    """
  end

	defp copy_dir_r(source_path, dist_path, dir) do
		res_dist_path = Path.join([dist_path, dir])
		
		File.cp_r(Path.join([source_path, dir]), res_dist_path)

		chek_path res_dist_path
	end


	defp chek_path(path) do
		unless File.exists? path do
			Mix.raise """
			Can't find "#{path}"
			"""
		end
	end

	defp chek_path(path, text) do
		unless File.exists? path do
			Mix.raise """
			Can't find "#{path}" #{text}
			"""
		end
	end
end