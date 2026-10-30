class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "96e87f1f82d5d0ca0048b61fe87ecee6217e8b77ca8ad1a155d938369ed254f7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "924e98ce47fdb7b2ddbb8846d7679e12374babf157f16b2c4c0b1eab2daac319"
  end

  depends_on :macos

  conflicts_with "runit", because: "both install `sv` binaries"

  deny_network_access!

  def install
    libexec.install "guest", "helpers", "skills", "sv", "sv-clone", "sv-agentsview-setup"
    bin.write_exec_script libexec/"sv", libexec/"sv-clone", libexec/"sv-agentsview-setup"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end
