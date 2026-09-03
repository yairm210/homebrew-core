class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://github.com/openclaw/gogcli/archive/refs/tags/v0.38.3.tar.gz"
  sha256 "6304beb89417d743922e4fd4edca7489a6b1320a3e3070d05f7376939753636b"
  license "MIT"
  head "https://github.com/openclaw/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00a06fc902be1398c93ed460150bfdd9c90b57fe61ee55e500752693e7fcc702"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1daa0b450d27e9fb26341b4702b51f24a1c2b16c7715e0b9f1166612ee25fff6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae82c2fd243aed254c895c123d66d644c5189544ed9cbf01450ce27c706ae620"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48de3542f6d44a623d848246e269479dfb06b338679bb197ae7b6d8af507c3dd"
    sha256 cellar: :any,                 x86_64_linux:  "311b5435de6c115b2174e8e432f0cd589d10868abf70bbe223991b61fdf60e06"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/steipete/gogcli/internal/cmd.version=#{version}
      -X github.com/steipete/gogcli/internal/cmd.commit=#{tap.user}
      -X github.com/steipete/gogcli/internal/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"gog"), "./cmd/gog"

    generate_completions_from_executable(bin/"gog", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gog --version")

    ENV["GOG_ACCOUNT"] = "example@example.com"
    output = shell_output("#{bin}/gog drive ls 2>&1", 10)
    assert_match "OAuth client credentials missing", output
  end
end
