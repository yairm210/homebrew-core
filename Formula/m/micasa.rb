class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://github.com/cpcloud/micasa/archive/refs/tags/v1.44.1.tar.gz"
  sha256 "baea4899851b1f8c2d351692d7125f9fc38d2d639c141e3b42b290a7d7b800f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b414610232f462f4cc2b84480a488fde1c2fb9d626a877ff7f7191b5845577c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b414610232f462f4cc2b84480a488fde1c2fb9d626a877ff7f7191b5845577c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b414610232f462f4cc2b84480a488fde1c2fb9d626a877ff7f7191b5845577c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "92625c3710abd88d7ec629f70c06f75b907a02af2517eb85b9d643b82412e94c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67130db640abeef4a454b9d6677bc7fd8c8c4ae3aa932cef3f2f27bade94fbf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51a2c2330a8b01915852299fb22086eaf920b548413067c7a87b7b0ada5352d5"
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
