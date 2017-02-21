defmodule Materialize.Mixfile do
  use Mix.Project

  @version "0.1.2-dev"

  def project do
    [app: :materialize,
     version: @version,
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     name: "Materialize",
     docs: [extras: ["README.md"], main: "Materialize"],
     description: description(),
     package: package()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev}]
  end

  defp description do
    """
    Add the materialize-css package to your project.
    """
  end

  defp package do
    [# These are the default files included in the package
     name: :materialize,
     files: ["lib", "mix.exs", "README*", "LICENSE*"],
     maintainers: ["Mistim", "Mikhail Oslovskiy"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/mistim/ex_materialize"}]
  end
end
