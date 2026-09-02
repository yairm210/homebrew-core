class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.49271",
      revision: "84d93157020cc138e1f3a87cd579eb5b94a94fcb"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9dcaf666340c9e0c1fc67069b1d9bca13cd4c5a9eaddf98bf429019c722cb81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9236ec33ed17ec5ba7193c463f3fa9e67bdfebbf73ae86119cddcebaed6fccef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3260525c33de65e4580b9c299a3882bfd023c0d23f823199b8e77a83404e30b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94220cf447a45a5d5d40c90146270f675977f5e88ee734e0864de8f4e5fe7b29"
    sha256 cellar: :any,                 x86_64_linux:  "59dde57061e42219a95f72ea9c03a8a45d2e18ce2def9bd5c4e6d24337980854"
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
