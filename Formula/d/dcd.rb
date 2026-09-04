class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.17.7",
      revision: "98cfc03ff86cf3528d39a1cc12856121d9a98381"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git", branch: "master"

  bottle do
    sha256               arm64_tahoe:   "c63853fe37ff037ee1b65e817a184057a773934a9954e3067bedb61841897f2e"
    sha256               arm64_sequoia: "2358aea626895fbf4f272a49110dc3eda2275376219e9ce3a02a625c676706c3"
    sha256               arm64_sonoma:  "b26139b5c8079a421ea71af6f8acca4fb4491291a61819bc80ae8c56140c8f3d"
    sha256 cellar: :any, arm64_linux:   "953c484c7cac43852e46c2cfbcae7b072585acb4473d7f46fff5f7844887c30b"
    sha256 cellar: :any, x86_64_linux:  "be1efed97b2e68d429331a5cb22756f8d0b77a9ff4f6d31232b2a512a5f202a8"
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
