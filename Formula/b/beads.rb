class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://github.com/steveyegge/beads/archive/refs/tags/v0.55.1.tar.gz"
  sha256 "889c80fcfafb844ba2bf466c5109d888b5095b0a64575936afe661e68ec5908a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "17fcca38532b06ade71e69f5a6b5ef659bcf2abc973422f8acc16eddfa030501"
    sha256 cellar: :any,                 arm64_sequoia: "789b6752f4bb2e3f11920063092770ab6b8c165aadf7361a623498452599a512"
    sha256 cellar: :any,                 arm64_sonoma:  "fe2627fb04236bc17f16a76398d9b785ad6d1750426b256fba3fdaf91033098f"
    sha256 cellar: :any,                 sonoma:        "5760a0f61f33ab5d5cbb6011a2adad69191a4c798884fcf5e535e419abc76eeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10f2da7b5848d3344889b688187906a84590691dc08ace65933bb94708bffc08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d41c731aa35e90d3b963741e65423ebabbd40b90d8a56534a516dbf28f4d9246"
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
