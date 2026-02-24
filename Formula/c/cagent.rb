class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "4e7b55d1f9b029e72f2b23990e8d0186b6605cb86fc72ade9e8d43bfea3c6a19"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1881c8b7acfb636f3eec7cc9e0a7756d68f707b11cf6710680e15c9585d8e9ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee6ee3de023c9ce244f3c5f35794aec08cf2b2efa64e7c4260c60985caec0b51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fd1a481527b493c8d714810d09fbc341fc274c1120b73410c235ba688d30459"
    sha256 cellar: :any_skip_relocation, sonoma:        "123a91b78ccd734af8c465dc08e35b3035ba1b0f14397066453b9460be7daab1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fa856b046e6fda89f80f0adafc7e02aa26bfa0c14a5c2258a6ded53720155ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17ace1eb0cfaa38d001cc5e44358879d026a4d8ce003064536f5ca7d2afe9d74"
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

    assert_match version.to_s, shell_output("#{bin}/cagent version")
    assert_match "UNAUTHORIZED: authentication required",
      shell_output("#{bin}/cagent exec --dry-run agent.yaml hello 2>&1", 1)
  end
end
