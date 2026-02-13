class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.12.7.tar.gz"
  sha256 "ae6f01d78ecbb59002cb562f60fa629a2fa8552c116fe7e71f3c49efd5996f01"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "290729467da0ee35a84d7052b87cb7dbc21c250496ae9d5a44d6889f8de3a1b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "290729467da0ee35a84d7052b87cb7dbc21c250496ae9d5a44d6889f8de3a1b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "290729467da0ee35a84d7052b87cb7dbc21c250496ae9d5a44d6889f8de3a1b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c493cb4f6f5f6ec584818a34a07856b49e70fef879c175486a7a4d822d37ffb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e03453b04194b8db2abf7546c82067a5bb14d584943236e2f4a0eaeeafd5a77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "667cc9f8fb449ac9f71015ed1dda9f7f2a21ed5c1394161b7fd3be58494cea14"
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
