class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.1.15.tar.gz"
  sha256 "f20aab81e118f4d6a34ba639d29dbc868ec40e03043361111b5f7cf0814ee74f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "278e1ab425cf0d72b19a2b00f0a281028f4841afebcd845ff29d2f1c58071420"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "278e1ab425cf0d72b19a2b00f0a281028f4841afebcd845ff29d2f1c58071420"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "278e1ab425cf0d72b19a2b00f0a281028f4841afebcd845ff29d2f1c58071420"
    sha256 cellar: :any_skip_relocation, sonoma:        "6999f630a9f4aef69a1c9a1a3f95b9ab5cb5a5412e0b19d45b46b3e7a6712e1b"
  end

  depends_on :macos

  def install
    prefix.install "guest", "sv"
    bin.write_exec_script "#{prefix}/sv"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end
