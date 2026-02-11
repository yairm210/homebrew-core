class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.1.20.tar.gz"
  sha256 "19c213d5cf47d384d8c9a7a965a24a1101ff0bdc8418d4a9558e573bbe81ed49"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb17bc02c7add0f3cd076ec6edd83fde23a0920444caa3a699e662cbb8b7eb3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb17bc02c7add0f3cd076ec6edd83fde23a0920444caa3a699e662cbb8b7eb3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb17bc02c7add0f3cd076ec6edd83fde23a0920444caa3a699e662cbb8b7eb3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbf3a2528eba1de6833dfd2670b514939ab05d888ccbb2e187b9f7ea4e47e58f"
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
