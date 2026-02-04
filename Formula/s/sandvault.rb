class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.1.18.tar.gz"
  sha256 "9fdf274b147e3d4f143cfd220cc903fdebf3d955c30e0ae5a63dda77447a439f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be4d5e7f44a6ccbcdd1384ecf92cd7a78a37f12a97a108dacbe4bfac17822784"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be4d5e7f44a6ccbcdd1384ecf92cd7a78a37f12a97a108dacbe4bfac17822784"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be4d5e7f44a6ccbcdd1384ecf92cd7a78a37f12a97a108dacbe4bfac17822784"
    sha256 cellar: :any_skip_relocation, sonoma:        "603a4f35e80d8a18983ee6ad8bbd0139830bb672939663e83f1e89d1c68ba32c"
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
