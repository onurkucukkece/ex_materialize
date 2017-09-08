defmodule Mix.Tasks.Materialize.Install do
	@moduledoc """
	Install materialize package

	```shell
  $ mix materialize.install
  ```

	Change the file **brunch-config.js** following the instructions into this file.
	And run brunch build:

	```shell
  node node_modules/brunch/bin/brunch build
  ```

	"""

	# @shortdoc "Install materialize-css"

	use Mix.Task

	@doc "start task"
	def run(_) do
		IO.puts "Install materialize-css"
		do_run()
	end

	defp do_run do
		npm_install() |> do_assets()
		#do_brunch()
	end

	defp npm_install do
		System.cmd "npm", ["install", "materialize-css", "--save-dev"], into: IO.stream(:stdio, :line)
		Path.join(~w(node_modules materialize-css dist))
	end

	defp do_assets(npm_dist_path) do
    chek_path(npm_dist_path, "\nTray run: npm install materialize-css --save-dev")

		web_assets_path = Path.join(~w(assets))
    web_vendor_path = Path.join(~w(assets vendor materialize))
    web_static_path = Path.join(~w(assets static))

    File.mkdir_p web_vendor_path

    copy_dir_r(npm_dist_path, web_vendor_path, "css")
    copy_dir_r(npm_dist_path, web_vendor_path, "js")
    #copy_dir_r(npm_dist_path, web_assets_path, "fonts")
    copy_dir_r(npm_dist_path, web_vendor_path, "fonts")
	end

  defp finish do
    IO.puts "The materialize-css installed successful!"
  end

	defp do_brunch do
		case File.read "brunch-config.js" do
      {:ok, file} ->
        File.write! "brunch-config.js", file <> brunch_instructions()
        IO.puts """
				Change brunch-config.js and run: \n
				node_modules/brunch/bin/brunch build
				"""
      error ->
        Mix.raise """
        Could not open brunch-config.js file. #{inspect error}
        """
    end
	end

	defp brunch_instructions do
    """

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

#	defp raise_arg(arg) do
#    Mix.raise """
#    Invalid option --#{arg}
#    """
#  end
end
