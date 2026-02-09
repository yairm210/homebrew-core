class Risor < Formula
  desc "Fast and flexible scripting for Go developers and DevOps"
  homepage "https://risor.io/"
  url "https://github.com/deepnoodle-ai/risor/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "231b2570f78865cc89f9962d7704353511bef3bfd3c9e70096a56a244b4ba5bf"
  license "Apache-2.0"
  head "https://github.com/deepnoodle-ai/risor.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc9073bb45f701f9ff39c4d43795b1f0114d8fe99b213a4d5e56cab834372ec0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dae7920cf800de73af866037c0f400e40dda6b26ca5dea1024a833416c20fbe4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e4fb4390f4d183ce641ca7cb7173d69ead4ab3ea8424cfa70a895b3a41cda12"
    sha256 cellar: :any_skip_relocation, sonoma:        "952d9b3f1b7a0d6c5d155f7dbba7e6ed4d3496f72e6d730ab67ebe807e277b71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46bfe28dea231137267ef0d4363a64b468980f6861fd4f74c0cc136f06efbd67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cfa38a0b092a0f6d3907e181c93624ed96eecbc52d037fc466d01af33d6b386"
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
