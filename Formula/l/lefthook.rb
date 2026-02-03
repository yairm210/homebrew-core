class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "feb00b91236947383377742a9f6517c91459c73ba38ffc0496c45017e9ff8377"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c8c5d235693efc10b4a96680083ffb999f039a5af3b72313c541c1930d27445"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c8c5d235693efc10b4a96680083ffb999f039a5af3b72313c541c1930d27445"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c8c5d235693efc10b4a96680083ffb999f039a5af3b72313c541c1930d27445"
    sha256 cellar: :any_skip_relocation, sonoma:        "a277a29515c4be4b46cb446da827b87f4e460d08d6c7fced5ba27ae256b5e937"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74d853afc18f22d991d432a80ab617a7f80cadd48b52fcee6fd6b7fe7873e7ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9420e2bb789cb73904819a3af17f0e2b2ec628336b4c7a831cfb531cb02e1b2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "no_self_update")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_path_exists testpath/"lefthook.yml"
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
