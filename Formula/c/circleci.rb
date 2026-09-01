class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.49129",
      revision: "4622d189190084f26df20813e1dcb24420ceb86f"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f832e1c1e463960b282773885a31b721b28b2f75c15795b27c0b37f1546e59a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c94812714e00c1b154c29129daa21990b7e048040092b42c54af2679dfee4901"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a075233b129560659ab7082d33c1b1aa897ac86e52cef423efa9483a47e4b123"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56aa8aaf5c251a8d32e1ba4864d4d2f716413bfbb96bdcaa159921d2dee92949"
    sha256 cellar: :any,                 x86_64_linux:  "c1def633cb5e893b4a76bb2c4c16f1e7d516676e805aa3bcb5bc48a8b1f52e75"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/circleci"

    generate_completions_from_executable(bin/"circleci", "completion")
    system bin/"circleci", "man", "--output", man1/"circleci.1"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    # assert basic script execution
    assert_match(/^circleci #{version} \(\h{12}\)$/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
  end
end
