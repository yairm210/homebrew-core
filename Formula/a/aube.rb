class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://github.com/jdx/aube/archive/refs/tags/v2.2.8.tar.gz"
  sha256 "0c68bb7b37e983a8dccfb05716c6ba5214722327e7f78056567249021d7ab176"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "750566deeba0f5f63741ce3d9f28b063f45c4ed01a43d66e6679e53a4b470326"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "288d5db70184f49183748ea6629c17ee7664bb89823b50e2e01e51c9619c068e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1eb3e0d50e213a70119f6e2169d1c14b81fc278c143c28ae144e6962f2d2b4be"
    sha256 cellar: :any,                 arm64_linux:   "eb5da510a360f08054b4bf5a41448ea470fce3ce61e2068192ec4bf2b6b1944f"
    sha256 cellar: :any,                 x86_64_linux:  "83cf8b0edec94d84f0678bb53ae4795dc9a41532ea797a2380b64c6f18949716"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "usage" => :build
  depends_on "node" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aube")
    generate_completions_from_executable(bin/"aube", "completion")
  end

  test do
    system bin/"aube", "init", "--bare"
    system bin/"aube", "add", "cowsay"
    assert_path_exists testpath/"node_modules/cowsay"
    assert_match "< moo >", shell_output("#{bin}/aubx cowsay moo")
  end
end
