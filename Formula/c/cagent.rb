class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "cffcee722e69ecb8111fda9e6f8e6d46da09299a57b74f11982780a5ecd27e90"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b1887064fb094c17ff6b5bb4e8d668f9dc4807dd23676be30c6bf747ca5d0e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7ccae464a10d3ca3428d44fdafb45ce50c17c8203e4cd31830167a129988e20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98e1a6d13a316538d0022d7a36f8ff1522dd823d45e5fccb15a32537dc4c5ec4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef9dbbf51695463ab1eab63f1a3ad02685cf61a6930253f93baf2fe26462c7ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5b7cffee769db8cf3b1a83409f85a6c6c947ad104025ef7d413c097765d5a14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae42b19b628f598a3d06e7e4c7e853135babcfe0ff387ce7fe4f02fbf07c62f9"
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
