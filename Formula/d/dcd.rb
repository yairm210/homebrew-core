class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.17.3",
      revision: "b8f391fbfc4950783689fed97c70713cad17fe55"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git", branch: "master"

  bottle do
    sha256               arm64_tahoe:   "6c1ce1367ce4812243a4ee45f2b5e1c2a9bd46811a3557f4f7fc166f85bcaab0"
    sha256               arm64_sequoia: "02e56a9bd8517f62992d8707db797eb67c7cd87601d22d5854fc981a91203806"
    sha256               arm64_sonoma:  "b2063a4ace757119cc1f1c578804fe4512692c04ff7a6738b3a631d648c471b5"
    sha256 cellar: :any, arm64_linux:   "67625d46a0f3436896ddd95c45773167bb02ffa2d7f913b198bb35a6f8953589"
    sha256 cellar: :any, x86_64_linux:  "1720e09492588561a8c732561b851ffd62900ab048ad85d365c60155950624f6"
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
