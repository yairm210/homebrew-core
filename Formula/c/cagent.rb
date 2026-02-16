class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.23.3.tar.gz"
  sha256 "b07c92e7bc6adaf725f9212e0828a1a0da1ca2d9b85d6edb43d4e2f643203ba9"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c7468b4e8f779ab0921faed4568a96c4799a12358c546ffe22759776f6739c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e6c48ae60be409bcbb9fe627117ba606cd1e72397c79021ca188e5e9bd20254"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c5eacb885a11c3e793592be4125d162eacfc64c640140ced657109e1778f416"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5b24dc2bca76e7556e21f7a64cefb0236c8a128e7884e0bd153cbf201ed439a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dc0a34a267bac63fbe33e51c404e1d6f13ace13788ad1907210051f2985dde9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d8314674ca3c4323c9e0916276aaaa80d91fcb04d1fe30b77f42cdd76c2c74e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/docker/cagent/pkg/version.Version=v#{version}
      -X github.com/docker/cagent/pkg/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cagent", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"agent.yaml").write <<~YAML
      version: "2"
      agents:
        root:
          model: openai/gpt-4o
    YAML

    assert_match("cagent version v#{version}", shell_output("#{bin}/cagent version"))
    output = shell_output("#{bin}/cagent exec --dry-run agent.yaml hello 2>&1", 1)
    assert_match(/must be set.*OPENAI_API_KEY/m, output)
  end
end
