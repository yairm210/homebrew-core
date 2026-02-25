class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://github.com/cpcloud/micasa/archive/refs/tags/v1.51.0.tar.gz"
  sha256 "49c27b4853329de7a51b39ae3252f1bbec21b508b4636b9e34a2dd37a288b685"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56a26437c348790ce1ecacdb80322e4af321f91157f2784972d5d314e7f51ff6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56a26437c348790ce1ecacdb80322e4af321f91157f2784972d5d314e7f51ff6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56a26437c348790ce1ecacdb80322e4af321f91157f2784972d5d314e7f51ff6"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b07afa824128341c33b0668c11d281037b07fcb88bcb997ab8edd6fbbc3d72b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd2098373d90a784fe7fedcc3e25b52ad4af12d734bebecf967731fdc49fac93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4df95c0026c31320083cbefc4bb6fc178b5e0e42ba861b600f92b6b8454c3f5"
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
