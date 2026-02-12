class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "560d20e213ac3022cd481ecec80c9ce395b36a7dd26f501350c6f9c64759cb83"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99337aaec1ed9cd73c692279c407e71d418fd04d9a6e989a015d8839a2df0145"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4787af4e9d23ae4fc8b59e793ee279a29995264b65f661c543870034188daa8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c337610c0406a11d5bd56112af2d5db24aca7a7825bb89be97d7da489238c95a"
    sha256 cellar: :any_skip_relocation, sonoma:        "25151b0eb64981dde570d99194a8fbc368e548974f8cd318f23ef437ef20721c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09633f198351f705a0826319e3d2615de38b9da31cca4aa2e51ed6287b12a87d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d41480fe3bb673849e4012fb0ab1d2ac03d56fc8528e9d4edff6d3492e54f6b0"
  end

  depends_on "rust" => :build

  def install
    # Restore default features when frizbee supports stable Rust
    # Issue ref: https://github.com/skim-rs/skim/issues/905
    system "cargo", "install", "--no-default-features", "--features", "cli", *std_cargo_args

    generate_completions_from_executable(bin/"sk", "--shell")
    bash_completion.install "shell/key-bindings.bash"
    fish_completion.install "shell/key-bindings.fish" => "skim.fish"
    zsh_completion.install "shell/key-bindings.zsh"
    man1.install buildpath.glob("man/man1/*.1")
    bin.install "bin/sk-tmux"
  end

  test do
    assert_match(/.*world/, pipe_output("#{bin}/sk -f wld", "hello\nworld"))
  end
end
