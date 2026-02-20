class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://github.com/steveyegge/beads/archive/refs/tags/v0.55.1.tar.gz"
  sha256 "889c80fcfafb844ba2bf466c5109d888b5095b0a64575936afe661e68ec5908a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a2bef2ab52c2621d52e5de7818c63ed454e25d3313408efb5cb8d6c957037fd0"
    sha256 cellar: :any,                 arm64_sequoia: "e202de78063c300e11bb49dd9ab0815b2555a34971eb76e813b08114b60f1f1b"
    sha256 cellar: :any,                 arm64_sonoma:  "8a0e9fd1cba0f1ca64e74f1365aca1547f7716f6848037487866208c8de49c5b"
    sha256 cellar: :any,                 sonoma:        "dd4c4f9a49034495ebe44ac8c8c2d08813a01cb4ebf54312b027247dc090a731"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11c6f089fc2ca8b8e517d0fc6ad3f02bad9c57406eee2985a1e1d3973745b91f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8405e7d2c28a4cf4add6b91d27be55e10d73bc1b059fb066279be16f1b69acb"
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
