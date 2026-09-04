class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.17.8",
      revision: "a3dbfa882f262cca3a8e3ab7abfc83258108f873"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git", branch: "master"

  bottle do
    sha256               arm64_tahoe:   "e9d074aaf0461b2909f9467b3267f49b469355d2ad5592e6deb22e2a6343d73b"
    sha256               arm64_sequoia: "bc953821725ff9727a4ae05c847407de160c22f4385276d22d76a197dbe42aeb"
    sha256               arm64_sonoma:  "9d4f5b20380067ebc2051cea92615f31dfe9eb042e556a41a91e3eef94ebdae0"
    sha256 cellar: :any, arm64_linux:   "367a01772d4a7ce797249606a11c29117e1c7ad4a064a58683a7e84141b77d2d"
    sha256 cellar: :any, x86_64_linux:  "7dc569c71b06fbf958d2cfca9d4877dc4fa72d748b137be5f9eb86585d8f340f"
  end

  depends_on "ldc" => :build

  def install
    system "make", "ldc"
    bin.install "bin/dcd-client", "bin/dcd-server"
  end

  test do
    port = free_port

    # spawn a server, using a non-default port to avoid
    # clashes with pre-existing dcd-server instances
    server = spawn bin/"dcd-server", "-p", port.to_s
    # Give it generous time to load
    sleep 0.5
    # query the server from a client
    system bin/"dcd-client", "-q", "-p", port.to_s
  ensure
    Process.kill "TERM", server
    Process.wait server
  end
end
