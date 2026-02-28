class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.16.5.tar.gz"
  sha256 "5b6b046a4b759632a79f1cdc6ba173353fdd10e0a23e54cf331c51c1da6a2d4f"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8d867f0debdceb8275df6783678307bdd6930f0f67293bec2b498347b24a69e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8d867f0debdceb8275df6783678307bdd6930f0f67293bec2b498347b24a69e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8d867f0debdceb8275df6783678307bdd6930f0f67293bec2b498347b24a69e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5954185ba8dccb703be268446d8cec2d690c82f230a6c2e33c6678a4579528c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "291db2f136fc4c8370aa2d4cc4c7edb5aeb327e71695429da12631bafbce26fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6747f9a3166d7e22b2aaca712bd0b5fe90f0393221e5821112fd798d730697f"
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
