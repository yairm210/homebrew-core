class Spago < Formula
  desc "PureScript package manager and build tool"
  homepage "https://github.com/purescript/spago"
  url "https://registry.npmjs.org/spago/-/spago-1.0.3.tgz"
  sha256 "c19564dfd1653baf6d458e3727c8849d4ab4b0ab321bd3fa4608058f3c1e9256"
  license "BSD-3-Clause"
  head "https://github.com/purescript/spago.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d5eab4b1fb90ac9d885b97b5babd968405a5d5de9e868646f9a999eda30ea46"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1c516a357d01efcef8d2dc263ca4785c24b3e48559974925e8dfd985a672bf3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ff1f1056aefbd2ea4e1ebc0a4415aefab0a21f09e0c90e6ddc0b5e732d75c79"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0765e9b2ba05a82406efa85966071307b4021c95f6c5ad824a73f2911063856"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ae60344eaff53522d7e77d7962acccbfece42817364786718412edc50d2cadf"
    sha256 cellar: :any_skip_relocation, ventura:        "68fa6a6d91f5feee9201731301dbc041654266314ec842dfc4a8998db2d7f38e"
    sha256 cellar: :any_skip_relocation, monterey:       "cc9358258247e523961b0ebe1647c5559249ef65693ebff3c23fb0bf176f5edc"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f29c49a689127cf34f05f415d5c980eeea7e6b3c6e7b9df2214b5430f913f03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa71b6e0cbd41ac5c0bb966030f1fe4ca2d1dbc11c19162a9407cd0d0d5d82ab"
  end

  depends_on "node"
  depends_on "purescript"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"spago", "init"
    assert_path_exists testpath/"spago.yaml"
    assert_path_exists testpath/"src/Main.purs"
    system bin/"spago", "build"
    assert_path_exists testpath/"output/Main/index.js"
  end
end
