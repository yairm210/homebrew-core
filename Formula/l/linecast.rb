class Linecast < Formula
  include Language::Python::Virtualenv

  desc "Weather, tides, the sun, the moon, and maps, drawn for the terminal"
  homepage "https://github.com/ashuttl/linecast"
  url "https://files.pythonhosted.org/packages/e0/f2/86af9d157d9da840720ed6641ab4b95808463b03e9dcf12bb4e793517eef/linecast-2.3.1.tar.gz"
  sha256 "857e34fe2a92670e2c7c0a0e2913a748527b48e470859003a50e7e1f3d6e2513"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c342342bd76fcf8848bf073fc3b748e85ded3fa6069b07790cb1f4b1a97757ad"
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
