class Linecast < Formula
  include Language::Python::Virtualenv

  desc "Weather, tides, the sun, the moon, and maps, drawn for the terminal"
  homepage "https://github.com/ashuttl/linecast"
  url "https://files.pythonhosted.org/packages/01/e4/f4d19f2f4c799017c3c8d3b1100c3dc7ca6ac1d0c20c1c2d27a9e97f2930/linecast-2.2.2.tar.gz"
  sha256 "7a18100d59c9d1720fbb06bdb93dc427735a51c854cc3324c3aea5649fec9797"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ccbf3c546b331d502f944a4b996bae687dc70b8f34267c7950eefbde79c5b695"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/linecast --version")

    output = shell_output("#{bin}/linecast sunshine --location 43.657,-70.258 --json")
    assert_match '"schema": 1', output
    assert_match '"sunrise":', output
    assert_match '"sunset":', output
  end
end
