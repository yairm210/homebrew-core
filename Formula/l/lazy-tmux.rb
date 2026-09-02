class LazyTmux < Formula
  desc "Save all your tmux sessions and lazy restore them"
  homepage "https://lazy-tmux.xyz"
  url "https://github.com/alchemmist/lazy-tmux/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "213dc4002a22fad2e37d0805dad59aa76c47b838bcaeb6291c7b3860ee7eb92f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22ad50c9f29649b24b3dda11cbc721a3dddf5bebda9c53a8d79a59edb709fea4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22ad50c9f29649b24b3dda11cbc721a3dddf5bebda9c53a8d79a59edb709fea4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22ad50c9f29649b24b3dda11cbc721a3dddf5bebda9c53a8d79a59edb709fea4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3d69269d779cec01b19d9ee3c54e16348fc9ae2ef84006e116f0be2b65bcd00"
    sha256 cellar: :any,                 x86_64_linux:  "268656bf6a3bd02dee4916564cf50703616e1fabd2d5d758f79e906c0c532696"
  end

  depends_on "go" => :build

  depends_on "tmux"

  def install
    system "go", "build", *std_go_args, "./cmd/lazy-tmux"
  end

  test do
    config = testpath/"lazy-tmux.toml"
    ENV["LAZY_TMUX_CONFIG"] = config
    system bin/"lazy-tmux", "config", "gen"
    assert_match "# config source: #{config}\n", shell_output("#{bin}/lazy-tmux config show")
  end
end
