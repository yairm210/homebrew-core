class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.20.2.tar.gz"
  sha256 "4b4902f126bef427f3a6fc18aafd11f364a2980b189fa219751c14f9077fe2ae"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "188f080ca8e3fec920b43f6111eed822855062409b8fdcf2103ad1752ddb94e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e044d6ebd09fdf9e633ae38c72617366838ff1658b7e09d442b83958c3fe750"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6888e33ea4a532adea7f9e6401159c6f06e88ea3f92deeb773a0e694fc33b7e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8f1d803473b6b93de36fe01b1826d32bf0fe5135414e70dd9344891d7401b59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a96a67711d424f18346674eea7478d9d02435cc0d445b900759d529e440dcdcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4837603139d799e8560119d80de01171262a41a1cd5d36952404ba3d68dae0c6"
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
