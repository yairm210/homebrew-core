class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.49408",
      revision: "5ff49c6072f0504e22d8adef89c826a32e623e79"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39d81d11edd08acbd36908840630f3cb9f729a722b1f6fc40db35098a8df92c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d59fcf5def1f00ed9a865eaeb5a550a47e4e7e4d42cfc93854f3681d16e68e30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "905e4cf20664bc742c58f19258259c1f3ef48f2e943824c6295eb0e285576cb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df72d9d593d2814e928c9ecad1b2621d772cba5a43a2a091303e604f1d635b36"
    sha256 cellar: :any,                 x86_64_linux:  "dd6bed1a49d77b83be98eca3a9683819cf2bb79d15243537ab5fa9db67beb07b"
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
