class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://github.com/steveyegge/beads/archive/refs/tags/v0.55.2.tar.gz"
  sha256 "8d013a55e541f88f0e0ff232fd4677ef116e86a730cbb6869230c0b36fe9c155"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4b4ee7b95929b67850b5d2e8e4d2fc60bbd338afda74584b241457357cf903fd"
    sha256 cellar: :any,                 arm64_sequoia: "4bf1e897918379788e1e90c0e9ccba547ec8935d15bc8b9f4cd5e3e3bdd31fab"
    sha256 cellar: :any,                 arm64_sonoma:  "41d84e46d4d80b8a58a4de2598e0fecfee539e72003ecae71621d60a16aaa87b"
    sha256 cellar: :any,                 sonoma:        "ff486d6e859e4ec33705bf4ebe4cb7fa7b34d902b0f6ba48b54c24e11f6f8f8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b44cf40d58bbc4b6365148b57f3a505e0bbe709ad90ea820dbe5d5cb40a54a10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39f67604ef895dd8f602586a9393eb44137c0a9d2d8eb1098a719f8d7ed196ab"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    if OS.linux? && Hardware::CPU.arm64?
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Build=#{tap.user}
      -X main.Commit=#{tap.user}
      -X main.Branch=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/bd"
    bin.install_symlink "beads" => "bd"

    generate_completions_from_executable(bin/"bd", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bd --version")

    system "git", "init"

    shell_output("#{bin}/bd init < /dev/null")
    assert_path_exists testpath/"AGENTS.md"

    output = shell_output("#{bin}/bd info")
    assert_match "Beads Database Information", output
    assert_match "Mode: direct", output
  end
end
