class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://github.com/cpcloud/micasa/archive/refs/tags/v1.45.0.tar.gz"
  sha256 "ac767e3f195d48e3988e60269eea2ca0c26362b754720a264c16c4f6d5518b21"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80866ee137c77bacb6ff42fbaab28e73bc8bb0b90b1e02c1a63312db05ce7889"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80866ee137c77bacb6ff42fbaab28e73bc8bb0b90b1e02c1a63312db05ce7889"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80866ee137c77bacb6ff42fbaab28e73bc8bb0b90b1e02c1a63312db05ce7889"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a91ae82d44c3906db6daa04c1ad8ab1d9d5b9f0cb926f4e67561d3ece7e3a0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1e820a0e62730e813ec168f32e54399b55ecfaf47bc7f603e282ab78b561739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a524b055b0121f1f0b495fa0ec478257f92efcfbd8ce5f6bc6ad63c14ac2bfd6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/micasa"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micasa --version")

    # The program is a TUI so we need to spawn it and close the process after it creates the database file.
    pid = spawn(bin/"micasa", "--demo", testpath/"demo.db")
    sleep 3
    Process.kill("TERM", pid)
    Process.wait(pid)

    assert_path_exists testpath/"demo.db"
  end
end
