class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.1.16.tar.gz"
  sha256 "65ebce52010d34f4a708844113bbeb060dad6e78c0f39f58d271f37c2dfb8a35"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0d2dd2f55c22b2562ea3a0e41e48b8d9613663c84751b15d6a3b9987e4e2f52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0d2dd2f55c22b2562ea3a0e41e48b8d9613663c84751b15d6a3b9987e4e2f52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0d2dd2f55c22b2562ea3a0e41e48b8d9613663c84751b15d6a3b9987e4e2f52"
    sha256 cellar: :any_skip_relocation, sonoma:        "65ce5009392ea2f4db0421fbbf434d06db00be64e5e98635925e2c0d6829eea7"
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
