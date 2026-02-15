class Unciv < Formula
  desc "Open-source Android/Desktop remake of Civ V"
  homepage "https://github.com/yairm210/Unciv"
  url "https://github.com/yairm210/Unciv/releases/download/4.19.13/Unciv.jar"
  sha256 "f18ee86fbb82d615c4483d909e16c051940c0974b2ae807d6b7c4eda8e6ca207"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:[._-]?patch\d*)?)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, all: "26ecc3a23e36973ff141c92f54687353e3235e30bf1fa2b90c49058c12a121a0"
  end

  depends_on "openjdk"

  def install
    libexec.install "Unciv.jar"
    bin.write_jar_script libexec/"Unciv.jar", "unciv"
  end

  test do
    # Unciv is a GUI application, so there is no cli functionality to test
    assert_match version.to_str, shell_output("#{bin}/unciv --version")
  end
end
