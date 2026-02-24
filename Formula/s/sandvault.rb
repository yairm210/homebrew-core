class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.1.22.tar.gz"
  sha256 "b69219962e985ecb8e62c57fd6feb0049ef9a61f0d139715adeaee18aab4bcac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9305e6fbd25c76c1691d9117cc7ae1821418e08e759b45a62c41b6d83340fc5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9305e6fbd25c76c1691d9117cc7ae1821418e08e759b45a62c41b6d83340fc5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9305e6fbd25c76c1691d9117cc7ae1821418e08e759b45a62c41b6d83340fc5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3686baad4e75e0b10e3911a48bbd15d5a412af993c4873897a94392ad80d9870"
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
