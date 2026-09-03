class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.49.1.tar.gz"
  sha256 "3f8798d4985cc89e970804c71f8a4ff4402da54efa84bba04da3dff1b5f7c6b7"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c35b64a323eb241928094cec2765bfbc7111a952aef3f79c97bf4015f84d8cba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0611407a014cde050f2b6cdb83bc8b84930626ac636c9c756edb556dff1e38b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83508dad28705429eb2f7d3ee7bf6b5a0eeb60369c0c2b7b3d5fd6fc24916659"
    sha256 cellar: :any,                 arm64_linux:   "90d3930e6e4c75af1639f9e3638f720fd79c74efd49e6856d6a3bee303b49c2f"
    sha256 cellar: :any,                 x86_64_linux:  "385ec67442a5bf40959db06d41da5ff4022b3545c7c62ad458b50e984f99f697"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
