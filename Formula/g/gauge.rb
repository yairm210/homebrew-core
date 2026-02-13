class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.23.tar.gz"
  sha256 "c93b2a0b998dfd5e480e9a5cf128f931c54cd6078df2e48060ef9ded74f68536"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ba3d5f37ec156574aa42bfb3907dccdb66df981cdd3d01bc1958143dd0e73f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1cfec0eedf4a4931454af306072223cc70172ef11db3e14935db96d88f59243"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecdb2c6d6cb7203919fe22763dc0d073ea4b151fd9348a8ba4c167816f4ecbdc"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c1deb7644013059bb153d9b5f6fe1968c261d8ac666da38057afa1995520a56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "316ee76969d9a124caa9ea3ec8abc9860bcf3cec9b4498cfd710ee3a840ae9f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b68d8b1492cdadd364a9b4123579d5c497ca0244f3f9669ec10f6237d4e4da39"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build/make.go"
    system "go", "run", "build/make.go", "--install", "--prefix", prefix

    generate_completions_from_executable(bin/"gauge", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"manifest.json").write <<~JSON
      {
        "Plugins": [
          "html-report"
        ]
      }
    JSON

    system(bin/"gauge", "install")
    assert_path_exists testpath/".gauge/plugins"

    system(bin/"gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end
