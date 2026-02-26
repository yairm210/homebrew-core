class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "959ead62fc26415149b2a21876c24c261102b6505b01907aa9c7fd1c32f8c000"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47900bb3ef1e87ebcfb10a30e5d6f1972d2d33d8043416d1a86e31aec4ac2dde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47900bb3ef1e87ebcfb10a30e5d6f1972d2d33d8043416d1a86e31aec4ac2dde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47900bb3ef1e87ebcfb10a30e5d6f1972d2d33d8043416d1a86e31aec4ac2dde"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8eb4e9e784af1ca9591c4a64c3a617162a8acc714839afc95946e3ce64dafc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8760ab73266878e607e0c9f40d0a1ef1d359475f6cdf0ad9e16dc7b260abb88a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "feeaf1f4fdf172feeddaa26200c4d335673062d9002fb52a382aa809cf1e3a4d"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end
