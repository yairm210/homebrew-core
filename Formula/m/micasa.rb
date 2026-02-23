class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://github.com/cpcloud/micasa/archive/refs/tags/v1.49.1.tar.gz"
  sha256 "49d336756a9411f4127142920569baa2c8210987a8c75fb17cb1b6405d07b1c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7346db9f1e8efa0b7efd319074435973c4ec4d55ebe7d1189a36e2269ecd1127"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7346db9f1e8efa0b7efd319074435973c4ec4d55ebe7d1189a36e2269ecd1127"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7346db9f1e8efa0b7efd319074435973c4ec4d55ebe7d1189a36e2269ecd1127"
    sha256 cellar: :any_skip_relocation, sonoma:        "b212d9c0fc6a1ae121b0f3d3a66217b818adfa48a21f9d717903e7a47cd53e34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51db4ee1024d366619dd4f6a002046adecccf1986c9165ddbf13d725712c4dcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "609a3a835789973d4540347f68b4cb69ef0016812e0da5dfaa53462a602c6cac"
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
