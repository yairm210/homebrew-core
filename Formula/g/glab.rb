class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.83.0",
    revision: "b5adf9b12f94ffbfbf0b6b38b1c8a3d60f9b33ad"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c099657cadb63baebd0602e79c83c350430d39372eb35d1771d998a31432f2af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c099657cadb63baebd0602e79c83c350430d39372eb35d1771d998a31432f2af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c099657cadb63baebd0602e79c83c350430d39372eb35d1771d998a31432f2af"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e86e45a65af0cb65093d9960dd615fd20d49de5a2749875660575029a0747d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc14974aeaca97457f9a0638b9239e071f58d2805592561ddf38654748e06424"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc315e0dba3370afb5e3cba786341b35f3a59968d59bb2e741856fcb15e645f7"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?
    system "make"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/cli-automated-testing/homebrew-testing.git"
    cd "homebrew-testing" do
      assert_match "Matt Nohr", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end
