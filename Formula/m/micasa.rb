class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://github.com/cpcloud/micasa/archive/refs/tags/v1.41.2.tar.gz"
  sha256 "4b90c3082ef9e584e318270331314fb612665830225df3317dc14febd5058ad9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2090c188c2c8fee832b8959bd634a5bfaf50db55661eaaf765bf5ac2e63e24fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2090c188c2c8fee832b8959bd634a5bfaf50db55661eaaf765bf5ac2e63e24fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2090c188c2c8fee832b8959bd634a5bfaf50db55661eaaf765bf5ac2e63e24fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "aaa55af33bb3aba1aef8ac6e94d81fbdb9a778b99869b25ae9cb74694a019d4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85f1dedcc498f19cfa264061bd1662177d72d023742f36de7333095a668bcf0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2d3f46b7fe01dd0212047c139a8e6183f5d0516224c5ab12d770577e4b7dd82"
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
