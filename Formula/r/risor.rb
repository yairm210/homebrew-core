class Risor < Formula
  desc "Fast and flexible scripting for Go developers and DevOps"
  homepage "https://risor.io/"
  url "https://github.com/deepnoodle-ai/risor/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "053fd2a8057d4387ae746047f7f22dabe8c8c75f1fa1cee0ded50a74f33bb5f9"
  license "Apache-2.0"
  head "https://github.com/deepnoodle-ai/risor.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9fa1f0a219076692f4d706b20ff80d9cda637bcd7931f23741df89821034c3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbde2b6182c072e849a12ce36d6d755fa3200ad92eb57cd2e93e3f35002eebff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f37c60002f16060e38608ac832e31a7a93b8e0e0898d7f426f9cb959fe9c15f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "480b7d9c82591f64df23374c598093ba5b2236d94704054411b19e64a126a9ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65c8acf273932b60bbde57501e3386e3c6f35fd22d42e307215aac5184f0c10d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e771596e692a98b4b5d9bc11d73bbc0685edcfb6c856c7e561572a19e09f6e2"
  end

  depends_on "go" => :build

  def install
    chdir "cmd/risor" do
      ldflags = "-s -w -X 'main.version=#{version}' -X 'main.date=#{time.iso8601}'"
      tags = "aws,k8s,vault"
      system "go", "build", *std_go_args(ldflags:, tags:)
      generate_completions_from_executable(bin/"risor", shell_parameter_format: :cobra,
                                                        shells:                 [:bash, :zsh, :fish])
    end
  end

  test do
    output = shell_output("#{bin}/risor -c \"len([1, 2, 3])\"")
    assert_equal "3\n", output
    assert_match version.to_s, shell_output("#{bin}/risor version")

    assert_match "_risor_completion", shell_output("#{bin}/risor completion bash")
    assert_match "unsupported shell: powershell",
                 shell_output("#{bin}/risor completion powershell 2>&1", 1)
  end
end
