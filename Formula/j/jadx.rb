class Jadx < Formula
  desc "Dex to Java decompiler"
  homepage "https://github.com/skylot/jadx"
  url "https://github.com/skylot/jadx/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "6ae2e92532f3df58b2caf340b26ebb5502b5557a82a905d06249f69a6e9e1396"
  license "Apache-2.0"
  head "https://github.com/skylot/jadx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e37a6436f33757cb59ee48f20d318ee4a37f632847bbd32f0b1b013c2fa873d4"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    system "gradle", "clean", "dist"
    libexec.install Dir["build/jadx/*"]
    bin.install libexec/"bin/jadx"
    bin.install libexec/"bin/jadx-gui"
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    resource "homebrew-test.apk" do
      url "https://raw.githubusercontent.com/facebook/redex/fa32d542d4074dbd485584413d69ea0c9c3cbc98/test/instr/redex-test.apk"
      sha256 "7851cf2a15230ea6ff076639c2273bc4ca4c3d81917d2e13c05edcc4d537cc04"
    end

    resource("homebrew-test.apk").stage do
      system bin/"jadx", "-d", "out", "redex-test.apk"
    end
  end
end
