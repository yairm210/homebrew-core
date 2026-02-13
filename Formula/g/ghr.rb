class Ghr < Formula
  desc "Upload multiple artifacts to GitHub Release in parallel"
  # homepage bug report, https://github.com/tcnksm/ghr/issues/168
  homepage "https://github.com/tcnksm/ghr"
  url "https://github.com/tcnksm/ghr/archive/refs/tags/v0.17.2.tar.gz"
  sha256 "aac4c0cbff1b1980d197dd41f0cabe5a323a5e2ce953c81379787822921facf9"
  license "MIT"
  head "https://github.com/tcnksm/ghr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7af74fdefd5613ea2626b53293b5e96f54efdc19e7ce8f6fd3aebef907c892f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7af74fdefd5613ea2626b53293b5e96f54efdc19e7ce8f6fd3aebef907c892f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7af74fdefd5613ea2626b53293b5e96f54efdc19e7ce8f6fd3aebef907c892f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a709ebba64f1979113f1f08b4d578367371bca3c9524c1042e78aaf01c771993"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45aca92768012544f49f2ec836e6fb5d565649c322501f3e3c9f625a5c4907b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c820b871ad8bdaaa56454e9553896772444c2a4a8a65b5990c8b68a4850e823"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["GITHUB_TOKEN"] = nil
    args = "-username testbot -repository #{testpath} v#{version} #{Dir.pwd}"
    assert_includes "token not found", shell_output("#{bin}/ghr #{args}", 15)
  end
end
