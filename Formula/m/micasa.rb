class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://github.com/cpcloud/micasa/archive/refs/tags/v1.54.2.tar.gz"
  sha256 "c09a3f195eb351e0c55bdbd9dbfdf50b4fe4eb960df74afd4942ef17533e3d80"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba536c54cb69ac8b719d8df67cfe2a77fe623b4eb958e1093bfdc8e03fa109f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba536c54cb69ac8b719d8df67cfe2a77fe623b4eb958e1093bfdc8e03fa109f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba536c54cb69ac8b719d8df67cfe2a77fe623b4eb958e1093bfdc8e03fa109f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "47a7d2b1b09b509d85c439b59832fc683ffecf159fa84364185785416c0b2342"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89c0964b0e47a16226801c312bb28782effce0364b2b1788a477367c1f54aeed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6de0376b9acd99ca38165df189c6fed1bd52c28794455f5452f299b6b73c03e6"
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
