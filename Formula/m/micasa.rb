class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://github.com/cpcloud/micasa/archive/refs/tags/v1.51.0.tar.gz"
  sha256 "49c27b4853329de7a51b39ae3252f1bbec21b508b4636b9e34a2dd37a288b685"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca1dba8a75c388589943e7c8c0a224a022af28660123320afea349fc062542ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca1dba8a75c388589943e7c8c0a224a022af28660123320afea349fc062542ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca1dba8a75c388589943e7c8c0a224a022af28660123320afea349fc062542ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ea9e8a0f4c07ab66eeae297386b42dbbf8c6afb17d4d32a928892f949249ac6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fd7bea5953bc761bd607a8082941918bbbc723e0605a86082963533d1cb5f73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9857df8535b68dae0a7d4b48f570e95fbdeb3d43052f8ba65b308897bfa3205"
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
