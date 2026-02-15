class Iproute2mac < Formula
  include Language::Python::Shebang

  desc "CLI wrapper for basic network utilities on macOS - ip command"
  homepage "https://github.com/brona/iproute2mac"
  url "https://github.com/brona/iproute2mac/releases/download/v1.7.0/iproute2mac-1.7.0.tar.gz"
  sha256 "48bd7b0a6e9a8015dde2cf30f54f42750ffb5ac2f60a47530c7c6205d23a257e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a2e962a30265ba70ff55de27f31a494d54dcf027c304f6a97d2e0d2beea8f323"
  end

  depends_on :macos
  depends_on "python@3.14"

  def install
    libexec.install "src/iproute2mac.py"
    libexec.install "src/ip.py" => "ip"
    libexec.install "src/bridge.py" => "bridge"
    rewrite_shebang detected_python_shebang, libexec/"ip", libexec/"bridge", libexec/"iproute2mac.py"
    bin.write_exec_script (libexec/"ip"), (libexec/"bridge")
  end

  test do
    system "/sbin/ifconfig -v -a 2>/dev/null"
    system bin/"ip", "route"
    system bin/"ip", "address"
    system bin/"ip", "neigh"
    system bin/"bridge", "link"
  end
end
