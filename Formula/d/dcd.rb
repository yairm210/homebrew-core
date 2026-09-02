class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.17.1",
      revision: "b601fdd743bd7690efe479fd3f0dd674b66e6c52"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git", branch: "master"

  bottle do
    sha256               arm64_tahoe:   "eb63b61c6488792b9e0c4e8565e4aeaedbad40c7122d9fe49cf9055f850cf02a"
    sha256               arm64_sequoia: "73293fd69336353e7fa85d6a4acf23f92e1dd75ffd745fa2a2062e5c25ccedc9"
    sha256               arm64_sonoma:  "24352bbe9af0ab884555a7c53eade716f125c651ff2d5977bd9648a01baf11a7"
    sha256 cellar: :any, arm64_linux:   "fc7e365cc62a784d914644910c4bccc8337d370b7207f294507a7b8a3a113352"
    sha256 cellar: :any, x86_64_linux:  "e992cde45b9db7e5dd53d2b6b5f0adda84f7c73705efe72973ad61b4c6527a41"
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
