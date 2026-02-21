class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://github.com/cpcloud/micasa/archive/refs/tags/v1.40.1.tar.gz"
  sha256 "d8bfab12a697bb17591484812d06553a8d79b0077f829021a7fcbcdbd3bc60ef"
  license "Apache-2.0"

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
