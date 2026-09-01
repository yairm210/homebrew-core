class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.17.0",
      revision: "10be6833e8f0ed8d1fc541fd65a3b5ca67b2a158"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git", branch: "master"

  bottle do
    sha256               arm64_tahoe:   "4f9db6ee1639fdb78113639e4a9bb4539074dd717678635c4c916a16166048e7"
    sha256               arm64_sequoia: "150edc8d3268fa15abe3271cc0cc8e21e988ef0efe071964a3544127392537e8"
    sha256               arm64_sonoma:  "4d0a3da9b421074b28aba9a91786da60e64786b5984e31cc9c38d85beb5a1af5"
    sha256 cellar: :any, arm64_linux:   "8bd0b1f1aa04ede0dd550022e6f423bb77fdab6e7acebb9df0cb2871e2dda821"
    sha256 cellar: :any, x86_64_linux:  "820bb623f2850d6e07fcf0290f64fde96ff14706354a73f22bf3f871cf381db3"
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
