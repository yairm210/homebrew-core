class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://github.com/steveyegge/beads/archive/refs/tags/v0.49.5.tar.gz"
  sha256 "4e94e65e56ba1c8cddb22aefa0857dc7f1c2c6df8b3a840300170b3a8323004d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2296ceb46cf00c9c602b9de149c2869810629e31301ac06b337f4eda6ba4c9a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2296ceb46cf00c9c602b9de149c2869810629e31301ac06b337f4eda6ba4c9a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2296ceb46cf00c9c602b9de149c2869810629e31301ac06b337f4eda6ba4c9a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "66edb0dc5215b36952c2b2ad884b32b9278701c5a1ebbe3a927e7595d9c523e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bd49e5d3bfaea16929559f2de0fccce566238c1270a133ec69029baf6f7b5c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d5f8f41282ed0a3aee87f1daf9586cdabdce77374adec0bf4e34bd15003e4bf"
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
    assert_match "Connected: yes", output
  end
end
