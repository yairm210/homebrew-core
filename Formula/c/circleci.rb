class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.49221",
      revision: "99cc7ce61c637a4a73171b667836f9825e268555"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e76e305eeed28d105107ef9939e32131db679332b67d0fa41bb1865b2e84f28f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "450253ca08ebc8bcd576f245637c097299c2dbcf437cbbc2b1b88e0e0965e941"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1193f505772fbdef8cd329861e6184a757d97c520e7986c38067a0ac5355ed03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e157752229bb92a49d05283a8856ccc5f46fa032f841554d6889c183cbf03933"
    sha256 cellar: :any,                 x86_64_linux:  "dc0850e5f4478f79b28c4177886ac93684d8778f24bec1e383f608cb1eff3d17"
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
