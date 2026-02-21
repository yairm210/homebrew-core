class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://github.com/cpcloud/micasa/archive/refs/tags/v1.40.1.tar.gz"
  sha256 "d8bfab12a697bb17591484812d06553a8d79b0077f829021a7fcbcdbd3bc60ef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19962648d98d268bfe0bc0d3aee13f92f151921d408702010fa5d2a5b69fe160"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19962648d98d268bfe0bc0d3aee13f92f151921d408702010fa5d2a5b69fe160"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19962648d98d268bfe0bc0d3aee13f92f151921d408702010fa5d2a5b69fe160"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c5c019879e94aedf9971fba27542c2836b7ab5db2bcfa640bd8629edfd41b88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b517455ccdda0918f183b119db450b6dbad9c5b205230e10ac6f2b6e7b75d8c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b36fcdcfa822f2e757c7978a363ab064cb533e22eab718547588f22f958403f"
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
