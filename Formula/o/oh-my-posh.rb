class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.6.1.tar.gz"
  sha256 "717eb60bf8f22ef425ac7784b7533d5a057642f920957d1c7efad2ea4ae1f724"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a3bedb7b9b5727a392106ec1877bc42839f88d2eb0d235766a1bce48916d9f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2b91ec2cee6e4b719bdc214d464f197f0271f3c3d2fd6fb6aa9429c65b8b547"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e3c5ad54f665d0c74c6c03b63a440e02bcd96a72c27e35a74a5cf76e5f1680a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebb0e3006583e50c8e361d4561f2d238b44b59cd21cbe3c57269872ca4fd64e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edded8ae59d700882e96472d06064105dbf19c57e812066f4f7e35d9727dac3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bfd29869085d72576a78965df5c07fce0d39e4a1d6e5aa3511b9f1ef7639d9f"
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
