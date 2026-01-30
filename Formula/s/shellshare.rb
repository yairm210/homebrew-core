class Shellshare < Formula
  desc "Live Terminal Broadcast"
  homepage "https://github.com/vitorbaptista/shellshare"
  url "https://github.com/vitorbaptista/shellshare/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "d6b94a68d075dcf2eaa4d67c27ec5cf0deb07ebe8049675d1b2a79fb02ccc0a6"
  license "Apache-2.0"
  head "https://github.com/vitorbaptista/shellshare.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d339b40374439b9853e4f89cb7a15625c483869312b9c98bbe589b29b160070d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cebc49e7679cdab06822d47bd514d9344f07849c4490c40ea6f1838511f3b77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3d7d78bfb9cb86391a2aecca9da77ff3f0fb9816a66b374302fa94953224f47"
    sha256 cellar: :any_skip_relocation, sonoma:        "591217f933d853e936bd00ca7cdfc4f10294bdb9fceacf91ec20320ceb71442c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f233a63bcfacc3671022d04c523760b613a5822fb6e565d5d89487ab8ff4eca5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32837b0c84bde7c4eeef3c4726616e28036bbc18dcb3caa9b16eea8c7676a2dc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shellshare --version")

    port = free_port

    Open3.popen3(bin/"shellshare", "--server", "http://localhost:#{port}") do |_, stdout, _, w|
      assert_match("Sharing terminal", stdout.readline)
    ensure
      Process.kill "TERM", w.pid
    end
  end
end
