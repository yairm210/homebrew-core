class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "7373f1504d1799b6ecf51476d4041290f254b69c1aab79aa0b678cc8df7a9166"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6473bef53ad899dc520f500560c4d3f76cfeb68b7ebaf503851e20b41c2016d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6473bef53ad899dc520f500560c4d3f76cfeb68b7ebaf503851e20b41c2016d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6473bef53ad899dc520f500560c4d3f76cfeb68b7ebaf503851e20b41c2016d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "62c27bbadf542a5184c9e3f23f458d2ed9b68ee82c2bab8e9589c49b3f5d08cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c60fb6d88f069920719e9b79f0e279a26f4fe1585d29e39ef59a510549cdefd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8000b4a483233dd16351a8508066074900772b8ae124698502e999880dc2d71"
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
