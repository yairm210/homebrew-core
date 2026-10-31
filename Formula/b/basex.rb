class Basex < Formula
  desc "Light-weight XML database and XPath/XQuery processor"
  homepage "https://basex.org"
  url "https://files.basex.org/releases/13.0/BaseX130.zip"
  version "13.0"
  sha256 "594cc5e4c3bb8b6e69da3febbb8c39de725112eb7fdffe09ca034b74fc994e72"
  license "BSD-3-Clause"

  livecheck do
    url "https://basex.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/BaseX[._-]?v?(\d+(?:\.\d+)*)\.zip}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9573833187e0f024b87540b26f2f02f8f83b2c9b561572be92410cbeb64915c6"
  end

  depends_on "openjdk"

  def install
    rm Dir["bin/*.bat"]
    rm_r("repo")
    rm_r("data")
    rm_r("etc")

    libexec.install Dir["*"]
    bin.install libexec.glob("bin/*")
    bin.env_script_all_files libexec/"bin", JAVA_HOME: formula_opt_prefix("openjdk")
  end

  test do
    assert_equal "1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n", shell_output("#{bin}/basex '1 to 10'")
  end
end
