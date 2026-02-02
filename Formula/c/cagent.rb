class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.20.3.tar.gz"
  sha256 "0d7a49d09ad666b216a4053402c670a2ab586b1eafc70a1cd2eec433b8b6e4cd"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "206228e958e20d1d6c41ebc9b0c884497808db9fd87aaa652629af6baf70a9a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eddcf739c3f818742259e97ee1983bdc8ace955ff97d2d3a40d0186389106523"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e6352284b29e37f9689452886caf62b60084c7f5d88e91c540d7d413b14dfc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c965b0bf6e61a85f7e57feb0f2c625623d4206dc27aa4bde3f1f5f22e8744fc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "244fdd1d6971fb375b5c079902290a7718173975113e47bb50524f161cfa3dc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9698cd7f76d14af728e72c378a68abbaeadf2f456491670320d4677434d97ca4"
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
    assert_match(/must be set.*OPENAI_API_KEY/m, shell_output("#{bin}/cagent exec --dry-run agent.yaml 2>&1", 1))
  end
end
