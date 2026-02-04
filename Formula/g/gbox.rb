class Gbox < Formula
  desc "Provides environments for AI Agents to operate computer and mobile devices"
  homepage "https://gbox.ai"
  url "https://github.com/babelcloud/gbox/releases/download/v0.1.18/gbox-v0.1.18.tar.gz"
  sha256 "aa487c1ca91d8e6fa58da13b15013bff4d01f42be1b8b40a3ca917cdfe0253fb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a75791e8a81f1f035a56a7fb6a755fb046b414e041ce73fe81ec912db9ae95f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2f780efb9affedc57cdd78d140f9b52782f3a768f6eaed6617a417e3f35c3c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90a6483d80d1b2b4918d37b4d416e46727f964cdb15ceeb4802204e204d812c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae6e84a197068d581fe7c544baef58e6aea7155ef8924502d5c6ac327769c5e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a68f8534773a3d32d7a58459a60a696ab0c84c06a84c9c854890976b3a87985d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dca1364c97e397d5ca45296d173c7a753a5733a2f02d6eb1c0d6b48634affa3"
  end

  depends_on "go" => :build
  depends_on "rsync" => :build
  depends_on "frpc"
  depends_on "yq"

  uses_from_macos "jq", since: :sequoia

  def install
    system "make", "install", "prefix=#{prefix}", "VERSION=#{version}", "COMMIT_ID=#{File.read("COMMIT")}", "BUILD_TIME=#{time.iso8601}"
    generate_completions_from_executable(bin/"gbox", shell_parameter_format: :cobra)
  end

  test do
    # Test gbox version
    assert_match version.to_s, shell_output("#{bin}/gbox --version")

    # gbox validates the API key when adding a profile
    add_output = shell_output("#{bin}/gbox profile add -k xxx 2>&1", 1)
    assert_match "Error: failed to validate API key", add_output

    assert_match "mcpServers", shell_output("#{bin}/gbox mcp export")
  end
end
