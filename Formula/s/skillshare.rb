class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.12.9.tar.gz"
  sha256 "e1635f5460c3507a8ee02215929298e8fa526c6b34fdcaeb19352172ffba1f88"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a1bbc18a690627255c447efd1e09db2d772fa87c1256a8eebcd3dcb57b3cec8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a1bbc18a690627255c447efd1e09db2d772fa87c1256a8eebcd3dcb57b3cec8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a1bbc18a690627255c447efd1e09db2d772fa87c1256a8eebcd3dcb57b3cec8"
    sha256 cellar: :any_skip_relocation, sonoma:        "207b4ab9665291486f2b6f22a3dfa6f16914fb5aedefcb9789ce07cb4c6f381c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fd052c5d3f7be802286f6dcc38d0de26202c2aca46afe24e28c88c3962df8a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac71ce23720c2f31195d5ea67d7e9ff259ad006c2fc55f692d645c8073c17f9a"
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
