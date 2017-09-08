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
    finish()
	end

	defp npm_install do
		cmd("cd #{Path.absname("assets")} && npm install materialize-css --save-dev")
		cmd("cd ../")
		Path.join(~w(node_modules materialize-css dist))
	end

	defp do_assets(npm_dist_path) do
    chek_path(npm_dist_path, "\nTray run: npm install materialize-css --save-dev")

    web_vendor_path = Path.join(~w(assets vendor materialize))
    priv_static_path = Path.join(~w(priv static))

    File.mkdir_p web_vendor_path

    copy_dir_r(npm_dist_path, web_vendor_path, "css")
    copy_dir_r(npm_dist_path, web_vendor_path, "js")
    copy_dir_r(npm_dist_path, priv_static_path, "fonts")
	end

  defp finish do
    Mix.shell.info [:green, "* The materialize-css installed successful! "]
  end

  defp cmd(cmd) do
    Mix.shell.info [:green, "* running ", :reset, cmd]
    case Mix.shell.cmd(cmd, quiet: true) do
      0 ->
        []
      _ ->
        ["$ #{cmd}"]
    end
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
