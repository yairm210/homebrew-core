class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.4.1.tar.gz"
  sha256 "be322b010c5c36af41b0a986ddae91588bc4addf0c99748a9055c08831d563a9"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "083772945fb21b8c7d2777d10ac0cbdcd03d76e9221e07e59dfa332be3258fc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7855cb6e91518ed90a42745f40928e1aa3fc76377db0e1aafd989a97a9d62201"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ae0cc78d6499f838743cbd14522ad28ce63a05db4183b95b4a4fdfb72241020"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c6c1963ec51d8e3117f545dcf1532e4684adb6fde07701f1ecefedc7ad80a10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "862379b33778f0982b8efa7c38db18f03b967a0923a7aefb1480ae535ae47590"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9152df9e4d5e05d3432b71c72463ee065a59846f73cd77c34ae23f46271d086"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end
