class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.1.16.tar.gz"
  sha256 "65ebce52010d34f4a708844113bbeb060dad6e78c0f39f58d271f37c2dfb8a35"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f2db52ec4756f04cc22386a74371b44a278b697bb842ce8c9d916375cd1ba5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f2db52ec4756f04cc22386a74371b44a278b697bb842ce8c9d916375cd1ba5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f2db52ec4756f04cc22386a74371b44a278b697bb842ce8c9d916375cd1ba5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a00e1a3dcb476fedf3f8e7f29bc31ba86d99b7e05d641667d0654c8cd18c68e"
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
